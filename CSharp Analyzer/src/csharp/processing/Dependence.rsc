module csharp::processing::Dependence

import IO;
import List;

import csharp::processing::statement::Handler;
import csharp::processing::Globals;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::statement::Block;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::utils::utils;
import csharp::processing::utils::locationIncluder;

public void AddDependence(AstNode n, Statement s) = ExtendRelDependence(n,s);
public void AddDependence(AstNode node1, AstNode node2) = ExtendRelDependence(node1,node2);
public void AddDependence(Statement s, list[Statement] statements) = AddDependence(s, [StatementLoc(s) | s<-statements]); 
public void AddDependence(Statement s, list[AstNode] astnodes) { for(ast<-astnodes) AddDependence(s, ast); }
public void AddDependence(Statement s, Expression e) = AddDependence(s, ExpressionLoc(e));
public void AddDependence(Statement s, Statement s2) = AddDependence(s, StatementLoc(s2));
public void AddDependence(Statement s, AstNode astnode) = AddDependence(s, astnode, false);
public void AddDependence(Statement s, AstNode astnode, bool isReadOperation) = AddDependence(s, astnode, isReadOperation, false);
public void AddDependence(Statement s, AstNode astnode, bool isReadOperation, bool fromInvocationHandler)
{
	//add a dependence from s to astnode.
	//if the node is an expression, it is either a memberReferenceExpression or a identifierExpression
	//in these cases, find the last known assign or read statement, and add a dependence from s to this.
	//if this last known assign or read statement is in an optional path, add the condition for this as a dependence from s to it.
	//then find the next assign or read statement before the one in the optional path, and repeat untill one is found that is not inside an optional path.
	//
	//isReadOperation indicates whether we are looking at assignments or read operations
	//fromInvocationHandler indicates if the function is called from the invocation-handler function.
	//	this is to avoid double execution

	if(astnode is expression)
	{
		if(astnode.nodeExpression is memberReferenceExpression)
		{
			resolved = ResolveMemberReference(astnode.nodeExpression);
			
			if(resolved is astNodePlaceholder) //added for enum
				return; 
				
			uniqueName = GetUniqueNameForResolvedIdentifier(astnode.nodeExpression.memberName, resolved);

			s2 = emptyStatement();
			if(isReadOperation)
			{
				if(uniqueName in mapReads)
					s2 = GetLastListElement(mapReads[uniqueName]);
			}
			else
			{
				if(uniqueName in mapAssignments)
					s2 = GetLastListElement(mapAssignments[uniqueName]);
			}
			
			if(s2 is emptyStatement)
			{
				//the member was not assigned inside the body
				//so it just depends on the member itself
				ExtendRelDependence(s, resolved);
			}
			else
			{
				//we found the last assignment, check if its inside an optional path
				if(s2 is expressionStatement)
					CheckForOptionalPath(uniqueName, StatementLoc(s2), s, isReadOperation);
				else
					CheckForOptionalPath(uniqueName, s2, s, isReadOperation);
			}
		}
		else if(astnode.nodeExpression is identifierExpression)
		{
			if(astnode.nodeExpression has \type &&
			   astnode.nodeExpression.\type is exactType)
		   	{
				tp = GetNodeByExactType(astnode.nodeExpression.\type);
				
				//if the type is unknown, it is probably from an external library and 
				//will not contain dependencies to places inside the project
				//or so we presume.
				if(tp == astNodePlaceholder() ||
				   tp.nodeAttributedNode has classType &&
			       tp.nodeAttributedNode.classType == enum()) //skip unsupported enums
		   			return;
			}
						
			//it can be a invocationexpression
			AstNode parent = GetParent(astnode);
			if(parent is expression &&
			   parent.nodeExpression is invocationExpression && 
			   !fromInvocationHandler)
			   return; //Only handle when coming from the invocation statement itself
			
			//the dependence is to an identifier, check where it was last assigned.
			memberName = astnode.nodeExpression.identifier;

			//check if the identifier is "value", in that case were inside an accessor and can ignore the statement
			if(memberName == "value")
				return;
			
			AstNode s2 = statement(emptyStatement());
			str uniqueName = GetUniqueNameForIdentifier(astnode.nodeExpression);
			
			if(isReadOperation)
			{
				//it might be a local-var (for/using/etc)
				a = mapReads;
				if(uniqueName in mapReads)
					s2 = GetLastListElement(mapReads[uniqueName]);
			}
			else
			{
				//it might be a local-var (for/using/etc)
				if(uniqueName in mapAssignments)
					s2 = StatementLoc(GetLastListElement(mapAssignments[uniqueName]));
				else
					s2 = GetLastLocalAssignment(memberName);
			}
			
			if(	s2 is statement &&
				s2.nodeStatement is emptyStatement ||
				s2 is astNodePlaceholder)
			{
				//astnode isnt assigned inside the body, its a parameter
				if(memberName in mapParameters)
				{
					//astnode is a parameter, add to the depMap
					p = mapParameters[memberName];
					ExtendRelDependence(s,p);
				}
				else
				{
					//has not been assigned in this block, nor is it a parameter.
					//it is a field/prop, add a dependence to the declaration
					resolved = ResolveIdentifier(astnode.nodeExpression);
					ExtendRelDependence(s,resolved);
				}
			}
			else
			{
				//we found the last assignment, check if its inside an optional path
				CheckForOptionalPath(uniqueName, s2, s, isReadOperation);
			}
		}
	}
	else	
	{
		//if none of the above:
		//	nothing complicated, just add the new dependence
		ExtendRelDependence(s,astnode);
	}
}
private void CheckForOptionalPath(str uniqueName, AstNode s2, Statement s, bool isReadOperation)
{
	//check if s2 is inside an optional path (if/switch/do/for/etc)
	//if so, return the statement as a depenceny
	//also return the last assignment before the if/switch-statement
	listStatements = InsideOptionalPath(uniqueName, s, s2, [], isReadOperation);
	
	if(!(isEmpty(listStatements ))) //add the found dependency statements to the rel
		ExtendRelDependence(s,listStatements);
	else //its not inside an optional path
		ExtendRelDependence(s,s2);
}
public void AddDependenceToIdentifiersInExpression(Expression condition, Statement s)
{
	visit(condition)
	{
		case i:identifierExpression(_,_,_):	AddDependence(s,i);
	}
}
public void AddDependenceForBranch(Statement branch, Statement s) = AddDependenceForBranch(branch, StatementLoc(s));
public void AddDependenceForBranch(Statement branch, AstNode s)
{
	//the statements depend on the branch-statement and
	//the branch-statement depends on all the dependencies of its statements
	// --> the dependencies of the statements have to be executed before the branch-statement can be executed.
	for(subS <- GetStatementsFromBranch(branch))
	{
		AddDependence(subS, s);
		AddDependence(s, subS);
	}
}

list[Statement] GetStatementsFromBranch(Statement branch)
{
	list[Statement] lstStatements = [];
	
	if(branch is emptyStatement)
		//The branch is not there, for example an if without else.
		lstStatements = [];
			
	else if(!(branch is blockStatement))
		//Its a single statement without { and }
		lstStatements  += branch;
	
	else if(!isEmpty(branch.statements))
		//it's a non-empty set of statements
		lstStatements = branch.statements;
		
	return lstStatements;
}

void ExtendRelDependence(Statement from, list[AstNode] tos) 	= ExtendRelDependence(StatementLoc(from), tos);
void ExtendRelDependence(Statement from, Statement to) 			= ExtendRelDependence(StatementLoc(from), [StatementLoc(to)]);
void ExtendRelDependence(AstNode from, Statement to)			= ExtendRelDependence(from, [StatementLoc(to)]);
void ExtendRelDependence(AstNode from, AstNode to)				= ExtendRelDependence(from, [to]);
void ExtendRelDependence(Statement from, AstNode to)			= ExtendRelDependence(StatementLoc(from), [to]);
void ExtendRelDependence(AstNode from, list[AstNode] tos)
{
	for(to<-tos)
	{
		if(!(to@location)? || !(from@location)?)
		{
			br=1;
			throw "location annotation missing";
		}
		relDependence += <<from,from@location>, <to,to@location>>;
	}
}
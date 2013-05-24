module csharp::processing::Dependence

import IO;
import List;

import csharp::processing::statement::Handler;
import csharp::processing::Globals;
import csharp::syntax::CSharpSyntax;
import csharp::processing::statement::Block;
import csharp::processing::typeDeclaration::Main;
import utils::utils;


public void AddDependence(Statement s, Expression e)
{
	AddDependence(s, expression(e));
}

public void AddDependence(Statement s, Statement s2)
{
	AddDependence(s, statement(s2));
}

public void AddDependence(AstNode node1, AstNode node2)
{
	relDependence += <node1,node2>;
}

// Statement s is dependent on the last assignment of Astnode astnode
// which is a local expressionStatement, a parameter or a memberDeclaration(with initializer)
public void AddDependence(Statement s, AstNode astnode)
{
	if(astnode is expression)
	{
		if(astnode.nodeExpression is memberReferenceExpression)
		{
			resolved = ResolveMemberReference(astnode.nodeExpression);
			uniqueName = GetUniqueNameForResolvedIdentifier(astnode.nodeExpression.memberName, resolved);

			s2 = emptyStatement();
			if(uniqueName in mapAssignments)
				s2 = GetLastListElement(mapAssignments[uniqueName]);
			
			if(s2 is emptyStatement)
			{
				//the member was not assigned inside the body
				//so it is just dependant on the member itself
				relDependence += <statement(s), resolved>;
			}
			else
			{
				//we found the last assignment, check if its inside an optional path
				if(s2 is expressionStatement)
					CheckForOptionalPath(uniqueName, statement(s2), s);
				else
					CheckForOptionalPath(uniqueName, s2, s);
			}
			return;
		}
		else if(astnode.nodeExpression is identifierExpression)
		{
			//the dependence is to an identifier, check where it was last assigned.
			memberName = astnode.nodeExpression.identifier;

			//check if the identifier is "value", in that case were inside an accessor and can ignore the statement
			if(memberName == "value")
				return;
			
			AstNode s2 = statement(emptyStatement());
			str uniqueName = GetUniqueNameForIdentifier(astnode.nodeExpression);
			
			if(uniqueName in mapAssignments)
				s2 = statement(GetLastListElement(mapAssignments[uniqueName]));
			//it might be a local-var (for/using/etc)
			else
				s2 = GetLastLocalAssignment(memberName);
			
			if(	s2 is statement &&
				s2.nodeStatement is emptyStatement ||
				s2 is astNodePlaceholder)
			{
				//astnode isnt assigned inside the body, its a parameter
				if(memberName in mapParameters)
				{
					//astnode is a parameter, add to the depMap
					p = mapParameters[memberName];
					relDependence += <statement(s), p>;
				}
				else
				{
					//has not been assigned in this block, nor is it a parameter.
					//it is a field/prop, add a dependence to the declaration
					resolved = ResolveIdentifier(astnode.nodeExpression);
					relDependence += <statement(s), resolved>;
				}
			}
			else
			{
				//we found the last assignment, check if its inside an optional path
				CheckForOptionalPath(uniqueName, s2, s);
			}
			return;
		}
	}
	
	//if none of the above:
	//	nothing complicated, just add the new dependence
	relDependence += <statement(s), astnode>;
}
private void CheckForOptionalPath(str uniqueName, AstNode s2, Statement s)
{
	//check if s2 is inside an optional path (if/switch/do/for/etc)
	//if so, return the statement as a depenceny
	//also return the last assignment before the if/switch-statement
	listStatements = InsideOptionalPath(uniqueName, s, s2, []);
	
	if(!(isEmpty(listStatements ))) //add the found dependency statements to the rel
		for(s3 <- listStatements) 
			relDependence += <statement(s), s3>;
	
	else //its not inside an optional path
		relDependence += <statement(s), s2>;
}


public void AddDependenceToIdentifiersInExpression(Expression condition, Statement s)
{
	visit(condition)
	{
		case i:identifierExpression(_,_,_):	AddDependence(s,i);
	}
}

public void AddDependenceForBranch(Statement branch, Statement s)
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
		
	for(subS <- lstStatements)
		AddDependence(subS, s);
}
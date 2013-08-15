module csharp::processing::statement::Handler

import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::statement::Block;
import csharp::processing::Dependence;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::expression::Handler;
import csharp::processing::utils::utils;
import csharp::processing::utils::locationIncluder;

import IO;
import List;

import csharp::processing::Globals;

public void Handle(Statement s1)
{
	println("unhandled statement: <s1>");
}
public void Handle(emptyStatement())
{
	return;
}
public void Handle(breakStatement())
{
	return;
}

public void Handle(Statement s:ifElseStatement(Expression c, Statement elseBranch, Statement ifBranch))
{
	AddDependenceToIdentifiersInExpression(c, s);
	AddDependenceForBranch(ifBranch, s);
	AddDependenceForBranch(elseBranch, s);
}

public void Handle(Statement s:variableDeclarationStatement(list[Modifiers] modifiers, list[AstNode] variables, AstType \type))
{
	Statement TopMostStatement = GetTopMostParentStatement(s);

	for(variable <- variables)
	{
		parent = FindParentAttributedNode(s);
				
		mapAttributedNodeDeclarations = AddToTupleMap(mapAttributedNodeDeclarations, parent, s);
	
		if(!(variable.initializer is emptyExpression))
		{
			AddNewAssignment(s, TopMostStatement);
						
			visit(variable.initializer)
			{
				case i:identifierExpression(_,_,_):
				{
					if(TopMostStatement is emptyStatement)
						AddDependence(s, i);
					else
						AddDependence(TopMostStatement, i);
				}
			}
		}
	}
}

public void Handle(Statement s:switchStatement(Expression expression, list[AstNode] switchSections))
{
	AddDependenceToIdentifiersInExpression(expression, s);
		
	for(section <- switchSections, statement <- section.statements)
		AddDependenceForBranch(statement, section);
	
}

public void Handle(Statement s:returnStatement(Expression exp))
{
	visit(exp)
	{
		case v:identifierExpression(_,_,_):
		{
			AddDependence(s,v);
		
			//check if the identifier is a field, property or functioncall
			//if so, add a dependence between the parent attributed node and the field/prop/function
			//don't do this for local fields or parameters
			resolved = ResolveIdentifier(v);
			if( resolved is attributedNode &&
				resolved.nodeAttributedNode is memberDeclaration &&
			   (resolved.nodeAttributedNode.nodeMemberDeclaration is fieldDeclaration ||
			    resolved.nodeAttributedNode.nodeMemberDeclaration is propertyDeclaration))
		   	{
			   	parent = FindParentAttributedNode(s);
			   	AddDependence(parent, resolved);
			}
		}
		case v:memberReferenceExpression(_,_,_):
		{
			//the return statement used a memberreference,
			//add a dependence to the declaration of the prop/field/function
			resolved  = ResolveMemberReference(v);
			
			//this is not correct:
			if(resolved != astNodePlaceholder())
			{
				AddDependence(s, resolved);
				
				//the parent of the statement also depends on the prop/field/function
				parent = FindParentAttributedNode(s);
				AddDependence(parent, resolved);
			}
		}
	}
}

public void Handle(Statement s:doWhileStatement(Expression condition, Statement embeddedStatement))
{
	AddDependenceToIdentifiersInExpression(condition, s);
	AddDependenceForBranch(embeddedStatement, s);
}
public void Handle(Statement s:whileStatement(Expression condition, Statement embeddedStatement))
{
	AddDependenceToIdentifiersInExpression(condition, s);
	AddDependenceForBranch(embeddedStatement, s);
}
public void Handle(Statement s:forStatement(Expression condition, Statement embeddedStatement, list[Statement] initializers, list[Statement] iterators))
{
	visit(initializers)
	{
		case as:assignmentExpression(left,_,_):				AddNewAssignment(left, s);
		case v:variableDeclarationStatement(_,_,_):			AddLocalAssignment(v, s);
	}
	
	visit(iterators)
	{
		case i:identifierExpression(name,_,_):		;//todo add dep to used iterator
	}
	
	AddDependenceToIdentifiersInExpression(condition, s);
	
	AddDependenceForBranch(embeddedStatement, s);
}
public void Handle(Statement s:foreachStatement(Statement embeddedStatement, Expression inExpression, str variableName))
{
	AddDependenceToIdentifiersInExpression(inExpression, s);
	
	uniqueName = GetUniqueNameForResolvedIdentifier(variableName, s);
	AddLocalAssignment(StatementLoc(s), uniqueName, StatementLoc(s));
	
	AddDependenceForBranch(embeddedStatement, s);
}
public void Handle(Statement s:tryCatchStatement(Statement tryBlock, list[AstNode] catchClauses, Statement finallyBlock))
{
	//nothing to do here..?
}
public void Handle(AstNode c:catchClause(_, variableName, Type))
{
	uniqueName = GetUniqueNameForResolvedIdentifier(variableName, c);
	AddLocalAssignment(c, uniqueName, c);
	
	//TODO catch statements depend on try statements?
}
public void Handle(Statement s:usingStatement(AstNode resourceAcquisition, Statement embeddedStatement))
{
	//nothing to do here.. Carry on.. :)
	//handled in variable declaration
}
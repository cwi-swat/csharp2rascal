module csharp::processing::statement::Handler

import csharp::syntax::CSharpSyntax;
import csharp::processing::statement::Block;
import csharp::processing::Dependence;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::expression::Handler;
import utils::utils;

import IO;
import List;

import csharp::processing::Globals;


public void Handle(Statement s1, Statement s2)
{
	println("unhandled statement: <s1>");
}
public void Handle(emptyStatement(), Statement s)
{
	return;
}
public void Handle(breakStatement(), Statement s)
{
	return;
}


public void Handle(ifElseStatement(Expression c, Statement ifBranch, Statement elseBranch), Statement s)
{
	visit(c)
	{
		case i:identifierExpression(_,_,_):	AddDependence(s,i);
	}

	//get all the embedded statements
	statements = GetStatementsFromBranch(ifBranch);
	statements += GetStatementsFromBranch(elseBranch);
	
	//add a dependence to the IfElseStatement
	for(subS <- statements)
	{
		AddDependence(subS, s);
	}
}

public void Handle(variableDeclarationStatement(list[Modifiers] modifiers, list[AstNode] variables, AstType \type), Statement s)
{
	for(variable <- variables)
	{
		parent = FindParentAttributedNode(s);
				
		mapAttributedNodeDeclarations = AddToMap(mapAttributedNodeDeclarations, parent, statement(s));
	
		if(!(variable.initializer is emptyExpression))
		{
			AddNewAssignment(s, s);
						
			visit(variable.initializer)
			{
				case i:identifierExpression(_,_,_):	AddDependence(s, i);
			}
		}
	}
}

public void Handle(switchStatement(Expression expression, list[AstNode] switchSections), Statement s)
{
	visit(expression)
	{
		case i:identifierExpression(_,_,_):		AddDependence(s,i);
	}
	
	for(section <- switchSections)
	{ 
		for(statement <- section.statements)
			AddDependence(statement, s);
	}
}

public void Handle(returnStatement(Expression exp), Statement s)
{
	visit(exp)
	{
		case v:identifierExpression(_,_,_):
		{
			AddDependence(s,v);
		
			//check if the identifier is a field or a property
			//if so, add a dependence between the parent attributed node and the field/prop
			//don't do this for local fields or parameters
			resolved = ResolveIdentifier(v, s); 
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
			//add a dependence to the declaration of the prop/field/(function?)
			resolved  = ResolveMemberReference(v,s);
			AddDependence(s, resolved);
			
			//the parent of the statement also depends on the prop/field/(function?)
			parent = FindParentAttributedNode(s);
			AddDependence(parent, resolved);
		}
	}
}

public void Handle(doWhileStatement(Expression condition, Statement embeddedStatement), Statement s)
{
	visit(condition)
	{
		case i:identifierExpression(_,_,_):	AddDependence(s,i);
	}

	statements = GetStatementsFromBranch(embeddedStatement);
	for(subS <- statements)
	{
		AddDependence(subS, s);
	}
}
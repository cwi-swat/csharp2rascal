module csharp::processing::statement::Handler

import csharp::syntax::CSharpSyntax;
import csharp::processing::statement::Block;
import csharp::processing::Dependence;
import csharp::processing::typeDeclaration::Main;
import utils::utils;

import IO;
import List;

import csharp::processing::Globals;

public void Handle(emptyStatement(), Statement s)
{
	return;
}

public void Handle(ifElseStatement(Expression c, Statement ifBranch, Statement elseBranch), Statement s)
{
	visit(c)
	{
		case i:identifierExpression(_,_):	AddDependence(s,i);
	}

	list[Statement] lstTrueStatements = [];
	if(!(s.trueStatement is blockStatement))
	{
		lstTrueStatements += s.trueStatement;
	}
	else if(!isEmpty(s.trueStatement.statements))
	{
		lstTrueStatements = s.trueStatement.statements;
	}
	for(subS <- lstTrueStatements)
	{
		AddDependence(subS, s);
	}
	Handle(blockStatement(lstTrueStatements), s);
	
	if(!(s.falseStatement is emptyStatement))
	{
		list[Statement] lstFalseStatements = [];
		if(!(s.falseStatement is blockStatementPlaceholder))
		{
			lstFalseStatements += s.falseStatement;
		}
		else if(!isEmpty(s.falseStatement.statements))
		{
			lstFalseStatements = s.falseStatement.statements;
		}
		
		if(!isEmpty(lstFalseStatements))
		{
			for(subS <- lstFalseStatements)
			{
				AddDependence(subS, s);
			}
			Handle(blockStatement(lstFalseStatements), s);
		}
	}
}

public void Handle(variableDeclarationStatement(list[Modifiers] modifiers, list[AstNode] variables, AstType \type), Statement s)
{
	for(variable <- variables)
	{
		parent = GetParent(statement(s));
		while(!(parent is attributedNode))
		{
			parent = GetParent(parent);;
		}
		
		mapAttributedNodeDeclarations = AddToMap(mapAttributedNodeDeclarations, parent, statement(s));
	
		left = identifierExpression(variable.name, []);
		right = variable.initializer;
		if(!(right is emptyExpression))
		{
			mapAssignments = AddToMap(mapAssignments, left, s);
			
			visit(right)
			{
				case i:identifierExpression(_,_):	AddDependence(s, i);
			}
		}
	}
}

public void Handle(switchStatement(Expression expression, list[AstNode] switchSections), Statement s)
{
	for(section <- switchSections) 
		Handle(section, s);
}

public void Handle(switchSection(list[AstNode] caseLabels, list[Statement] statements), Statement s)
{
	for(st <- statement)
		Handle(st,st);
}
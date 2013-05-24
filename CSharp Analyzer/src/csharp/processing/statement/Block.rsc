module csharp::processing::statement::Block

import csharp::syntax::CSharpSyntax;
import csharp::processing::statement::Handler;
import csharp::processing::Dependence;
import csharp::processing::Globals;
import csharp::processing::expression::Handler;
import utils::utils;
import IO;

import csharp::processing::typeDeclaration::Main;

public void Handle(Statement s:blockStatement(list[Statement] statements))
{
	//prepare the listLinqIdentifiers so they can be resolved later
	visit(statements)
	{
		case l:queryExpression(clauses):				Handle(l);
	}

	top-down visit(statements)
	{
		case st:variableDeclarationStatement(_,_,_):	FilterAndHandle(st);
		case st:ifElseStatement(_,_,_):					FilterAndHandle(st);
		case st:switchStatement(_,_):					FilterAndHandle(st);
		case st:doWhileStatement(_,_):					FilterAndHandle(st);
		case st:whileStatement(_,_):					FilterAndHandle(st);
		case st:forStatement(_,_,_,_):					FilterAndHandle(st);
		case st:foreachStatement(_,_,_):				FilterAndHandle(st);
		case st:tryCatchStatement(t,catchClauses,f):	FilterAndHandle(st);
		case ast:catchClause(_,_,_):					FilterAndHandle(ast);
		case st:usingStatement(_,_):					FilterAndHandle(st);
		case st:returnStatement(_):						FilterAndHandle(st);
		case st:expressionStatement(_):					FilterAndHandle(st);
		case e:conditionalExpression(_,_,_):			FilterAndHandle(e);
		
		//may be too complex for given time
		//case e:lambdaExpression(_,_):					FilterAndHandle(e);
		
		//May not be relevant:
		//Throw
		//unsafe/fixed/checked/unchecked
		//lock
		//yield
	}
}
public void FilterAndHandle(AstNode ast)
{
	FilterLocalAssignments(ast);
	Handle(ast);
}
public void FilterAndHandle(Statement st)
{
	FilterLocalAssignments(statement(st));
	Handle(st);
}
public void FilterAndHandle(Expression e)
{
	FilterLocalAssignments(expression(e));
	Handle(e);
}
module csharp::processing::statement::Block

import csharp::syntax::CSharpSyntax;
import csharp::processing::statement::Handler;
import csharp::processing::Dependence;
import csharp::processing::Globals;
import csharp::processing::expression::Handler;
import utils::utils;
import IO;

import csharp::processing::typeDeclaration::Main;

public void Handle(blockStatement(list[Statement] statements), Statement s)
{
	top-down visit(statements)
	{
		case st:variableDeclarationStatement(_,_,_):	Handle(st,st);
		case st:ifElseStatement(_,_,_):					Handle(st,st);
		case st:switchStatement(_,_):					Handle(st,st);
		case st:doWhileStatement(_,_):					Handle(st,st);
		case st:whileStatement(_,_):					Handle(st,st);
		case st:forStatement(_,_,_,_):					Handle(st,st);
		case st:returnStatement(_):						Handle(st,st);
		case st:expressionStatement(_):					Handle(st,st);
		//foreach
		//trycatch
		//using
		//lock?
		//yield?
	
		//unsafe/fixed/checked/unchecked
		
		//etc?		
	}
}
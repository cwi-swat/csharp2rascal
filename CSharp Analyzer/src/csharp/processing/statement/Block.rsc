module csharp::processing::statement::Block

import csharp::syntax::CSharpSyntax;
import csharp::processing::statement::Handler;
import csharp::processing::Dependence;
import csharp::processing::Globals;
import csharp::processing::expression::Handler;
import utils::utils;
import IO;

public void Handle(blockStatement(list[Statement] statements), Statement s)
{
	top-down visit(statements)
	{
		case st:variableDeclarationStatement(_,_,_):	Handle(st,st);
		case st:ifElseStatement(_,t,f):					Handle(st,st);
		case st:switchStatement(_,_):					Handle(st,st);
		case st:expressionStatement(e):					Handle(e,st);
		//do
		//while
		//for
		//foreach
		//etc?
	}
}
//private void DepOnParent(Statement s)
//{
//	if(s is blockStatement)
//		DepOnParent(s.statements);
//	else
//		DepOnParent([s]);
//}
//
//private void DepOnParent(list[Statement] statements)
//{
//	for(s <- statements)
//		AddDependence(s, parent(s));
//}
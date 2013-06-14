module csharp::analyzing::slices::Block

import List;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::Globals;
import csharp::processing::utils::locationIncluder;

import csharp::analyzing::slices::Independent;

public map[AstNode,list[list[tuple[AstNode,loc]]]] FindBlockSlices(list[Statement] statements)
{
	//Each blockStatement can contain a few slices
	map[AstNode BlockNode,list[list[tuple[AstNode,loc]]] Slices] mapBlockSlices = ();
	
	visit(statements)
	{
		case b:blockStatement(body):
		{
			mapBlockSlices += (StatementLoc(b):FindIndependentSlices(body));
		}
	}
	return mapBlockSlices;
}
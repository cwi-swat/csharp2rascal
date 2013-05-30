module csharp::analyzing::slices::Sub

import List;
import csharp::syntax::CSharpSyntax;
import csharp::processing::Globals;
import csharp::processing::utils::locationIncluder;

import csharp::analyzing::slices::Independent;

public list[list[tuple[AstNode,loc]]] FindSubSlices(list[Statement] statements)
{
	list[list[tuple[AstNode,loc]]] lstSubSlices = [];
	list[Statement] lstTail = tail(statements);
	while(size(lstTail) > 1)
	{
		lstSubSlices += FindIndependentSlices(lstTail);
		lstTail = tail(lstTail);
	}
	
	return lstSubSlices;
}
module utils::utils

import csharp::syntax::CSharpSyntax;
import csharp::processing::Globals;
import List;
import IO;

public Statement GetLastListElement(list[Statement] _list)
{
	if(isEmpty(_list))
		return emptyStatement();

	return head(reverse(_list));
}

public AstNode GetLastListElement(list[AstNode] _list)
{
	AstNode lastAstNode;
	
	if(isEmpty(_set))
		return astNodePlaceholder();

	return head(reverse(_list));
}

public map[str name, list[AstNode] a] AddToMap(map[str name, list[AstNode] a] m, str key, AstNode val)
{
	if(key in m)
		m[key] += [val];
	else
		m += (key:[val]);
		
	return m;
}
public map[Expression name, list[Statement] s] AddToMap(map[Expression name, list[Statement] s] m, Expression key, Statement val)
{
	if(key in m)
		m[key] += [val];
	else
		m += (key:[val]);

	return m;
}

public list[Statement] InsideOptionalPath(Expression e, Statement s, map[Expression name, list[Statement] s] mapAssignments, map[str name, list[AstNode] a] mapTypeMemberAssignments)
{
	//e = identifier we are dependant on
	//s = statement we have to check for optional path
	//  -> the last assignment statement for our identifier
	
	for(d <- relDependence[statement(s)])
	{
		Statement subS = d.nodeStatement;
		if(subS is ifElseStatement ||
		   subS is switchSection)
		{
			//the last assignment of e is inside of an optional path
			//return the if or switch statement as dependency
			
			//also add the assignment that was before the optional path as a dependency
			//because the optional path might not get executed, and the assignment before it will be the last assignment for e
			Statement Assignment = emptyStatement();
			
			for(assignS <- reverse(mapAssignments[e]))
			{
				for(d <- relDependence[statement(assignS)])
				{
					if(d.nodeStatement != subS)
					{
						//this dependency is not the same as the if/switch statement
						Assignment = d.nodeStatement;
					}
					if(!(Assignment is emptyStatement))
						break;
				}
				
				if(isEmpty(relDependence[statement(assignS)]))
				{;}
				
				//check if the assignment with a different dependency (so not the if/switch) was found
				//or if this assignment does not have any dependency -> different
				if(!(Assignment is emptyStatement))
						break;
			}
			
			return subS;
		}
	}
	
	//the last assignment was not inside an optional path.
	return [];
}

module csharp::analyzing::slices::Independent

import Set;
import Map;
import csharp::CSharpSyntax::CSharpSyntax;
//import csharp::processing::Globals;
import csharp::processing::utils::locationIncluder;
import csharp::analyzing::dependence::collector;

public list[list[tuple[AstNode,loc]]] FindIndependentSlices(list[Statement] statements)
{
	relDeps = GetDependences();
    map[AstNode Node,list[tuple[AstNode,loc]] Nodes] mapSlices = ();
	for(ast <- [StatementLoc(s) | s<-statements])
	{
		//First get all the dependencies for this statement.
		//if the statement has any child statements, also return those dependencies
		// and also all parent-dependencies (?)
		deps = relDeps[<ast,ast@location>];
		
		if(isEmpty(deps) || isEmpty(mapSlices)) //new slice
			mapSlices += (ast:[<ast,ast@location>]);
		else //has dependencies, add to the same slice as the dependency
		{
			AstNode addedToSlice = astNodePlaceholder();
			for(d <- deps)
			{
				for(s <- mapSlices)
				{
					if(<d.DependendOn,d.DependendOn@location> in mapSlices[s])
					{
						if(addedToSlice == astNodePlaceholder())
						{
							mapSlices[s] += [<ast,ast@location>];
							addedToSlice=s;
						}
						else if(s != addedToSlice) //dont try to combine with yourself
						{
							//dependencies found in more then one slice, create a new map and combine the slices
							mapSlices = CombineSlices(mapSlices, d.DependendOn, addedToSlice);
						}
					}
				}
			}
			
			//none of the deps were found in the map, so add a new one
			if(addedToSlice == astNodePlaceholder())
				mapSlices += (ast:[<ast,ast@location>]);
		}
	}
	
	return toList(range(mapSlices));
}

map[AstNode Node,list[tuple[AstNode,loc]] Nodes] CombineSlices(map[AstNode Node,list[tuple[AstNode,loc]] Nodes] _map, AstNode dep, AstNode addTo)
{
	map[AstNode Node,list[tuple[AstNode,loc]] Nodes] _mapSlices = ();
	list[tuple[AstNode,loc]] NodesToCombine = [];
	for(slice <- _map)
	{
		if(<dep,dep@location> in _map[slice])
		{
			NodesToCombine = _map[slice];
		}
		else
			_mapSlices += (slice:_map[slice]);
	}
	_mapSlices[addTo] += NodesToCombine;
	return _mapSlices;
}
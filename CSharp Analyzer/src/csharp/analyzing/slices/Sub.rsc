 module csharp::analyzing::slices::Sub

import Map;
import Set;
import List;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::Globals;
import csharp::processing::utils::locationIncluder;
import csharp::analyzing::dependence::collector;

map[tuple[int intKey,tuple[AstNode Node,loc l] astKey] keys, list[tuple[AstNode,loc]] contents] mapSubSlices = ();
public map[tuple[int,tuple[AstNode,loc]], list[tuple[AstNode,loc]]] FindSubSlices(list[Statement] statements)
{
	mapSubSlices = ();
	astStatements = [StatementLoc(s)|s<-statements];
	
	relDeps = GetDependences();
	Read(relDeps, "relTrans");
	for(ast<-astStatements)
	{
		deps = relDeps[<ast,ast@location>];
		
		if(isEmpty(mapSubSlices) ||
		   isEmpty(deps))
		{
			AddNewSlice(ast);
			continue;
		}
		//found some dependencies and we have a slice in the map
		
		//get all the slices in which one of the deps is either the key or exists in the content
		//and return all those keys
		
		dbgdeps = relDependence[<ast,ast@location>];
		//dbg2 = relDependence[dbgdeps[0]];
		//dbg3 = relDependence[dbgdeps[1]];
		
		slices = GetSlicesByDeps(deps);
		
		
		if(size(slices) == 0)
			//the deps arent found in the slices, add a new slice
			AddNewSlice(ast);
		
		else if(size(slices) == 1)
			//the deps are found in one slice, add our statement to that slice 
			AddToSlice(top(slices), ast);
			
		else if(size(slices) > 1)
		{
			//the deps are found in more then one slice
			
			//find the last statement we are dependent on, which is not me...
			dep = GetLastDependency(ast,deps, astStatements);
			
			//add a new slice with the dep as key
			AddNewSlice(dep,ast);
		}
		
		else
			//Something is wrong..
			throw "An unexpected case occured while looking for subslices.\n
			       ast=<ast>\n
				   slices=<slices>";
	}
	
	return mapSubSlices;
}
list[tuple[int intKey,tuple[AstNode Node,loc l] astKey]] GetSlicesByDeps(rel[AstNode DependendOn,loc l] deps)
{
	list[tuple[int intKey,tuple[AstNode Node,loc l] astKey]] foundSlices = [];
	for(key		<-	mapSubSlices,		//tuple key
		d 		<-	deps,				//dep in deps
		(d in mapSubSlices[key] ||		//dep is found in the slice
		d == key.astKey) &&				//dep is the key
		!(key in foundSlices))			//count each slice ones
	{
		foundSlices += key;
	}
	
	return foundSlices;
}

AstNode GetLastDependency(AstNode ast, rel[AstNode DependendOn,loc l] deps, list[AstNode] astStatements)
{
	AstNode dep = astNodePlaceholder();
	for(s	<-	astStatements,
		d	<-	deps,
		d.DependendOn == s &&
		d.DependendOn != ast)
	{
		dep = s;
	}
	return dep;
}

void AddNewSlice(AstNode astKey) = AddNewSlice(<astKey,astKey@location>,[]);
void AddNewSlice(AstNode astKey, AstNode stat) = AddNewSlice(<astKey,astKey@location>,[<stat,stat@location>]);
void AddNewSlice(AstNode astKey, tuple[AstNode,loc] stat) = AddNewSlice(astKey,[stat]);
void AddNewSlice(tuple[AstNode,loc] astKey, list[tuple[AstNode,loc]] stats)
{
	int key = size(mapSubSlices);
		
	key += 1; //up the key to the next
	mapSubSlices += (<key,astKey>:stats); //add to the map
}

void AddToSlice(tuple[int,tuple[AstNode,loc]] key, AstNode stat) = AddToSlice(key,[<stat,stat@location>]);
void AddToSlice(tuple[int,tuple[AstNode,loc]] key, list[tuple[AstNode,loc]] stats)
{
	mapSubSlices[key] += stats;
}
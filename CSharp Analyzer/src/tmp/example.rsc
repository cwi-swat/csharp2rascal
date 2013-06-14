module example

import IO;
import Set;
import Relation;
import Node;

import csharp::processing::Globals;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::Main;
import csharp::processing::utils::utils;
import csharp::processing::utils::locationIncluder;

public void main()
{
	//build family
	//a = [<x,y> | f<- Project, \x := f, y <- getChildren(x)];

	rel[int from,int to] relDepen = {<3,1>,<5,4>,<4,2>};
	
	setAll = carrier(relDepen);
	
	//Transitive closure + self to self
	relDeps = relDepen*;
	
	
	//for(<x,y> := toList(relDeps), !(<y,x> in relDeps))

	for(d <- relDeps, !(<d.to,d.from> in relDeps))
	{
		relDeps += <d.to,d.from>;
	}
	
	relAlles = (setAll * setAll);
	
	relMogelijk = (relAlles - relDeps);
	
	analyzestats();
}




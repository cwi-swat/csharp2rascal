module csharp::analyzing::Analyze

import IO;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::analyzing::slices::Independent;
import csharp::analyzing::slices::Sub;
import csharp::analyzing::slices::Block;

public void Analyze(noAccessor()) 					{return;}
public void Analyze(emptyStatement())				{return;}
public void Analyze(accessor(_,Statement body,_,_))	{Analyze(body);}
public void Analyze(b:blockStatement(list[Statement] statements))
{
	//these slices will be the biggest and 
	list[list[tuple[AstNode,loc]]] lstSlices = [];
	lstSlices = FindIndependentSlices(statements);
	Read(lstSlices, "lstSlices");

	//Ok so we found the slices that are totally independent of eachother
	//Maybe there are slices within the slices(subslices) that are big enough to separate
	map[tuple[int,tuple[AstNode,loc]], list[tuple[AstNode,loc]]] mapSubSlices = ();
	lstSubSlices = FindSubSlices(statements);
	Read(lstSubSlices, "lstSubSlices");
	
	map[AstNode,list[list[tuple[AstNode,loc]]]] mapBlockSlices = ();
	mapBlockSlices = FindBlockSlices(statements);
	Read(mapBlockSlices, "mapBlockSlices");
}


void Read(list[list[tuple[AstNode ast,loc l]]] lst, str name)
{
	println();
	println(name);
	int i = 1;
	for(s<-lst)
	{
		println("  slice <i>");
		for(ss<-s)
		{
			println("    <ss.ast>");
		}
		i = i+1;
	}
}
void Read(map[tuple[int intkey,tuple[AstNode Node,loc l] astkey], list[tuple[AstNode Node,loc l]]] _map, str name)
{
	println();
	println(name);
	for(s<-_map)
	{
		println("  slice: \<<s.intkey> , <s.astkey.Node>\>");
		for(stat<-_map[s])
		{
			println("      <stat.Node>");
		}
	}
}

void Read(map[AstNode BlockNode,list[list[tuple[AstNode ast,loc l]]] Slices] _map, str name)
{
	println();
	println(name);
	int i = 1;
	for(b<-_map)
	{
		println("  block:<b>");
		for(slice<-_map[b])
		{
			println("    slice <i>");
			for(ss<-slice)
			{
				println("      <ss.ast>");
			}
			i = i+1;
		}
	}
}
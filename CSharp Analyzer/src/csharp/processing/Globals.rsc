module csharp::processing::Globals

import csharp::CSharpSyntax::CSharpSyntax;
import IO;

public map[tuple[AstNode Node,loc l] key, list[tuple[AstNode Node,loc l]] children] mapFamily = ();
public map[tuple[AstNode Node,loc l] key, list[tuple[AstNode Node,loc l]] decls] mapAttributedNodeDeclarations = ();

public rel[tuple[CSharpFile file,loc l] from, tuple[AstNode using,loc l] to] relFileUsing = {};
public rel[tuple[CSharpFile file,loc l] from, tuple[AstNode namespace,loc l] to] relFileNamespace = {};
public rel[tuple[AstNode namespace,loc l] from, tuple[AstNode member,loc l] to] relNamespaceAttributedNode = {};
public rel[tuple[AttributedNode Node,loc l] from, tuple[AttributedNode member,loc l] to] relAttributedNodeMember = {};
public rel[tuple[AstNode Node,loc l] from, tuple[AstNode DependendOn,loc l] to] relDependence = {};

//contains function to function and class to class
public rel[tuple[AstNode Caller,loc l], tuple[AstNode Called,loc l]] relCalls = {};

public void InitGlobals()
{
	mapFamily = ();
	mapAttributedNodeDeclarations = ();
	relFileUsing = {};
	relFileNamespace = {};
	relNamespaceAttributedNode = {};
	relAttributedNodeMember = {};
	relDependence = {};
	relCalls = {};
}


public void ReadRelations()
{
	Read(relFileUsing, "relFileUsing: ");
	Read(relFileNamespace, "relFileNamespace: ");
	Read(relNamespaceAttributedNode, "relNamespaceAttributedNode: ");
	Read(relAttributedNodeMember, "relAttributedNodeMember: ");
	Read(relDependence, "relDependence: ");
	println();
}

public void Read(list[tuple[Statement block,str uniqueName,Statement assignment]] _list, str name)
{
	println();
	println(name);
	
	for(tup <- _list)
	{
		Println("\< <tup.block>", 1);
		Println(", <tup.uniqueName>", 1);
		Println(", <tup.assignment>", 1);
		Println("\>", 1);
	}
}
public void Read(map[tuple[AstNode Node,loc l] keys, list[tuple[AstNode Node,loc l]] children] _map, str name)
{
	println();
	println(name);
	
	for(key <- _map.keys)
	{
		Println(key, 1);
		for(m <- _map[key]) Println(m,2);
	}
}
public void Read(map[value keys,list[value] members] _map, str name)
{
	println();
	println(name);
	
	for(key <- _map.keys)
	{
		Println(key, 1);
		for(m <- _map[key]) Println(m,2);
	}
}
public void Read(map[value keys, value members] _map, str name)
{
	println();
	println(name);
	
	for(key <- _map.keys)
	{
		Println(key, 1);
		Println(_map[key],2);
	}
}
public void Read(rel[value keys,value members] _rel, str name)
{
	println();
	println(name);
	
	for(key <- _rel.keys)
	{
		Println(key, 1);
		for(m <- _rel[key]) Println(m,2);
		println();
	}
}

public void Read(rel[tuple[AstNode Node,loc l] keys, tuple[AstNode Node,loc l] children] _rel, str name)
{
	println();
	println(name);
	
	for(key <- _rel.keys)
	{
		Println(key, 1);
		for(r <- _rel[key]) Println(r,2);
	}
}


void Println(value msg, int level)
{
	println("<GetSpacing(level)><msg>");
}

str GetSpacing(int level)
{
	str spacing ="";
	for(int n <- [1..level]) spacing += "  ";
	return spacing;
}
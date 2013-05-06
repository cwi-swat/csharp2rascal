module csharp::processing::Globals

import csharp::syntax::CSharpSyntax;
import IO;

public map[AstNode parent, list[AstNode] children] mapFamily = ();
public rel[CSharpFile file, AstNode using] relFileUsing = {};
public rel[CSharpFile file, AstNode namespace] relFileNamespace = {};
public rel[AstNode namespace, AstNode member] relNamespaceAttributedNode = {};
public rel[AttributedNode Node, AttributedNode members] relAttributedNodeMember = {};
public rel[AstNode Node, AstNode DependendOn] relDependence = {};

public void InitGlobals()
{
	mapFamily = ();
	relFileUsing = {};
	relFileNamespace = {};
	relNamespaceAttributedNode = {};
	relAttributedNodeMember = {};
	relDependence = {};
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
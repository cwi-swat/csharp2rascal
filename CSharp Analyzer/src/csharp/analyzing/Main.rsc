module csharp::analyzing::Main

import csharp::processing::Main;
import csharp::processing::Globals;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::analyzing::Analyze;
import csharp::analyzing::try2::IndependentStats;

import Set;
import IO;
import String;

public void main() = main(false);
public void main(bool forceCalc)
{
	if(isEmpty(relDependence) || forceCalc)
		StartProcessing();
	
	Read(relDependence, "relDeps");
	
	mainTwo();
}
	
void mainOne()
{	
	str TestFile = "Case2.cs";	
	for(file <- Project,
	   endsWith(file.filename,TestFile),
	   astnode <- file.contents,
	   astnode is namespaceDeclaration,
	   member <- astnode.members,
	   member is attributedNode,
	   member.nodeAttributedNode is typeDeclaration,
	   member.nodeAttributedNode.classType is \class)
	{
		println();
		println("class = <member.nodeAttributedNode.name>");
		for(m <- member.nodeAttributedNode.members)
		{
			visit(m)
			{
				case a:constructorDeclaration(_,_,body,_,_,_,_):	{separator(m);Analyze(body);}
				case a:methodDeclaration(_,_,body,_,_,_,_,_,_,_):	{separator(m);Analyze(body);}
				case a:propertyDeclaration(_,_,g,_,_,s,_):		   	{separator(m);Analyze(g);
																	 Analyze(s);}
			}
		}
		println();
	}
}
public void separator(m)
{
	println();
	println("---------------------------------------------");
	println(" block = <m>");
}

public void mainTwo()
{
	relIndepStats = GetIndependentStats();
}
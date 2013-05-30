module csharp::analyzing::Main

import csharp::processing::Main;
import csharp::processing::Globals;
import csharp::syntax::CSharpSyntax;
import csharp::analyzing::Analyze;
import Set;
import IO;
import String;
 
str TestFile = "Case2.cs";

public void main() {main(false);}
public void main(bool calcDeps)
{
	if(isEmpty(relDependence) || calcDeps)
		StartAnalyzing();
	
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
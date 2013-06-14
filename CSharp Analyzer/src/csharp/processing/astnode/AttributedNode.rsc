module csharp::processing::astnode::AttributedNode

import IO;

import csharp::processing::typeDeclaration::Main;
import csharp::processing::Globals;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::utils::locationIncluder;

public void HandleAttributedNode(AstNode astnode)
{
	//todo: enum, delegate
		
	aNode = astnode.nodeAttributedNode;
	if(aNode is typeDeclaration &&
	   aNode.classType is \class)
		HandleTypeDeclaration(aNode);
}
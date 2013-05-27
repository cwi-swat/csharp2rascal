module csharp::processing::astnode::AttributedNode

import IO;

import csharp::processing::typeDeclaration::Main;
import csharp::processing::Globals;
import csharp::syntax::CSharpSyntax;
import utils::locationIncluder;

public void HandleAttributedNode(AttributedNode aNode, AttributedNode bNode) {
	HandleAttributedNode(AttributedNodeLoc(aNode), AttributedNodeLoc(bNode));	
}
public void HandleAttributedNode(AttributedNode aNode, AstNode astnode){
	HandleAttributedNode(AttributedNodeLoc(aNode), astnode);	
}
public void HandleAttributedNode(AstNode astnode, AttributedNode aNode){
	HandleAttributedNode(astnode, AttributedNodeLoc(aNode));	
}

public void HandleAttributedNode(AstNode parent, AstNode astnode)
{
	//enum, accessor, delegate, destructor, typedeclaration, constructor or memberDeclaration
		
	aNode = astnode.nodeAttributedNode;
	if(aNode is typeDeclaration &&
	   aNode.classType is \class)
		HandleTypeDeclaration(aNode);
}
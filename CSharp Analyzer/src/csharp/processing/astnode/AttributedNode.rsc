module csharp::processing::astnode::AttributedNode

import IO;

import csharp::processing::typeDeclaration::Main;
import csharp::processing::Globals;
import csharp::syntax::CSharpSyntax;
//import csharp::processing::astnode::MemberDeclaration;
//import csharp::processing::astnode::NodeWithBody;

public void HandleAttributedNode(AttributedNode aNode, AttributedNode bNode) {
	HandleAttributedNode(attributedNode(aNode), attributedNode(bNode));	
}
public void HandleAttributedNode(AttributedNode aNode, AstNode astnode){
	HandleAttributedNode(attributedNode(aNode), astnode);	
}
public void HandleAttributedNode(AstNode astnode, AttributedNode aNode){
	HandleAttributedNode(astnode, attributedNode(aNode));	
}

public void HandleAttributedNode(AstNode parent, AstNode astnode)
{
	//enum, accessor, delegate, destructor, typedeclaration, constructor or memberDeclaration
		
	aNode = astnode.nodeAttributedNode;
	if(aNode is typeDeclaration &&
	   aNode.classType is \class)
		HandleTypeDeclaration(aNode);
}
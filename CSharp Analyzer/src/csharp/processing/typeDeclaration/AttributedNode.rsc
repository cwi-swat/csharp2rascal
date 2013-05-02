module csharp::processing::typeDeclaration::AttributedNode

import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::NodeWithBody;

public void HandleAttributedNode(map[str name, list[AstNode] a] mapTypeMemberAssignments, AttributedNode aNode)
{
	
	if(aNode is enumMemberDeclaration)
		;
	
	else if(aNode is accessor)
		HandleNodeWithBody(mapTypeMemberAssignments, aNode.body);

	else if(aNode is destructorDeclaration)
		HandleNodeWithBody(mapTypeMemberAssignments, aNode.body);

	else if(aNode is constructorDeclaration)
		HandleNodeWithBody(mapTypeMemberAssignments, aNode.body);

	else if(aNode is delegateDeclaration)
		;
}
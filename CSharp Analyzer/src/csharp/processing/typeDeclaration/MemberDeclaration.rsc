module csharp::processing::typeDeclaration::MemberDeclaration

import csharp::processing::Globals;
import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::AttributedNode;
import csharp::processing::typeDeclaration::NodeWithBody;

public void HandleMemberDeclaration(AstNode parent, MemberDeclaration md)
{
	if(md is indexerDeclaration);
	else if(md is methodDeclaration)
		HandleNodeWithBody(md.body);
	else if(md is propertyDeclaration)
	{
		HandleAttributedNode(parent, md.getter);
		HandleAttributedNode(parent, md.setter);
	}
	else if(md is fieldDeclaration);		
	else if(md is eventDeclaration);
	else if(md is customEventDeclaration);
}
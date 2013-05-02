module csharp::processing::typeDeclaration::Main

import IO;
import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::MemberDeclaration;
import csharp::processing::typeDeclaration::NodeWithBody;
import csharp::processing::typeDeclaration::AttributedNode;
import csharp::processing::Globals;
import utils::utils;

map[str name, list[AstNode] a] mapTypeMemberAssignments = ();

public void HandleTypeDeclaration(AttributedNode typeDeclaration)
{
	mapTypeMemberAssignments = ();
	
	//eerst de fields doorlopen, en bekijken of deze geinitializeerd worden
	for(member <- typeDeclaration.members)
	{
		if(member is memberDeclaration &&
		   member.nodeMemberDeclaration is fieldDeclaration)
		{
			field = member.nodeMemberDeclaration;
			for(variable <- field.variables) //variableInitializer
			{
				if(!(variable.initializer is emptyExpression))
				{
					mapTypeMemberAssignments = AddToMap(mapTypeMemberAssignments, variable.name, attributedNode(member));
				}
			}
		}
	}
	
	for(member <- typeDeclaration.members)
	{
		if(member is accessor ||
		   member is destructorDeclaration ||
		   member is constructorDeclaration)
		{
			HandleAttributedNode(mapTypeMemberAssignments, member);
		}
		else if(member is memberDeclaration &&
		   member.nodeMemberDeclaration is methodDeclaration)
		   HandleNodeWithBody(mapTypeMemberAssignments, member.nodeMemberDeclaration.body);
	}
}

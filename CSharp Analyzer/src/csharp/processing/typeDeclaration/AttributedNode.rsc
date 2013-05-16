module csharp::processing::typeDeclaration::AttributedNode

import csharp::syntax::CSharpSyntax;
import csharp::processing::statement::Block;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::statement::Handler;

import IO;

public void Handle(noAccessor())
{
	return;
}

public void Handle(accessor(list[AstNode] attributes, Statement body, list[AstNode] modifierTokens, list[Modifiers] modifiers))
{
	Handle(body, body);
}

public void Handle(constructorDeclaration(str name, list[AstNode] attributes, Statement body, AstNode initializer, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters))
{
	for(p <- parameters)
		mapParameters += (p.name:p);

	Handle(body, body);
}

public void Handle(destructorDeclaration(str name, list[AstNode] attributes, Statement body, list[AstNode] modifierTokens, list[Modifiers] modifiers))
{
	Handle(body, body);
}
module csharp::processing::typeDeclaration::MemberDeclaration

import csharp::processing::Globals;
import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::AttributedNode;
import csharp::processing::statement::Block;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::statement::Handler;
import utils::locationIncluder;
import utils::utils;

import IO;

public void Handle(MemberDeclaration md, AttributedNode typeDeclaration)
{
	visit(md)
	{
		case m:indexerDeclaration(_,_,_,_,_,_,_,_):		;
		case m:methodDeclaration(_,_,_,_,_,_,_,_,_,_):	{ResetMaps(); Handle(m);}
		case m:propertyDeclaration(_,_,_,_,_,_,_):	    
		{
			mapTypeDeclarations = AddToMap(mapTypeDeclarations, AttributedNodeLoc(typeDeclaration), AttributedNodeLoc(MemberDeclarationLoc(m)));
			ResetMaps();
			Handle(m);
		}
		case m:fieldDeclaration(_,_,_,_,_,_):			mapTypeDeclarations = AddToMap(mapTypeDeclarations, AttributedNodeLoc(typeDeclaration), AttributedNodeLoc(MemberDeclarationLoc(m)));
  		case m:eventDeclaration(_,_,_,_,_,_):			;
  		case m:customEventDeclaration(_,_,_,_,_,_):		;
	}
}

private void Handle(methodDeclaration(str name, list[AstNode] attributes, Statement body, list[AstNode] constraints, bool isExtensionMethod, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters, list[AstNode] typeParameters, AstType \type))
{
	for(p <- parameters)
		mapParameters += (p.name:p);
		
	Handle(body);
}

private void Handle(propertyDeclaration(str name, list[AstNode] attributes, AttributedNode getter, list[AstNode] modifierTokens, list[Modifiers] modifiers, AttributedNode setter, AstType \type))
{
	mapAssignments = ();
	Handle(getter);
	
	mapAssignments = ();
	Handle(setter);
}
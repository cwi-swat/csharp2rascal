module csharp::processing::typeDeclaration::Main
 
import IO;
import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::MemberDeclaration;
import csharp::processing::typeDeclaration::AttributedNode;
import csharp::processing::Globals;
import utils::utils;

public map[str name, list[AstNode] a] mapTypeMemberAssignments = ();

//this map keeps track of all the assignments within a block of code
//and gets reset on a new block
public map[Expression name, list[Statement] s] mapAssignments = ();

public map[str name, AstNode a] mapParameters = ();

public map[AstNode Node, list[AstNode] decls] mapTypeDeclarations = ();
public map[AstNode Node, list[AstNode] decls] mapAttributedNodeDeclarations = ();

public void HandleTypeDeclaration(AttributedNode typeDeclaration)
{
	mapTypeDeclarations = ();
	mapTypeMemberAssignments = ();
	

	//Fill the mapTypeDeclarations	
	visit(typeDeclaration.members)
	{
		case m:memberDeclaration(_):
		{
			visit(m)
			{
				case pd:propertyDeclaration(_,_,_,_,_,_,_):
				{
					mapTypeDeclarations = AddToMap(mapTypeDeclarations, attributedNode(typeDeclaration), m);
				}
				case fd:fieldDeclaration(_,_,_,_,vars,_):
				{
					mapTypeDeclarations = AddToMap(mapTypeDeclarations, attributedNode(typeDeclaration), m);
					for(v <- vars)
					{
						if(!(v.initializer is emptyExpression))
						{
							mapTypeMemberAssignments = AddToMap(mapTypeMemberAssignments, v.name, attributedNode(m));
						}	
					}
				}
			}
		}
	}

	visit(typeDeclaration.members)
	{	
		case m:memberDeclaration(md):
		{
			relAttributedNodeMember[typeDeclaration] = m; 
			Handle(md, typeDeclaration);
	  	}
		case m:destructorDeclaration(_,_,_,_,_):
		{
			mapAssignments = ();
			mapAttributedNodeDeclarations = ();
			relAttributedNodeMember[typeDeclaration] = m;
			Handle(m);
	  	}
		case m:constructorDeclaration(_,_,_,_,_,_,_):
		{
		   	mapAssignments = ();
		   	mapAttributedNodeDeclarations = ();
		   	relAttributedNodeMember[typeDeclaration] = m; 
			Handle(m);
		}
	}
}

public void ResetMaps()
{
	mapAssignments = ();
	mapParameters = ();
}
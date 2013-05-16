module csharp::processing::typeDeclaration::Main
 
import IO;
import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::MemberDeclaration;
import csharp::processing::typeDeclaration::AttributedNode;
import csharp::processing::Globals;
import utils::utils;

public map[AstNode Node, list[AstNode] decls] mapTypeDeclarations = ();

//this map keeps track of all the assignments/parameters within a block of code
//and gets reset on a new block
public map[str uniqueName, list[Statement] s] mapAssignments = ();

//this list is for statements like for/foreach/using/etc
//these statements declare variables which are only usable inside the block
//however, the same name can be reused in another statement block(if its not inside the same block)
public list[tuple[Statement block,str varname, Statement assignment]] listLocalAssignments = [];

public map[str name, AstNode a] mapParameters = ();

public void HandleTypeDeclaration(AttributedNode typeDeclaration)
{
	mapTypeDeclarations = ();
	

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
			ResetMaps();
			relAttributedNodeMember[typeDeclaration] = m;
			Handle(m);
	  	}
		case m:constructorDeclaration(_,_,_,_,_,_,_):
		{
			ResetMaps();
		   	relAttributedNodeMember[typeDeclaration] = m; 
			Handle(m);
		}
	}
}

public void ResetMaps()
{
	mapAssignments = ();
	mapParameters = ();
	mapAssignments = ();
   	mapAttributedNodeDeclarations = ();
}
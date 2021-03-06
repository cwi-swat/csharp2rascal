module csharp::processing::typeDeclaration::Main
 
import IO;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::typeDeclaration::MemberDeclaration;
import csharp::processing::typeDeclaration::AttributedNode;
import csharp::processing::Globals;
import csharp::processing::utils::utils;
import csharp::processing::utils::locationIncluder;

public map[AstNode Node, list[AstNode] decls] mapTypeDeclarations = ();

//this map keeps track of all the assignments/parameters within a block of code
//and gets reset on a new block
public map[str uniqueName, list[Statement] s] mapAssignments = ();

//this list is for statements like for/foreach/using/etc
//these statements declare variables which are only usable inside the block
//however, the same name can be reused in another statement block(if its not inside the same block)
public list[tuple[AstNode block, str uniqueName, AstNode assignment]] listLocalAssignments = [];

//this list will be pre-defined to identify the linq identifiers when they are used
//for example in an assignment on the right-hand-side
//TODO Linq is not yet handled.
public list[tuple[Statement s, str uniqueName, Statement assignment]] listLinqIdentifiers = [];

//Keep track of the current parameters.
public map[str name, AstNode a] mapParameters = ();

//Keep track of all read operations on all variables.
//when we assign a variable, it depends on the last read on that variable so we wont make these parallel later on.
public map[str uniquename, list[tuple[AstNode ast, loc l]] s] mapReads = ();

public void HandleTypeDeclaration(AttributedNode typeDeclaration)
{
	mapTypeDeclarations = ();
	
	println("beginning with typedecl: <typeDeclaration.name>");

	//Fill the mapTypeDeclarations / relAttributedNodeMember
	visit(typeDeclaration.members)
	{
		case m:memberDeclaration(_):
		{
			relAttributedNodeMember[<typeDeclaration,typeDeclaration@location>] = <m,m@location>;
			mapTypeDeclarations = AddToMap(mapTypeDeclarations, AttributedNodeLoc(typeDeclaration), m);
		}
		case m:destructorDeclaration(_,_,_,_,_):		relAttributedNodeMember[<typeDeclaration,typeDeclaration@location>] = <m,m@location>;
		case m:constructorDeclaration(_,_,_,_,_,_,_):	relAttributedNodeMember[<typeDeclaration,typeDeclaration@location>] = <m,m@location>;
	}

	visit(typeDeclaration.members)
	{	
		case m:memberDeclaration(md):					 Handle(md, typeDeclaration);
		case m:destructorDeclaration(_,_,_,_,_):		{ResetMaps();
														 Handle(m);}
		case m:constructorDeclaration(_,_,_,_,_,_,_):	{ResetMaps();
														 Handle(m);}
	}
}

public void ResetMaps()
{
	listLinqIdentifiers = [];
	mapAssignments = ();
	mapParameters = ();
	mapReads = ();
   	mapAttributedNodeDeclarations = ();
}

public void FilterLocalAssignments(AstNode ast)
{
	list[tuple[AstNode block, str uniqueName, AstNode assignment]] filteredList = [];
	for(as <- listLocalAssignments)
	{
		bool isAlive = false;
		parent = GetParent(ast);
		while(!(parent is attributedNode))
		{
			if(parent == as.block)
			{
				isAlive = true;
				break;
			}
			parent = GetParent(parent);
		}
		if(isAlive)
			filteredList += as;
	}
	listLocalAssignments = filteredList;	
}
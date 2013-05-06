module csharp::processing::Main

import Type;
import IO;

import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import lang::java::jdt::Java;

import csharp::processing::Globals;
import csharp::processing::astnode::AttributedNode;
import csharp::syntax::CSharpSyntax;
import csharp::reader::FileInput;

public void Start()
{
	InitGlobals();
	
	CSharpProject project = readCSharpProject();
	BuildFamily(project);
	
	for(file <- project)
	{
		for(astnode <- file.contents)
		{
			if(astnode is usingDeclaration)
			{
				relFileUsing += <file,astnode>;
			}
			else if(astnode is namespaceDeclaration)
			{
				namespace = astnode;
				relFileNamespace += <file,namespace>;
								
				for(member <- namespace.members)
				{
					relNamespaceAttributedNode += <namespace,member>;
					if(member is attributedNode)
					{
						HandleAttributedNode(astNodePlaceholder(), member);
					}
				}
				
			}
		}
	}
	Read(relDependence, "relDependence");
}

 

void BuildFamily(CSharpProject project)
{
	mapFamily = ();
	
	visit(project)
	{
		case p:namespaceDeclaration(_,_,_,Ms)			: AddToFamily(p, Ms);
		case p:switchSection(_,Ss)						: AddToFamily(p, Ss);
		case p:catchClause(s,_) 						: AddToFamily(p, s);
		case p:anonymousMethodExpression(s, _,_)		: AddToFamily(p, s);
		case p:whileStatement(_, s)						: AddToFamily(p, s);
		case p:usingStatement(s, _)						: AddToFamily(p, s);
		case p:doWhileStatement(_, s)					: AddToFamily(p, s);
		case p:forStatement(_, s, _, _)					: AddToFamily(p, s);
		case p:lockStatement(s, _) 						: AddToFamily(p, s);
		case p:unsafeStatement(s)						: AddToFamily(p, s);
		case p:fixedStatement(s,_)						: AddToFamily(p, s);
		case p:uncheckedStatement(s)					: AddToFamily(p, s);
		case p:checkedStatement(s)						: AddToFamily(p, s);
		case p:typeDeclaration(_,_, _,_,_,Ms,_, _,_)	: AddToFamily(p, Ms);
		case p:accessor(_,s,_,_)						: AddToFamily(p, s);
		case p:constructorDeclaration(_,_,s,_,_,_,_)	: AddToFamily(p, s);
		case p:destructorDeclaration(_,_,s,_,_,_,_) 	: AddToFamily(p, s);
		case p:methodDeclaration(_,_,s,_,_,_,_,_,_,_)	: AddToFamily(p, s);
		case p:blockStatement(s)						: AddToFamily(p, s);
		case p:ifElseStatement(_, f, t) 				:{AddToFamily(p, t);
			 											  AddToFamily(p, f);}
		case p:tryCatchStatement(_,fin,\try)			:{AddToFamily(p, fin);
		 											      AddToFamily(p, \try);}
	}

	//Read(mapFamily, "mapfamily");
}

//this main function has to stay on top
// stackoverflow exception can occur if not.
// --> empty list has to resolve to this function, not an overload.
public void AddToFamily(AstNode p, list[AstNode] Cs) {
	if(p in mapFamily)
		mapFamily[p] += Cs;
	else
	    mapFamily += (p:Cs);
}


//overloads to make more types compatible
public void AddToFamily(MemberDeclaration p, Statement c) 			= AddToFamily(attributedNode(memberDeclaration(p)), statement(c));
public void AddToFamily(AttributedNode p, AttributedNode c)			= AddToFamily(attributedNode(p), attributedNode(c));
public void AddToFamily(AttributedNode p, Statement c)				= AddToFamily(attributedNode(p), statement(c));
public void AddToFamily(Expression p, Statement c)					= AddToFamily(expression(p), statement(c));
public void AddToFamily(Statement p, Statement c)					= AddToFamily(statement(p), statement(c));
public void AddToFamily(AstNode p, Statement c)						= AddToFamily(p, statement(c));
public void AddToFamily(AstNode p, list[Statement] Cs)				= AddToFamily(p, [statement(c) | c <- Cs]);
public void AddToFamily(Statement p, list[Statement] Cs)			= AddToFamily(statement(p), [statement(c) | c <- Cs]);
public void AddToFamily(Statement p, list[AttributedNode] Cs)		= AddToFamily(statement(p), [attributedNode(c) | c <- Cs]);
public void AddToFamily(AttributedNode p, list[AttributedNode] Cs)	= AddToFamily(attributedNode(p), [attributedNode(c) | c <- Cs]);
public void AddToFamily(AstNode p, AstNode c)						= AddToFamily(p, [c]);


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

public void main()
{
	InitGlobals();
	
	CSharpProject project = readCSharpProject();
	BuildFamily(project);
	
	for(file <- project)
	{
		visit(file)
		{
			case c:usingDeclaration(_): 					relFileUsing += <file,c>;
			case c:namespaceDeclaration(_,_,_,members):
			{
				relFileNamespace[file] = c;
				for(m<-members) relNamespaceAttributedNode[c] = m;
			}
		}
	}
	for(file <- project)
	{
		for(astnode <- file.contents)
		{
			if(astnode is namespaceDeclaration)
			{
				for(member <- astnode.members)
				{
					if(member is attributedNode)
					{
						HandleAttributedNode(astNodePlaceholder(), member);
					}
				}
				
			}
		}
	}
	Read(relDependence, "relDependence");
	Read(relCalls, "relCalls");
}

 

void BuildFamily(CSharpProject project)
{
	mapFamily = ();
	
	visit(project)
	{
		case p:namespaceDeclaration(_,_,_,Ms)			: AddToFamily(p, Ms);
		case p:switchStatement(c,Ss)					:{AddToFamily(p, Ss);
														  AddToFamily(p, c);}
		case p:switchSection(_,Ss)						: AddToFamily(p, Ss);
		case p:catchClause(s,_) 						: AddToFamily(p, s);
		case p:anonymousMethodExpression(s, _,Ps)		:{AddToFamily(p, s);
														  AddToFamily(p, Ps);}
		case p:whileStatement(c, s)						:{AddToFamily(p, s);
														  AddToFamily(p, c);}
		case p:usingStatement(s,r)						:{AddToFamily(p, s);
														  AddToFamily(p, r);}
		case p:doWhileStatement(c, s)					:{AddToFamily(p, s);
														  AddToFamily(p, c);}
		case p:forStatement(c, s,init,iter)				:{AddToFamily(p, s);
														  AddToFamily(p, init);
														  AddToFamily(p, iter);
														  AddToFamily(p, c);}
		case p:foreachStatement(s,i,_)					:{AddToFamily(p, s);
														  AddToFamily(p, i);}
		case p:lockStatement(s,e) 						:{AddToFamily(p, s);
														  AddToFamily(p, e);}
		case p:unsafeStatement(s)						: AddToFamily(p, s);
		case p:fixedStatement(s,_)						: AddToFamily(p, s);
		case p:uncheckedStatement(s)					: AddToFamily(p, s);
		case p:checkedStatement(s)						: AddToFamily(p, s);
		case p:typeDeclaration(_,As, _,_,_,Ms,_, _,_)	:{AddToFamily(p, Ms);
														  AddToFamily(p, As);}
		case p:accessor(As,s,_,_)						:{AddToFamily(p, s);
														  AddToFamily(p, As);}
		case p:constructorDeclaration(_,As,s,_,_,_,Ps)	:{AddToFamily(p, s);
														  AddToFamily(p, Ps);
														  AddToFamily(p, As);}
		case p:destructorDeclaration(_,As,s,_,_,_,_) 	:{AddToFamily(p, s);
														  AddToFamily(p, As);}
		case p:methodDeclaration(_,As,s,_,_,_,_,Ps,_,_)	:{AddToFamily(p, s);
														  AddToFamily(p, As);
														  AddToFamily(p, Ps);}
		case p:blockStatement(s)						: AddToFamily(p, s);
		case p:ifElseStatement(c, f, t) 				:{AddToFamily(p, c);
														  AddToFamily(p, t);
			 											  AddToFamily(p, f);}
		case p:tryCatchStatement(\try,Cs,fin)			:{AddToFamily(p, Cs);
														  AddToFamily(p, fin);
		 											      AddToFamily(p, \try);}
		case p:propertyDeclaration(_,As,g,_,_,s,_)		:{AddToFamily(p, As);
														  AddToFamily(p, g);
		 											      AddToFamily(p, s);}
		case p:fieldDeclaration(_,As,_,_, Vs,_)			:{AddToFamily(p, As);
														  AddToFamily(p, Vs);}
		case p:eventDeclaration(_,As,_,_, Vs,_)			:{AddToFamily(p, As);
														  AddToFamily(p, Vs);}
		case p:customEventDeclaration(_,aa,As,_,_,ra)	:{AddToFamily(p, aa);
														  AddToFamily(p, ra);
														  AddToFamily(p, As);}
		case p:catchClause(s,_,_)						: AddToFamily(p, s);
		case p:variableDeclarationStatement(_,Vs,_)		: AddToFamily(p, Vs);
		case p:variableInitializer(_,i)					: AddToFamily(p, i);
		case p:throwStatement(e)						: AddToFamily(p, e);
		case p:returnStatement(e)						: AddToFamily(p, e);
		case p:expression(e)							: AddToFamily(p, e);
		case p:statement(s)								: AddToFamily(p, s);

		//expressions
		case p:directionExpression(e,_)					: AddToFamily(p, e);
		case p:castExpression(e,_)						: AddToFamily(p, e);
		case p:parenthesizedExpression(e)				: AddToFamily(p, e);
		case p:unaryOperatorExpression(e,_)				: AddToFamily(p, e);
		case p:namedArgumentExpression(e,_)				: AddToFamily(p, e);
		case p:namedExpression(e,_)						: AddToFamily(p, e);
		case p:asExpression(e,_)						: AddToFamily(p, e);
		case p:isExpression(e,_)						: AddToFamily(p, e);
		case p:uncheckedExpression(e)					: AddToFamily(p, e);
		case p:checkedExpression(e)						: AddToFamily(p, e);
		case p:memberReferenceExpression(_,t,_)			: AddToFamily(p, t);
		
		case p:anonymousTypeCreateExpression(Is)		: AddToFamily(p, Is);
		case p:arrayInitializerExpression(Es)			: AddToFamily(p, Es);
		case p:queryExpression(Cs)						: AddToFamily(p, Cs);
		
		case p:invocationExpression(As,t)				:{AddToFamily(p, t);
														  AddToFamily(p, As);}
		case p:indexerExpression(As,t)					:{AddToFamily(p, t);
														  AddToFamily(p, As);}
		case p:objectCreateExpression(As,i,_)			:{AddToFamily(p, i);
														  AddToFamily(p, As);}
		case p:conditionalExpression(c,f,t)				:{AddToFamily(p, c);
														  AddToFamily(p, f);
														  AddToFamily(p, t);}
		case p:assignmentExpression(l,_,r)				:{AddToFamily(p, l);
														  AddToFamily(p, r);}
		case p:binaryOperatorExpression(l,_,r)			:{AddToFamily(p, l);
														  AddToFamily(p, r);}
		case p:arrayCreateExpression(_, As,i)			:{AddToFamily(p, As); 
														  AddToFamily(p, i);}
		case p:anonymousMethodExpression(Ss,_,Ps)		:{AddToFamily(p, Ss);
														  AddToFamily(p, Ps);}
														  
		//QueryClauses
		case p:queryContinuationClause(_,p)				: AddToFamily(p, p);
		case p:queryWhereClause(c)						: AddToFamily(p, c);
		case p:queryGroupClause(k,p)					:{AddToFamily(p, k);
														  AddToFamily(p, p);}
		case p:queryOrderClause(Os)						: AddToFamily(p, Os);
		case p:querySelectClause(e)						: AddToFamily(p, e);
		case p:queryLetClause(e,_)						: AddToFamily(p, e);
		case p:queryFromClause(e,_)						: AddToFamily(p, e);
		case p:queryJoinClause(eqE,inE,_,_,_,onE)		:{AddToFamily(p, eqE);
														  AddToFamily(p, inE);
														  AddToFamily(p, onE);}
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

public void AddToFamily(Expression p, Expression c)					= AddToFamily(expression(p), expression(c));
public void AddToFamily(Expression p, Statement c)					= AddToFamily(expression(p), statement(c));
public void AddToFamily(Expression p, list[QueryClause] Cs)			= AddToFamily(expression(p), [queryClause(c) | c <- Cs]);
public void AddToFamily(Expression p, list[Expression] Cs)			= AddToFamily(expression(p), [expression(c) | c <- Cs]);
public void AddToFamily(Expression p, list[Statement] Cs)			= AddToFamily(expression(p), [statement(c) | c <- Cs]);

public void AddToFamily(Statement p, Expression c)					= AddToFamily(statement(p), expression(c));
public void AddToFamily(Statement p, Statement c)					= AddToFamily(statement(p), statement(c));
public void AddToFamily(Statement p, AstNode c)						= AddToFamily(statement(p), c);
public void AddToFamily(Statement p, list[AstNode] Cs)				= AddToFamily(statement(p), Cs);
public void AddToFamily(Statement p, list[Statement] Cs)			= AddToFamily(statement(p), [statement(c) | c <- Cs]);
public void AddToFamily(Statement p, list[AttributedNode] Cs)		= AddToFamily(statement(p), [attributedNode(c) | c <- Cs]);

public void AddToFamily(MemberDeclaration p, AttributedNode c)		= AddToFamily(attributedNode(memberDeclaration(p)), attributedNode(c));
public void AddToFamily(MemberDeclaration p, Statement c) 			= AddToFamily(attributedNode(memberDeclaration(p)), statement(c));
public void AddToFamily(MemberDeclaration p, list[AstNode] c)		= AddToFamily(attributedNode(memberDeclaration(p)), c);

public void AddToFamily(AttributedNode p, list[AstNode] c)			= AddToFamily(attributedNode(p), c);
public void AddToFamily(AttributedNode p, AttributedNode c)			= AddToFamily(attributedNode(p), attributedNode(c));
public void AddToFamily(AttributedNode p, Statement c)				= AddToFamily(attributedNode(p), statement(c));
public void AddToFamily(AttributedNode p, list[AttributedNode] Cs)	= AddToFamily(attributedNode(p), [attributedNode(c) | c <- Cs]);

public void AddToFamily(QueryClause p, Expression c)				= AddToFamily(queryClause(p), expression(c));
public void AddToFamily(QueryClause p, list[AstNode] Cs)			= AddToFamily(queryClause(p), Cs);

public void AddToFamily(AstNode p, list[Statement] Cs)				= AddToFamily(p, [statement(c) | c <- Cs]);
public void AddToFamily(AstNode p, Expression c)					= AddToFamily(p, expression(c));
public void AddToFamily(AstNode p, Statement c)						= AddToFamily(p, statement(c));
public void AddToFamily(AstNode parent, AstNode child)				= AddToFamily(parent, [child]);


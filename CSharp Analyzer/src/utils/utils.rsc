module utils::utils

import csharp::syntax::CSharpSyntax;
import csharp::processing::Globals;
import csharp::processing::typeDeclaration::Main;
import List;
import IO;

public Statement GetLastListElement(list[Statement] _list)
{
	if(isEmpty(_list))
		return emptyStatement();

	return head(reverse(_list));
}

public AstNode GetLastListElement(list[AstNode] _list)
{
	AstNode lastAstNode;
	
	if(isEmpty(_set))
		return astNodePlaceholder();

	return head(reverse(_list));
}

public map[str name, list[AstNode] a] AddToMap(map[str name, list[AstNode] a] m, str key, AstNode val)
{
	if(key in m)
		m[key] += [val];
	else
		m += (key:[val]);
		
	return m;
}
public map[Expression name, list[Statement] s] AddToMap(map[Expression name, list[Statement] s] m, Expression key, Statement val)
{
	if(key in m)
		m[key] += [val];
	else
		m += (key:[val]);

	return m;
}
public map[AstNode, list[AstNode]] AddToMap(map[AstNode, list[AstNode]] m, AstNode key, AttributedNode val)
{
	return AddToMap(m, key, attributedNode(val));
}

public map[AstNode, list[AstNode]] AddToMap(map[AstNode, list[AstNode]] m, AstNode key, AstNode val)
{
	if(key in m)
		m[key] += [val];
	else
		m += (key:[val]);
		
	return m;
}


//where has id been declared?
//from viewpoint of statement s
public AstNode ResolveIdentifier(identifierExpression(str identifier, list[AstType] typeArguments), Statement s)
{
	//first get the node in which the statement is located
	//ctor / routine / prop
	parent = FindParentAttributedNode(s);
	
	//is it a varDecl?
	for(key <- mapAttributedNodeDeclarations)
	{
		for(dec <- mapAttributedNodeDeclarations[key])
		{
			for(var <- dec.nodeStatement.variables)
			{
				if(var.name == identifier)
					return dec;
			}
		}
	}

	//is it a parameter?
	for(p <- mapParameters)
	{
		if(p == identifier)
			return mapParameters[key];
	}
	
	//is it a field or property?
	aNode =	checkMapTypeDeclForId(identifier);
	if(!(aNode is astNodePlaceholder))
		return;
	
	println("Resolve identifier failed: <identifier>");
	//throw;	
}

//where has member been declared?
//from viewpoint of statement s
public AstNode ResolveMemberReference(memberReferenceExpression(str memberName, Expression target, list[AstType] typeArguments), Statement s)
{
	//this = my current class
	visit(target)
	{
		case v:thisReferenceExpression(): return checkMapTypeDeclForId(memberName);
	}
	
	
	//ClassName = Field/Property from ClassName
}

AstNode checkMapTypeDeclForId(str id)
{
	for(key <- mapTypeDeclarations)
	{
		for(aNode <- mapTypeDeclarations[key])
		{
			dec = aNode.nodeAttributedNode.nodeMemberDeclaration;
			if(dec.name == id)
				return aNode;
		}
	}
	return astNodePlaceholder();
}


public AstNode GetParent(Statement s) = GetParent(statement(s));
public AstNode GetParent(AstNode a)
{
	//public map[AstNode parent, list[AstNode] children] mapFamily 
	
	for(parent <- mapFamily)
	{
		for(child <- mapFamily[parent])
		{
			if(a == child)
				return parent;
		}
	}
}

public AstNode FindParentAttributedNode(Statement s) = FindParentAttributedNode(statement(s)); 
public AstNode FindParentAttributedNode(AstNode a)
{
	parent = GetParent(a);
	while(!(parent is attributedNode))
	{
		parent = GetParent(parent);;
	}
	return parent;
}


public list[Statement] InsideOptionalPath(Expression e, Statement s, map[Expression name, list[Statement] s] mapAssignments, map[str name, list[AstNode] a] mapTypeMemberAssignments)
{
	//e = identifier we are dependant on
	//s = statement we have to check for optional path
	//  -> the last assignment statement for our identifier
	
	for(d <- relDependence[statement(s)])
	{
		Statement subS = d.nodeStatement;
		if(subS is ifElseStatement ||
		   subS is switchSection)
		{
			//the last assignment of e is inside of an optional path
			//return the if or switch statement as dependency
			
			//also add the assignment that was before the optional path as a dependency
			//because the optional path might not get executed, and the assignment before it will be the last assignment for e
			Statement Assignment = emptyStatement();
			
			for(assignS <- reverse(mapAssignments[e]))
			{
				for(d <- relDependence[statement(assignS)])
				{
					if(d.nodeStatement != subS)
					{
						//this dependency is not the same as the if/switch statement
						Assignment = d.nodeStatement;
					}
					if(!(Assignment is emptyStatement))
						break;
				}
				
				//if(isEmpty(relDependence[statement(assignS)]))
				//{;}
				
				//check if the assignment with a different dependency (so not the if/switch) was found
				//or if this assignment does not have any dependency -> different
				if(!(Assignment is emptyStatement))
						break;
			}
			
			return [subS];
		}
	}
	
	//the last assignment was not inside an optional path.
	return [];
}

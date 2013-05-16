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
public map[str name, list[Statement] s] AddToMap(map[str uniqueName, list[Statement] s] m, str key, Statement val)
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
public AstNode ResolveIdentifier(identifierExpression(str identifier, list[AstType] typeArguments, AstType \type), Statement s)
{
		
	//is it a variableDeclarationStatement(list[Modifiers] modifiers, list[AstNode] variables, AstType \type)?
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

	//is it a parameterDeclaration(str name, list[AstNode] attributes, Expression defaultExpression, ParameterModifier parameterModifier, AstType \type)?
	for(p <- mapParameters)
	{
		if(p == identifier)
			return mapParameters[p];
	}
	
	//is it a fieldDeclaration(str name, list[AstNode] attributes, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] variables, AstType \type)
	//	   or propertyDeclaration(str name, list[AstNode] attributes, AttributedNode getter, list[AstNode] modifierTokens, list[Modifiers] modifiers, AttributedNode setter, AstType \type)?
	aNode =	checkMapTypeDeclForId(identifier);
	if(!(aNode is astNodePlaceholder))
		return aNode;
	
	return astNodePlaceholder();
	//throw;	
}

//where has the member ref been declared?
//from viewpoint of statement s
public AstNode ResolveMemberReference(memberReferenceExpression(str memberName, Expression target, list[AstType] typeArguments), Statement s)
{
	//this = my current class
	visit(target)
	{
		case t:thisReferenceExpression(): 	return checkMapTypeDeclForId(memberName);
		case t:identifierExpression(id,_,Type):
		{
			Node = GetNodeByExactType(Type);
			decl = GetNodeMemberByName(Node.nodeAttributedNode, memberName);
			return decl;
		} 
	}
	
	//ClassName = Field/Property from ClassName
}

private AstNode checkMapTypeDeclForId(str id)
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
public AstNode GetParent(AttributedNode s) = GetParent(attributedNode(s));
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

public list[Statement] InsideOptionalPath(str uniqueName, Statement s, list[Statement] FoundOptionalStats)
{
	//uniqueName = identifier we are dependend on
	//s = statement we have to check for optional path
	//  -> the last assignment statement for our identifier
	
	// if its inside an optional path, we will return the statement(if/for/while/etc)
	// and the last assignment which was not in the found optional path
	// this last assignment may be in an optional path, and will be checked by this same function(recursively)

	parent = GetParent(s);
    Statement OptionalStatement = emptyStatement();
	
	while(!(parent is attributedNode))
	{
		stat = parent;
		if(stat is statement)
			stat = parent.nodeStatement;
		//todo test all options
		if(stat is ifElseStatement ||
		   stat is forStatement ||
		   stat is foreachStatement ||
		   stat is whileStatement ||
		   stat is doWhileStatement || 
		   stat is switchStatement)
	   	{
	   		OptionalStatement = parent.nodeStatement;
	   		break;
		}
		parent = GetParent(parent);	
	}
	
	//its not inside an optional path
	if(OptionalStatement is emptyStatement)
	{
		//println("Not inside optionalpath");
		return FoundOptionalStats;
	}
	//println("Inside optional Path: <OptionalStatement>");
	
	//expand the already found optionalstatements, so we can skip those in the next recursive call
	FoundOptionalStats += OptionalStatement;

	
	//loop through the assignments to get the last assignment before our found optional statement(if/for/etc);
	Statement Assignment = emptyStatement();
	for(assignS <- reverse(mapAssignments[uniqueName]))
	{
		bool foundInOptional = false;
		parent = GetParent(assignS);
		while(!(parent is attributedNode))
		{
			if(parent is statement &&
			   parent.nodeStatement in FoundOptionalStats)
			{
				foundInOptional = true;
				break;
			}
			parent = GetParent(parent);
		}
		if(!foundInOptional)
		{
			Assignment = assignS;
			break;
		}
	}
	
	if(Assignment is emptyStatement)
	{
		//no assignment found outside the optional statement.
		//So just return the optional statement.
		return [OptionalStatement];
	}
	else
	{
		//we have found the assignment before our optional statement
		//Check if this statement is inside an optional path
		// return the statements given + the optional path
		result = InsideOptionalPath(uniqueName, Assignment, FoundOptionalStats);
		
		//if the FoundOptionalStats has not yet been expanded with an assignment, add the found assignment.
		if(result == FoundOptionalStats)
			result += Assignment;
		return result;
	}
	return [];
}

public AstNode GetNodeByExactType(exactType(str name))
{
	for(ns <- relNamespaceAttributedNode.namespace)
		for(m <- relNamespaceAttributedNode[ns])
			if(ns.name + "." + m.nodeAttributedNode.name == name)
				return m;
}

public AstNode GetNodeMemberByName(AttributedNode Node, str membername)
{
	for(an <- relAttributedNodeMember.Node)
	{
		if(an == Node)
			for(m <- relAttributedNodeMember[an])
				if(m.nodeMemberDeclaration.name == membername)
					return attributedNode(m);
	}				
	println("Element not found in relAttributedNodeMember: nodename:<nodename>; membername:<membername>");
}

public AstNode GetNodeByMember(AttributedNode member)
{
	for(an <- relAttributedNodeMember.Node)
	{
		for(m <- relAttributedNodeMember[an])
		{
			if(m == member)
				return attributedNode(an);
		}
	}
}

public void AddNewAssignment(Node, s)
{
	str uniqueName = "";
	if(Node is identifierExpression)
		uniqueName = GetUniqueNameForIdentifier(Node, s);
	else if(Node is memberReferenceExpression)
	{
		resolved = ResolveMemberReference(Node, s);
		uniqueName = GetUniqueNameForResolvedIdentifier(Node.memberName, resolved, s);
	}
	else if(Node is variableDeclarationStatement)
	{
		for(variable <- Node.variables)
		{
			if(!(variable.initializer is emptyExpression))
			{
				uniqueName = GetUniqueNameForResolvedIdentifier(variable.name, Node, s);
			}
		}
	}
	
	
	mapAssignments = AddToMap(mapAssignments, uniqueName, s);
}

//namespace.typedeclaration.fieldname/propname
//namespace.typedeclaration.routinename.varname
public str GetUniqueNameForIdentifier(ie, s)
{
	uniqueName = ie.identifier;
	resolved = ResolveIdentifier(ie, s);
	return GetUniqueNameForResolvedIdentifier(uniqueName, resolved, s);
}
public str GetUniqueNameForResolvedIdentifier(uniqueName, resolved, s)
{
	AstNode aNode;
	top-down-break visit(resolved)
	{
		case v:variableDeclarationStatement(_,_,_):
		{
			//get routinename or constructorname
			aNode = FindParentAttributedNode(v);
			if(aNode.nodeAttributedNode is constructorDeclaration)
				uniqueName = aNode.nodeAttributedNode.name + "." + uniqueName;
			else //routine
				uniqueName = aNode.nodeAttributedNode.nodeMemberDeclaration.name + "." + uniqueName;
		}
		case p:parameterDeclaration(_,_,_,_,_):
		{
			//get routinename or constructorname
			aNode = FindParentAttributedNode(p);
			if(aNode.nodeAttributedNode is constructorDeclaration)
				uniqueName = aNode.nodeAttributedNode.name + "." + uniqueName;
			else //routine
				uniqueName = aNode.nodeAttributedNode.nodeMemberDeclaration.name + "." + uniqueName;
		}
		case f:fieldDeclaration(_,_,_,_,_,_):		aNode = attributedNode(memberDeclaration(f));
		case p:propertyDeclaration(_,_,_,_,_,_,_):	aNode = attributedNode(memberDeclaration(p));
	}
	
	//get typedecl
	aNode = GetParent(aNode);
	typeName = aNode.nodeAttributedNode.name;
	
	//get namespace
	aNode = GetParent(aNode);
	namespaceName = aNode.fullName;
	
	return namespaceName + "." + typeName + "." + uniqueName;
}

public list[Statement] GetStatementsFromBranch(Statement branch)
{
	list[Statement] lstStatements = [];
	
	if(branch is emptyStatement)
		//The branch is not there, for example an if without else.
		lstStatements = [];
			
	else if(!(branch is blockStatement))
		//Its a single statement without { and }
		lstStatements  += branch;
	
	else if(!isEmpty(branch.statements))
		//it's a non-empty set of statements
		lstStatements = branch.statements;
		
	return lstStatements;
}
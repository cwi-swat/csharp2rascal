module utils::utils

import csharp::syntax::CSharpSyntax;
import csharp::processing::Globals;
import csharp::processing::typeDeclaration::Main;
import List;
import IO;
import String;

public Statement GetLastListElement(list[Statement] _list)
{
	if(isEmpty(_list))
		return emptyStatement();

	return head(reverse(_list));
}

public AstNode GetLastListElement(list[AstNode] _list)
{
	if(isEmpty(_list))
		return astNodePlaceholder();

	return head(reverse(_list));
}

public tuple[Statement, str, Statement] GetLastListElement(list[tuple[Statement, str, Statement]] _list)
{
	if(isEmpty(_list))
		return <emptyStatement(),"",emptyStatement()>;

	return head(reverse(_list));
}

public map[str, list[AstNode]] AddToMap(map[str, list[AstNode]] m, str key, AstNode val)
{
	if(key in m)
		m[key] += [val];
	else
		m += (key:[val]);
		
	return m;
}
public map[str, list[Statement]] AddToMap(map[str, list[Statement]] m, str key, Statement val)
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
public AstNode ResolveIdentifier(identifierExpression(str identifier, list[AstType] typeArguments, AstType \type))
{
		
	//is it a variableDeclarationStatement(list[Modifiers] modifiers, list[AstNode] variables, AstType \type)?
	if(key <- mapAttributedNodeDeclarations, 
	   dec <- mapAttributedNodeDeclarations[key], 
	   var <- dec.nodeStatement.variables,
	   var.name == identifier)
		return dec;
		

	//is it a parameterDeclaration(str name, list[AstNode] attributes, Expression defaultExpression, ParameterModifier parameterModifier, AstType \type)?
	if(p <- mapParameters, p == identifier)
		return mapParameters[p];
	
	//is it a fieldDeclaration(str name, list[AstNode] attributes, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] variables, AstType \type)
	//	   or propertyDeclaration(str name, list[AstNode] attributes, AttributedNode getter, list[AstNode] modifierTokens, list[Modifiers] modifiers, AttributedNode setter, AstType \type)?
	aNode =	checkMapTypeDeclForId(identifier);
	if(!(aNode is astNodePlaceholder))
		return aNode;
	
	
	//is it a local assignment?
	if(as <- listLocalAssignments,
	   endsWith(as.uniqueName, identifier))
	{
		if(as.block is catchClause ||
		   as.block is statement  ||
		   as.block is expression)
			return as.block;
		else
			return statement(as.block);
	}
	
	//is it a linq identifier?
	if(tup <- listLinqIdentifiers,
	   endsWith(tup.uniqueName, identifier))
		return statement(tup.s);
			
	throw "Resolve identifier failed: <identifier>";	
}

//where has the member ref been declared?
//from viewpoint of statement s
public AstNode ResolveMemberReference(memberReferenceExpression(str memberName, Expression target, list[AstType] typeArguments))
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
}

private AstNode checkMapTypeDeclForId(str id)
{
	if(key <- mapTypeDeclarations,
	   aNode <- mapTypeDeclarations[key],
	   aNode.nodeAttributedNode.nodeMemberDeclaration.name == id)
		return aNode;
	else
		return astNodePlaceholder();
}

public Statement GetTopMostParentStatement(Expression e) = GetTopMostParentStatement(expression(e));
public Statement GetTopMostParentStatement(Statement s) = GetTopMostParentStatement(statement(s));
public Statement GetTopMostParentStatement(AstNode ast)
{
	AstNode TopMost;
	parent = GetParent(ast);
	
	//this happens if the statement is already the topmost statement
	if(parent is statement &&
	   parent.nodeStatement is blockStatement)
	   parent = ast;
	
	while(!(parent is statement))
	{
		parent = GetParent(parent);
	}
	
	TopMost = parent;
	while(parent is statement &&
		  !parent.nodeStatement is blockStatement)
	{
		TopMost = parent;
		parent = GetParent(parent);
	}	
	return TopMost.nodeStatement;
}

public Statement GetParentStatement(Expression e)
{
	AstNode parent = GetParent(e);
	while(!(parent is statement))
	{
		parent = GetParent(parent);;
	}
	return parent.nodeStatement;
}

public AstNode GetParent(Expression e) = GetParent(expression(e));
public AstNode GetParent(Statement s) = GetParent(statement(s));
public AstNode GetParent(AttributedNode s) = GetParent(attributedNode(s));
public AstNode GetParent(AstNode a)
{
	if(parent <- mapFamily, child <- mapFamily[parent], a == child)
		return parent;
	else
	{
		println(a);
		throw "Parent not found for <a>";
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

public list[AstNode] InsideOptionalPath(str uniqueName, Statement s, AstNode s2, list[AstNode] FoundOptionalStats)
{
	//PARAMETERS:
	//uniqueName = identifier we are dependend on
	//s  = statement we are currently at with visiting
	//s2 = statement we have to check for optional path / can also be catchclause
	//  -> the last assignment statement for our identifier
	//FoundOptionalStats = The optional statements we already encountered
	
	// BEHAVIOUR:
	// if its inside an optional path, we will return the statement(if/for/while/etc)
	// and the last assignment which was not in the found optional path
	// this last assignment may be in an optional path, and will be checked by this same function(recursively)


	//first check if our current statement is inside some optional path
	//for example:
	//b = 0;
	//while(a)
	//{  b = 1;
	//	 if(b==1)
	//		a = false
	//}
	//in this case, the ifstatement depends on while(a) and b=1, Not on b=0! 
	//this is because b=1 is ALWAYS executed before the ifstatement, therefor is it not in an (different) optional path.
	
	AstNode CurrentOptionalPath = astNodePlaceholder();
	parent = GetParent(s);
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
		   stat is switchStatement ||
		   stat is catchClause)
	   	{
	   		   		
	   		CurrentOptionalPath = parent;
	   		break;
		}
		parent = GetParent(parent);
	}


	//Then check if s2 is inside some optional statement, other than the CurrentOptionalPath
	AstNode OptionalStatement = astNodePlaceholder();

	
	parent = GetParent(s2);
	
	//zolang ik geen attriburedNode vind, 
	while(!(parent is attributedNode))
	{
		Statement stat = emptyStatement();
		if(parent is statement)
			stat = parent.nodeStatement;

		// als CurrentOptionalPath niet leeg is, moet deze ongelijk zijn aan de parent die ik vind.
		// als gelijk aan dan geld s2 als assignment in een niet optioneel path(gezien vanaf s)	
		if(parent is statement &&
		   (!(CurrentOptionalPath is astNodePlaceholder) && 
		   CurrentOptionalPath == parent.nodeStatement))
			break;

		//todo test all options
		if(stat is ifElseStatement ||
		   stat is forStatement ||
		   stat is foreachStatement ||
		   stat is whileStatement ||
		   stat is doWhileStatement || 
		   stat is switchStatement ||
		   stat is catchClause)
	   	{
	   		OptionalStatement = statement(stat);
	   		break;
		}
		parent = GetParent(parent);	
	}
	
	//its not inside an optional path
	if(OptionalStatement is astNodePlaceholder)
	{
		return FoundOptionalStats;
	}
	
	//expand the already found optionalstatements, so we can skip those in the next recursive call
	FoundOptionalStats += OptionalStatement;

	
	//loop through the assignments to get the last assignment before our found optional statement(if/for/etc);
	AstNode Assignment = astNodePlaceholder();
	list[AstNode] Assignments = [];
	if(uniqueName in mapAssignments)
		Assignments = reverse([statement(as) | as <- mapAssignments[uniqueName]]);
	else
		Assignments = reverse([as.assignment | as <- listLocalAssignments, as.uniqueName == uniqueName]);
		
	//list[tuple[Statement block, str uniqueName, Statement assignment]] listLocalAssignments 	
	for(assignS <- Assignments)
	{
		bool foundInOptional = false;
		parent = GetParent(assignS);
		while(!(parent is attributedNode))
		{
			if((parent is statement &&
			    parent.nodeStatement in FoundOptionalStats) ||
			    parent in FoundOptionalStats)
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
	
	if(Assignment is astNodePlaceholder)
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
		result = InsideOptionalPath(uniqueName, s, Assignment, FoundOptionalStats);
		
		//if the FoundOptionalStats has not yet been expanded with an assignment, add the found assignment.
		if(result == FoundOptionalStats)
			result += Assignment;
		return result;
	}
	return [];
}

public AstNode GetNodeByExactType(exactType(str name))
{
	if(ns <- relNamespaceAttributedNode.namespace, 
	   m <- relNamespaceAttributedNode[ns],
	   ns.fullName + "." + m.nodeAttributedNode.name == name)
		return m;
	else
		throw "name not found <name>";
}

public AstNode GetNodeMemberByName(AttributedNode Node, str membername)
{
	if(an <- relAttributedNodeMember.Node, an == Node, 
	   m <- relAttributedNodeMember[an],
	   m.nodeMemberDeclaration.name == membername)
		return attributedNode(m);
	else
		throw "Element not found in relAttributedNodeMember: node:<Node>; membername:<membername>";
}

public AstNode GetNodeByMember(AttributedNode member)
{
	if (an <- relAttributedNodeMember.Node, m <- relAttributedNodeMember[an], m == member)
		return attributedNode(an);
	else
		throw "Member not found: <member>";	
}

public void AddNewAssignment(Node, Statement s)
{
	str uniqueName = "";
	if(Node is identifierExpression)
		uniqueName = GetUniqueNameForIdentifier(Node);
	else if(Node is memberReferenceExpression)
	{
		resolved = ResolveMemberReference(Node);
		uniqueName = GetUniqueNameForResolvedIdentifier(Node.memberName, resolved);
	}
	else if(Node is variableDeclarationStatement,
			variable <- Node.variables,
		    !(variable.initializer is emptyExpression))
		uniqueName = GetUniqueNameForResolvedIdentifier(variable.name, Node);

	//check if it is a local-var 
	if(!(GetLastLocalAssignment(uniqueName) is astNodePlaceholder))
		AddLocalAssignment(uniqueName, statement(s)); 
	else
		mapAssignments = AddToMap(mapAssignments, uniqueName, s);
}

public void AddLocalAssignment(Statement decl:variableDeclarationStatement(list[Modifiers] modifiers, list[AstNode] variables, AstType \type), Statement s)
{
	//called from for-statement
	//s = assignment & block( = forStatement)
	for(variable <- variables, !(variable.initializer is emptyExpression))
	{
		uniqueName = GetUniqueNameForResolvedIdentifier(variable.name, decl);
		AddLocalAssignment(statement(s), uniqueName, statement(s));
	}
}
public void AddLocalAssignment(str name, AstNode a)
{
	str uniqueName = "";
	if(contains(name, "."))
		uniqueName = name;
	else
		uniqueName = GetUniqueNameForResolvedIdentifier(name, a);
		
	//get block for UniqueName
	//result = foreach / for / using / catch
	block = ResolveLocalAssignmentByUniqueName(uniqueName);
		
	AddLocalAssignment(block, uniqueName, a);
}

public AstNode ResolveLocalAssignmentByUniqueName(str uniqueName)
{
	debuglist = listLocalAssignments;
	if(as <- listLocalAssignments, as.uniqueName == uniqueName)
		return as.block;
	else
	{
		println("break");
		throw "assignment not found in listLocalAssignments, should not occur. uniquename: <uniqueName>";
	}
}
public void AddLocalAssignment(AstNode block, str uniqueName, AstNode assignment)
{
	//tuple[Statement block,str uniqueName, Statement assignment]
	listLocalAssignments += <block, uniqueName, assignment>;
}

//namespace.typedeclaration.fieldname/propname
//namespace.typedeclaration.routinename.varname
public str GetUniqueNameForIdentifier(ie)
{
	uniqueName = ie.identifier;
	resolved = ResolveIdentifier(ie);
	return GetUniqueNameForResolvedIdentifier(uniqueName, resolved);
}
public str GetUniqueNameForResolvedIdentifier(uniqueName, resolved)
{
	//local function only used in the visit below
	void HandleVisit(AstNode a)
	{
		//get routinename or constructorname
		aNode = FindParentAttributedNode(a);
		if(aNode.nodeAttributedNode is constructorDeclaration)
			uniqueName = aNode.nodeAttributedNode.name + "." + uniqueName;
		else //routine
			uniqueName = aNode.nodeAttributedNode.nodeMemberDeclaration.name + "." + uniqueName;
	}
	void HandleVisit(Statement s) = HandleVisit(statement(s));

	AstNode aNode = astNodePlaceholder();
	top-down-break visit(resolved)
	{
		case v:variableDeclarationStatement(_,_,_):	HandleVisit(v);
		case p:parameterDeclaration(_,_,_,_,_):		HandleVisit(p);
		case f:fieldDeclaration(_,_,_,_,_,_):		aNode = attributedNode(memberDeclaration(f));
		case p:propertyDeclaration(_,_,_,_,_,_,_):	aNode = attributedNode(memberDeclaration(p));
		case f:forStatement(_,_,_,_):				HandleVisit(f);
		case f:foreachStatement(_,_,_):				HandleVisit(f);
		case c:catchClause(_, variableName, _):		HandleVisit(c);
	}
		
	if(aNode is astNodePlaceholder)
		throw "aNode is not initialized for uniqueName <uniqueName> with resolved <resolved>";
	//get typedecl 
	aNode = GetParent(aNode);
	typeName = aNode.nodeAttributedNode.name;
	
	//get namespace
	aNode = GetParent(aNode);
	namespaceName = aNode.fullName;
	
	return namespaceName + "." + typeName + "." + uniqueName;
}

public AstNode GetLastLocalAssignment(identifier)
{
	//get all from listLocalAssignments where uniqueName endswith uniquename, and return statement as list
	listAssignments = [as.assignment | as <- listLocalAssignments, endsWith(as.uniqueName, identifier)];
	if(isEmpty(listAssignments))
		return astNodePlaceholder();
	else
		return GetLastListElement(listAssignments);
}
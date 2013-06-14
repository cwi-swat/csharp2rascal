module csharp::processing::expression::Handler

import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::Dependence;
import csharp::processing::Globals;
import csharp::processing::utils::utils;

import IO;

public void Handle(Statement s:expressionStatement(Expression expression))
{
	Handle(expression, s);
}
public void Handle(Expression e, Statement s)
{
	//all unhandled
	return;
}
public void Handle(assignmentExpression(Expression left, AssignmentOperator operator, Expression right), Statement s)
{
	//left is always identifierExpression or memberReferenceExpression
	
	//check the operator, for some this statement is also dependent on the left-side variable
	visit(operator)
	{
		case assignmentOperatorDivide(): 	AddDependence(s, left);
		case assignmentOperatorAdd():		AddDependence(s, left);
		case assignmentOperatorMultiply():	AddDependence(s, left);
		case assignmentOperatorModulus():	AddDependence(s, left);
		case assignmentOperatorSubtract():	AddDependence(s, left);
	}

	top-down visit(right)
	{
		case i:identifierExpression(_,_,_):					AddDependence(s, i); //our assignment depends on any identifier used on the right
		case m:memberReferenceExpression(name,target,_):	
		{		
			//is it inside an invocationExpression?
			//Then it will resolve to a method
			
			resolved = ResolveMemberReference(m);
			if(resolved is attributedNode &&
			   resolved.nodeAttributedNode is memberDeclaration &&
			   resolved.nodeAttributedNode.nodeMemberDeclaration is methodDeclaration)
			{
				targetContainingNode = GetNodeByExactType(target.\type);
				targetNode = GetNodeMemberByName(targetContainingNode.nodeAttributedNode, name);
				
				//our assignment depends on the outcome of the function called
				AddDependence(s, targetNode);
				
				//the rest of the invocation handling is inside of its own function
			}
			else
				AddDependence(s, m); //our assignment depends on the member-ref used on the right
		}
	}
	
	//keep track of the assignments
	AddNewAssignment(left, s);
	
	AstNode decl;
	if(left is identifierExpression)
		decl = ResolveIdentifier(left);
	else if(left is memberReferenceExpression)
		decl = ResolveMemberReference(left);

	//every assignment on a local-var is dependend on the declaration of that var.
	if(decl is statement &&
	   decl.nodeStatement is variableDeclarationStatement)
		AddDependence(s, decl);
	
	//add a dependence between the declaration and the parent attributedNode
	//So for example, a property is dependend on a routine
	// --> some call to this property cannot be moved above that routine
	//but don't do this for parameters and local-vars.
	if(decl is parameterDeclaration ||
	   (decl is statement &&
	   decl.nodeStatement is variableDeclarationStatement))
	   return;

	parent = FindParentAttributedNode(s);
	AddDependence(decl, parent);
	AddDependence(decl, s);
}

public void Handle(e:invocationExpression(_,_))
{
	Statement s = GetParentStatement(e);
	if(s == emptyStatement())
		return;
	
	Handle(e,s);
}

public void Handle(invocationExpression(list[Expression] arguments, Expression target), Statement s)
{
	//invocationExpression:
	// instance.function(); --> relCalls extend
	// class.function();    --> relCalls extend
	//....or...
	//function();
	//<something>function()<somethingelse>
	
	AstNode targetContainingNode = astNodePlaceholder();
	str strMemberName = "";
	Expression expTarget = expressionPlaceholder();
	top-down-break visit(target)
	{
		case v:identifierExpression(name,_,_):
		{
			strMemberName = name;
			targetContainingNode = FindParentTypeDeclNode(s);
		}
		//memberReferenceExpression(str memberName, Expression target, list[AstType] typeArguments)
		case v:memberReferenceExpression(name,t,_):
		{
			expTarget = t;
			strMemberName = name;
			//NRefactory cannot resolve all types..
			//But it does resolve types declared inside the project, so check if this is the case
			//eg. IEnumerable.Range(1,10) will not be resolved.
			if(  expTarget has \type &&
			   !(expTarget.\type is typePlaceholder))
			{
				targetContainingNode = GetNodeByExactType(expTarget.\type);
			}
			elseif(expTarget is thisReferenceExpression)
			{
				targetContainingNode = FindParentTypeDeclNode(s);
			}
		}
	}

	callingNode = FindParentAttributedNode(s);
	callingContainingNode = GetNodeByMember(callingNode.nodeAttributedNode);

	GetNodeMemberByName(targetContainingNode.nodeAttributedNode, strMemberName);
	targetNode = GetNodeMemberByName(targetContainingNode.nodeAttributedNode, strMemberName);

	relCalls[<callingNode,callingNode@location>] = <targetNode,targetNode@location>;
	relCalls[<callingContainingNode,callingContainingNode@location>] = <targetContainingNode,targetContainingNode@location>;
	
	//add dependence
	AddDependence(targetNode, s);
	
	//added the following like so "var a = function();" works like a depends on function.
	AddDependence(s, targetNode);
	
	//not sure why it has to depend on exptarget, commented out....
	//if(expTarget != expressionPlaceholder())
	//{
	//	AddDependence(s, expTarget);
	//}
	
	visit(arguments)
	{
		case d:directionExpression(exp,dir):
		{
			//if the argument is given as ref parameter, this will count as an assignment
			if(dir is fieldDirectionRef)
				AddNewAssignment(exp, s);
		}
	}
}
public void Handle(objectCreateExpression(list[Expression] arguments, Expression initializer, AstType \type), Statement s)
{
	visit(arguments)
	{
		case i:identifierExpression(_,_,_):		AddDependence(s,i);
	}
	
	targetTypeNode = GetNodeByExactType(\type);
	AddDependence(s, targetTypeNode);
	
	//todo add dependence to the constructor node
}
public void Handle(unaryOperatorExpression(Expression expression, UnaryOperator operatorU), Statement s)
{
	//depends on the declaration, it has to be declared before this statement can be executed.
	AstNode decl;
	if(expression is identifierExpression)
	{
		decl = ResolveIdentifier(expression);
		if(decl is statement && decl.nodeStatement is variableDeclarationStatement)
			AddDependence(s, decl);
	}	
	
	visit(operatorU)
	{
		case op:postIncrement():	AddNewAssignment(expression, s);
  		case op:postDecrement():	AddNewAssignment(expression, s);
  		case value x:				println("Unhandeled unaryOperatorExpression with operator: <operatorU>");
	}
}
public void Handle(e:conditionalExpression(Expression condition, Expression falseExpression, Expression trueExpression))
{
	Statement s = GetParentStatement(e);

	visit(e)
	{
		case i:identifierExpression(_,_):			AddDependence(s,i);
		case m:memberReferenceExpression(_,_,_):	AddDependence(s,m);
	}	
}
public void Handle(e:queryExpression(list[QueryClause] clauses))
{
	Statement s = GetTopMostParentStatement(e);
	for(clause <- clauses)
	{
		visit(clause) 
		{
			case c:queryFromClause(_,id)				: listLinqIdentifiers += [<s,GetUniqueNameForResolvedIdentifier(id,s),s>];
			case c:queryLetClause(_,id)					: listLinqIdentifiers += [<s,GetUniqueNameForResolvedIdentifier(id,s),s>];
			case c:queryContinuationClause(id,precedingQuery):;
			case c:queryWhereClause(c):;
	 		case c:queryGroupClause(key,projection):;
	  		case c:queryOrderClause(orderings):;
			case c:querySelectClause(e):;
			case c:queryJoinClause(equalsExpression,inExpression,intoIdentifier,isGroupJoin,joinIdentifier,onExpression):;
		}
	}
}

//public void Handle(lambdaExpression(AstNode body, list[AstNode] parameters), Statement s)
//{
//	visit(parameters)
//	{
//		case p:identifierExpression(n,t):;
//	}
//
//	visit(body)
//	{
//		case s:statement(st):;
//	}
//}
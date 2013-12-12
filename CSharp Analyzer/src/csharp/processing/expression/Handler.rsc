module csharp::processing::expression::Handler

import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::Dependence;
import csharp::processing::Globals;
import csharp::processing::utils::utils;
import csharp::processing::utils::locationIncluder;

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
	AddToReadMap(right, s);

	//Add a dependence to the last assignment of our target
	if(left is memberReferenceExpression)
		AddDependence(s, left.target);
	else
		AddDependence(s, left);
		 	
 	//Also add a dependence to the last read operation of our to be assigned variable (identifier or memberRef)
	AddDependence(s, ExpressionLoc(left), true);
	
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
		case i:identifierExpression(_,_,_):	
		{
			//our assignment depends on any identifier used on the right
			//first add dependence to the last assignment
			AddDependence(s, i); 
		}
		case m:memberReferenceExpression(name,target,_):
		{
			//is it inside an invocationExpression?
			//Then it will resolve to a method
			
			if(!(m has target &&
			     m.target is typeReferenceExpression))
		   	{
			
				resolved = ResolveMemberReference(m);
				if(resolved is attributedNode &&
				   resolved.nodeAttributedNode is memberDeclaration &&
				   resolved.nodeAttributedNode.nodeMemberDeclaration is methodDeclaration)
				{
					
					//if the type is unknown, it is probably from an external library and 
					//will not contain dependencies to places inside the project
					//or so we presume.
					if(target has \type)
					{
						targetContainingNode = GetNodeByExactType(target.\type);
									
						if(targetContainingNode != astNodePlaceholder())
						{
							targetNode = GetNodeMemberByName(targetContainingNode.nodeAttributedNode, name);
							
							//our assignment depends on the outcome of the member called(e.g. property or field).
							AddDependence(s, targetNode);
							//the rest of the invocation handling is inside of its own function
						}
					}
				}
				else
					AddDependence(s, m); //our assignment depends on the member-ref used on the right
			}
		}
	}
	
	//keep track of the assignments
	AddNewAssignment(left, s);
	
	AstNode decl;
	if(left is identifierExpression)
		decl = ResolveIdentifier(left);
	else if(left is indexerExpression)
		decl = ResolveIdentifier(left.target);
	else if(left is memberReferenceExpression)
		decl = ResolveMemberReference(left);

	//decl is nothing, skip
	if(decl == astNodePlaceholder())
		return;

	//every assignment on a prop/field/local var is dependend on the declaration of that var
	if((decl is statement &&
	   decl.nodeStatement is variableDeclarationStatement) ||
	   decl is attributedNode &&
	   decl.nodeAttributedNode is memberDeclaration &&
	   (decl.nodeAttributedNode.nodeMemberDeclaration is fieldDeclaration ||
	   decl.nodeAttributedNode.nodeMemberDeclaration is propertyDeclaration))
	{
		AddDependence(s, decl);
	}
	
	//add a dependence between the declaration and the parent attributedNode
	//So for example, a property is dependend on a routine
	// --> some call to this property cannot be moved above that routine
	//but don't do this for parameters and local-vars.
	if(decl is parameterDeclaration ||
	   (decl is statement &&
	   decl.nodeStatement is variableDeclarationStatement))
	   return;

	
	parent = FindParentAttributedNode(s);
	
	//the declaration depends on the containing attrbuted node(parent)
	//because the declaration is set inside this parent
	AddDependence(decl, parent);
	
	//The declaration depends on the assignment of that declaration
	AddDependence(decl, s);
	
	//if the declaration is a field or property, the parent depends on it, and in turn on any reads or writes of it.
	if(decl is attributedNode &&
	   decl.nodeAttributedNode is memberDeclaration &&
	   (decl.nodeAttributedNode.nodeMemberDeclaration is fieldDeclaration ||
	   decl.nodeAttributedNode.nodeMemberDeclaration is propertyDeclaration))
		AddDependence(parent, decl);
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
			
			if(expTarget has \type &&
			   (expTarget.\type is exactType))
			{
				targetContainingNode = GetNodeByExactType(expTarget.\type);
			}
			elseif(expTarget is thisReferenceExpression)
			{
				targetContainingNode = FindParentTypeDeclNode(s);
			}
		}
	}
	if(targetContainingNode == astNodePlaceholder())
		return;
		
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
	
	//This is needed so this kind of thing works:
	//S1 var a = new Person()
	//S2 a.Sleep();
	//S2 has to depend on S1, an invocation also depends on the instance
	if(expTarget != expressionPlaceholder())
	{
		AddDependence(s, expTarget);  //19-11
		
		//the target instance may be used inside the function call..
		AddToReadMap(expTarget, s);
		
		//todo: inside the function all of the properties of the instance could be changed too!
	}
	
	visit(arguments)
	{
		//invocation expression uses the arguments, so depend on the last assignments
		//always do this for all arguments used
		case i:identifierExpression(_,_,_):
		{
			AddDependence(s, i);  //19-11
		}
		//if the arguments have an directionexpression, also do this:
		case d:directionExpression(exp,dir):
		{
			//if the argument is given as ref or out parameter, this will count as an assignment
			if(dir is fieldDirectionRef ||
			   dir is fieldDirectionOut)
			{
				//add as an assignment
				AddNewAssignment(exp, s);
				
				//if it counts an an assignment, it also depends on the last read operation.
				AddDependence(s, ExpressionLoc(exp), true);
			}
		}		
	}
	
 	//uses the arguments in the function call
 	AddToReadMap(arguments, s);
}
public void Handle(objectCreateExpression(list[Expression] arguments, Expression initializer, AstType \type), Statement s)
{
	breakpoint =1;
	visit(arguments)
	{
		//invocation expression uses the arguments, so depend on the last assignments
		//always do this for all arguments used
		case i:identifierExpression(_,_,_):
		{
			AddDependence(s, i);  //19-11
		}
		//if the arguments have an directionexpression, also do this:
		case d:directionExpression(exp,dir):
		{
			//if the argument is given as ref or out parameter, this will count as an assignment
			if(dir is fieldDirectionRef ||
			   dir is fieldDirectionOut)
			{
				//add as an assignment
				AddNewAssignment(exp, s);
				
				//if it counts an an assignment, it also depends on the last read operation.
				AddDependence(s, ExpressionLoc(exp), true);
			}
		}		
	}
	
	targetTypeNode = GetNodeByExactType(\type);
	
	//if the type is unknown, it is probably from an external library and 
	//will not contain dependencies to places inside the project
	//or so we presume.
	if(targetTypeNode != astNodePlaceholder())
		AddDependence(s, targetTypeNode);
		
	//todo add dependence to the constructor node
	
	AddToReadMap(arguments, s);
}
public void Handle(unaryOperatorExpression(Expression expression, UnaryOperator operatorU), Statement s)
{
	//dependence to the declaration, it has to be declared before this statement can be executed.
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
	
	AddToReadMap(expression, s);
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
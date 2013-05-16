module csharp::processing::expression::Handler

import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::Dependence;
import csharp::processing::Globals;
import utils::utils;

import IO;

public void Handle(Expression e, Statement s)
{
	return;
}

public void Handle(expressionStatement(Expression expression), Statement s)
{
	visit(expression)
	{
		case e:assignmentExpression(_,_,_):		Handle(e,s);
		case e:invocationExpression(_,_):		Handle(e,s);
		case ob:objectCreateExpression(_,_,_):	Handle(ob,s);
	}
}

public void Handle(assignmentExpression(Expression left, AssignmentOperator operator, Expression right), Statement s)
{
	//left is always identifierExpression or memberReferenceExpression
	
	//keep track of the assignments
	AddNewAssignment(left, s);	
	
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
			
			resolved = ResolveMemberReference(m, s);
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
	
	//add a dependence between the declaration and the parent attributedNode
	//So for example, a property is dependend on a routine
	// --> some call to this property cannot be moved above that routine
	
	AstNode decl;
	if(left is identifierExpression)
		decl = ResolveIdentifier(left, s);
	else if(left is memberReferenceExpression)
		decl = ResolveMemberReference(left, s);	


	//don't do this for vars and parameters.
	if(decl is parameterDeclaration ||
	   (decl is statement &&
	   decl.nodeStatement is variableDeclarationStatement))
	   return;

	parent = FindParentAttributedNode(s);
	AddDependence(decl, parent);
}
public void Handle(invocationExpression(list[Expression] arguments, Expression target), Statement s)
{
	//invocationExpression:
	// instance.function(); --> relCalls extend
	// class.function();    --> relCalls extend
	visit(target)
	{
		//memberReferenceExpression(str memberName, Expression target, list[AstType] typeArguments)
		case v:memberReferenceExpression(strMemberName,expTarget,_):
		{
			callingNode = FindParentAttributedNode(s);
			callingContainingNode = GetNodeByMember(callingNode.nodeAttributedNode);
			
			targetContainingNode = GetNodeByExactType(expTarget.\type);
			targetNode = GetNodeMemberByName(targetContainingNode.nodeAttributedNode, strMemberName);

			relCalls[callingNode] = targetNode;
			relCalls[callingContainingNode] = targetContainingNode;
		}
	}

	//if the argument is given as ref parameter, this will count as an assignment
	visit(arguments)
	{
		case d:directionExpression(exp,dir):
		{
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
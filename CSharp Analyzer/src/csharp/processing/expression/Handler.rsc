module csharp::processing::expression::Handler

import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::Main;
import csharp::processing::Dependence;
import utils::utils;

import IO;

public void Handle(Expression e, Statement s)
{
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
	
	AstNode decl;
	if(left is identifierExpression)
		decl = ResolveIdentifier(left, s);
	else if(left is memberReferenceExpression)
		decl = ResolveMemberReference(left, s);	
	
	parent = FindParentAttributedNode(s);
	AddDependence(decl, parent);
	
	mapAssignments = AddToMap(mapAssignments, left, s);
	
	visit(right)
	{
		case i:identifierExpression(_,_):	AddDependence(s, i);
	}
}

public void Handle(invocationExpression(list[Expression] arguments, Expression target), Statement s)
{
	visit(target)
	{
		case v:memberReferenceExpression(strMemberName,expTarget,_):		;
	}
}
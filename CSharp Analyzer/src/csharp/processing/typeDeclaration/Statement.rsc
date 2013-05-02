module csharp::processing::typeDeclaration::Statement

import csharp::processing::typeDeclaration::NodeWithBody;
import csharp::syntax::CSharpSyntax;
import csharp::processing::Globals;
import utils::utils;

import IO;
import List;

public void HandleIfElseStatement(Statement s)
{
	c = s.condition;
	if(c is binaryOperatorExpression)
	{
		eRight = c.right;
		operator = c.operator;
		
		if(c.left is identifierExpression)
		{
			AddDependence(s, c.left);
		}
	}

	list[Statement] lstTrueStatements = [];
	if(!(s.trueStatement is blockStatementPlaceholder))
	{
		lstTrueStatements += s.trueStatement;
	}
	else if(!isEmpty(s.trueStatement.statements))
	{
		lstTrueStatements = s.trueStatement.statements;
	}
	for(subS <- lstTrueStatements)
	{
		AddDependence(subS, s);
	}
	HandleListStatements(lstTrueStatements);
	
	if(!(s.falseStatement is emptyStatement))
	{
		list[Statement] lstFalseStatements = [];
		if(!(s.falseStatement is blockStatementPlaceholder))
		{
			lstFalseStatements += s.falseStatement;
		}
		else if(!isEmpty(s.falseStatement.statements))
		{
			lstFalseStatements = s.falseStatement.statements;
		}
		
		if(!isEmpty(lstFalseStatements))
		{
			for(subS <- lstFalseStatements)
			{
				AddDependence(subS, s);
			}
			HandleListStatements(lstFalseStatements);
		}
	}
}
public void HandleSwitchStatement(Statement s)
{
	for(section <- s.switchSections)
	{
		//section.caseLabels;
		HandleListStatements(section.statements);
	}
}
public void HandleDeclaration(Statement s)
{
	for(variable <- s.variables)
	{
		list[AstType] types = [];
		eLeft = identifierExpression(variable.name, types);
		eRight = variable.initializer;
				
		if(!(eRight is emptyExpression))
		{
			HandleAssignment(s, eLeft, eRight, assignmentOperatorAssign());
		}
	}
}
public void HandleAssignment(Statement s)
{
	HandleAssignment(s, s.expression.left, s.expression.right, s.expression.operatorA);
}
public void HandleAssignment(Statement s, Expression eLeft, Expression eRight, AssignmentOperator operator)
{
	if(eLeft is identifierExpression)
	{
		if(operator is assignmentOperatorDivide ||
		   operator is assignmentOperatorAdd ||
		   operator is assignmentOperatorMultiply ||
		   operator is assignmentOperatorModulus ||
		   operator is assignmentOperatorSubtract)
		{
			AddDependence(s, eLeft);
	   	}
		
		mapAssignments = AddToMap(mapAssignments, eLeft, s);
				
		if(eRight is primitiveExpression)
			continue;
		else if(eRight is identifierExpression)
		{
			AddDependence(s, eRight);
		}
		else if(eRight is binaryOperatorExpression)
		{
			//has to be check recursive
			//can be more than just binaryOperatorExpression
			//like inline-if or membercalls
			if(eRight.left is identifierExpression)
			{
				AddDependence(s, eRight.left);
			}
			else if(eRight.right is identifierExpression)
			{
				AddDependence(s, eRight.right);
			}
		}
		//todo other assignment options, like e+3
		//???
	}
}
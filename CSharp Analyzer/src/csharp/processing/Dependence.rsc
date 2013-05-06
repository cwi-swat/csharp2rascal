module csharp::processing::Dependence

import IO;
import List;

import csharp::processing::statement::Handler;
import csharp::processing::Globals;
import csharp::syntax::CSharpSyntax;
import csharp::processing::statement::Block;
import csharp::processing::typeDeclaration::Main;
import utils::utils;


public void AddDependence(Statement s, Expression e)
{
	AddDependence(s, expression(e));
}

public void AddDependence(Statement s, Statement s2)
{
	AddDependence(s, statement(s2));
}

public void AddDependence(AstNode node1, AstNode node2)
{
	relDependence += <node1,node2>;
}

// Statement s is dependent on the last assignment of Astnode astnode
// which is a local expressionStatement, a parameter or a memberDeclaration(with initializer)
public void AddDependence(Statement s, AstNode astnode)
{
	if(astnode is statement)
	{
		relDependence += <statement(s), astnode>;
		return;
	}
	
	if(astnode is expression)
	{
		//get the statement where the id was last assigned
		s2 = emptyStatement();
		
		if(astnode.nodeExpression in mapAssignments)
			s2 = GetLastListElement(mapAssignments[astnode.nodeExpression]);
		
		
		if(s2 is emptyStatement)
		{
			//astnode isnt assigned inside the body, check if its a parameter
			memberName = "";
			
			exp = astnode.nodeExpression;
			//get name from astnode (identifierExpression / memberReferenceExpression / ??
			if(exp is identifierExpression)
				memberName = exp.identifier;
			if(exp is memberReferenceExpression)
				memberName = exp.memberName;
			
			if(memberName in mapParameters)
			{
				//astnode is a parameter, add to the depMap
				p = mapParameters[memberName];
				relDependence += <statement(s), p>;
			}
			//astnode isnt assigned inside the body and it is not a parameter, check for memberdeclaration assignments.
			else if(memberName in mapTypeMemberAssignments)
			{
				s2 = GetLastListElement(mapTypeMemberAssignments[memberName]);
				
				relDependence += <statement(s), s2>;
			}
			//check if the identifier is "value", in that case were inside an accessor and can ignore the statement
			else if(memberName == "value")
				return;
				
			return;
		}
		
		
		//check if s2 is inside an optional path (if/switch)
		//if so, return the if/switch statement as a depenceny
		//also return the last assignment before the if/switch-statement
		listStatements = InsideOptionalPath(astnode.nodeExpression, s2, mapAssignments, mapTypeMemberAssignments);
		
		if(!(isEmpty(listStatements ))) //add the found dependency statements to the rel
			for(s3 <- listStatements) 
				relDependence += <statement(s), statement(s3)>;
		else
			relDependence += <statement(s), statement(s2)>;
			
	}
}
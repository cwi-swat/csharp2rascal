module csharp::processing::typeDeclaration::NodeWithBody

import IO;

import csharp::processing::Globals;
import csharp::syntax::CSharpSyntax;
import csharp::processing::typeDeclaration::Statement;
import utils::utils;

//we need a map[str name, list[AstNode] a];
public map[str name, list[AstNode] a] mapTypeMemberAssignments;

//we need a map[Expression name, list[Statement] s] 
public map[Expression name, list[Statement] s] mapAssignments = ();

public void HandleNodeWithBody(map[str name, list[AstNode] a] _mapTypeMemberAssignments, Statement blockStatement)
{
	mapTypeMemberAssignments = _mapTypeMemberAssignments;
	mapAssignments = ();
	
	if(blockStatement is emptyStatement)
		return;
	
	HandleListStatements(blockStatement.statements);
	
	Read(mapAssignments, "mapAssignments");
	Read(relDependence, "relDependence");
}


public void AddDependence(Statement s, Expression e)
{
	AddDependence(s, expression(e));
}

public void AddDependence(Statement s, Statement s2)
{
	AddDependence(s, statement(s2));
}

// statement s is dependent on the last assignment of astnode
// which is a local expressionStatement or a memberDeclaration
public void AddDependence(Statement s, AstNode astnode)
{
	if(astnode is statement)
		relDependence += <statement(s), astnode>;
	else if(astnode is expression)
	{
		//get the statement where the id was last assigned
		s2 = GetLastListElement(mapAssignments[astnode.nodeExpression]);
		
				
		if(s2 is emptyStatement)
		{
			//astnode isnt assigned inside the body, check for memberdeclaration assignments.
			memberName = "";
			
			exp = astnode.nodeExpression;
			//get name from astnode (identifierExpression / memberReferenceExpression / ??
			if(exp is identifierExpression)
				memberName = exp.identifier;
			if(exp is memberReferenceExpression)
				memberName = exp.memberName;
			
			s2 = GetLastListElement(mapTypeMemberAssignments[memberName]);

			relDependence += <statement(s), s2>;
		}
		else
		{	
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
}

public void HandleListStatements(list[Statement] statements)
{
	for(s <- statements)
	{
		if(s is variableDeclarationStatement)
		{
			HandleDeclaration(s);
			continue;
		}
		if(s is expressionStatement)
		{
			if(s.expression is assignmentExpression)
			{
				HandleAssignment(s);
			}
			continue;
		}
		if(s is ifElseStatement)
		{
			HandleIfElseStatement(s);
			continue;
		}
		if(s is switchStatement)
		{
			HandleSwitchStatement(s);
			continue;
		}
	}
}
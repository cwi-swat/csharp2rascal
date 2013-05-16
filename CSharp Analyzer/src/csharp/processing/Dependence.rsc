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
	if(astnode is expression)
	{
		if(astnode.nodeExpression is memberReferenceExpression)
		{
			resolved = ResolveMemberReference(astnode.nodeExpression, s);
			uniqueName = GetUniqueNameForResolvedIdentifier(astnode.nodeExpression.memberName, resolved, s);

			s2 = emptyStatement();
			if(uniqueName in mapAssignments)
				s2 = GetLastListElement(mapAssignments[uniqueName]);
			
			if(s2 is emptyStatement)
			{
				//the member was not assigned inside the body
				//so it is just dependant on the member itself
				relDependence += <statement(s), resolved>;
			}
			else
			{
				//we found the last assignment, check if its inside an optional path
				CheckForOptionalPath(uniqueName, s2, s);
			}
			return;
		}
		else if(astnode.nodeExpression is identifierExpression)
		{
			//the dependence is to an identifier, check where it was last assigned.
			memberName = astnode.nodeExpression.identifier;

			//check if the identifier is "value", in that case were inside an accessor and can ignore the statement
			if(memberName == "value")
				return;
			
			s2 = emptyStatement();
			str uniqueName = GetUniqueNameForIdentifier(astnode.nodeExpression, s);
			if(uniqueName in mapAssignments)
				s2 = GetLastListElement(mapAssignments[uniqueName]);
			//println("s2 <s2>");
			
			if(s2 is emptyStatement)
			{
				//astnode isnt assigned inside the body, its a parameter
				if(memberName in mapParameters)
				{
					//astnode is a parameter, add to the depMap
					p = mapParameters[memberName];
					relDependence += <statement(s), p>;
				}
				else
				{
					println("unhandled case found in AddDependence! statement= <s>");
					throw;
				}
			}
			else
			{
				//we found the last assignment, check if its inside an optional path
				CheckForOptionalPath(uniqueName, s2, s);
			}
			return;
		}
	}
	
	//if none of the above:
	//	nothing complicated, just add the new dependence
	relDependence += <statement(s), astnode>;
}
private void CheckForOptionalPath(str uniqueName, Statement s2, Statement s)
{
	//check if s2 is inside an optional path (if/switch/do/for/etc)
	//if so, return the statement as a depenceny
	//also return the last assignment before the if/switch-statement
	listStatements = InsideOptionalPath(uniqueName, s2, []);

	if(!(isEmpty(listStatements ))) //add the found dependency statements to the rel
		for(s3 <- listStatements) 
			relDependence += <statement(s), statement(s3)>;
	
	else //its not inside an optional path
		relDependence += <statement(s), statement(s2)>;
}
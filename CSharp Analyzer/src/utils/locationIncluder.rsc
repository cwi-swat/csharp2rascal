module utils::locationIncluder

import csharp::syntax::CSharpSyntax;
import IO;

void CheckForAnnotation(Node)
{
	if(!(Node@location)?)
	{
		a = 1;
		throw "No location found on <Node>";
	}
}

public AstNode AttributedNodeLoc(AttributedNode Node)
{
	CheckForAnnotation(Node);
	return attributedNode(Node)[@location=Node@location];
}

public AstNode StatementLoc(Statement Node)
{
	CheckForAnnotation(Node);
	return statement(Node)[@location=Node@location];
}

public AstNode ExpressionLoc(Expression Node)
{
	CheckForAnnotation(Node);
	return expression(Node)[@location=Node@location];
}

public AttributedNode MemberDeclarationLoc(MemberDeclaration Node)
{
	CheckForAnnotation(Node);
	return memberDeclaration(Node)[@location=Node@location];
}

public AstNode QueryClauseLoc(QueryClause Node)
{
	CheckForAnnotation(Node);
	return queryClause(Node)[@location=Node@location];
}
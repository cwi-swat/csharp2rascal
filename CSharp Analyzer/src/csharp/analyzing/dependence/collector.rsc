module csharp::analyzing::dependence::collector

import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::Globals;
import csharp::processing::utils::locationIncluder;

public rel[tuple[AstNode Node,loc l] from,tuple[AstNode DependendOn,loc l] to] GetDependences()
{
	
	relDeps = relDependence+;
	
	return relDeps;
}



//public rel[AstNode DependendOn,loc l] GetDependences(AstNode ast)
//{
// 	rel[AstNode DependendOn,loc l] deps = relDependence[<ast,ast@location>];
// 	
// 	//get all dependencies from the child-blocks
// 	visit(ast)
// 	{
// 		case b:blockStatement(body):
// 		{
// 			for(s<-body)
// 				deps += relDependence[<StatementLoc(s),s@location>];
// 		}
// 	}
// 	
// 	//get parent dependencies
// 	//collect all the dependencies of our dependencies and so on.
// 	deps += GetParentDependencies(deps);
// 	
// 	return deps;
//}
//
//rel[AstNode DependendOn,loc l] GetParentDependencies(rel[AstNode DependendOn,loc l] deps)
//{
//	rel[AstNode DependendOn,loc l] depCollection = {};
//	for(d <- deps)
//	{
//		parentDeps = relDependence[<d.DependendOn,d.DependendOn@location>];
//		depCollection += parentDeps;
//		depCollection += GetParentDependencies(parentDeps);
//	}
//	return depCollection;
//}
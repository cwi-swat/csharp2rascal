module csharp::analyzing::try2::IndependentStats

import Set;
import Relation;
import IO;

import csharp::processing::Globals;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::Main;
import csharp::processing::utils::utils;
import csharp::processing::utils::locationIncluder;
import csharp::analyzing::dependence::collector;

public void main()
{
	GetIndependentStats();
}
rel[tuple[AstNode,loc] from, tuple[AstNode,loc] to] relDeps = {};
public rel[tuple[AstNode, loc],tuple[AstNode, loc]] GetIndependentStats()
{
	relPossible = GetAllPossibilities();
	
	Read(relPossible, "possible parallel");
	
	relValid = ValidatePossibilities(relPossible);
	
	Read(relValid, "possible swapping");
	
	return relValid;

}
public rel[tuple[AstNode, loc],tuple[AstNode, loc]] GetAllPossibilities()
{
	rel[tuple[AstNode, loc],tuple[AstNode, loc]] relIndependentStats = {}; 
	StartProcessing();	
	
	//Read(relDependence, "relDependence");
	
	//Transitive closure + self to self
	relDeps = relDependence*;
	
	//But why do this?!
	//Add both ways (x -> y, then y -> x)
	for(d <- relDeps, !(<d.to,d.from> in relDeps))
	{
		relDeps += <d.to,d.from>;
	}
	
	//Read(relDeps, "deps");
	
	//all statements with in any dependence(all statements)
	setAll = carrier(relDependence);
	
	//alle mogelijke volgordes van statements
	relAlles = (setAll * setAll);
	
	//alle valide mogelijke volgordes
	relMogelijk = (relAlles - relDeps);
  	
  	visit (Project) {
   		case b:blockStatement(stats):
		{
			for([*_,x,*_,y,*_] := stats)
			{
				if(<<statement(x),x@location>,<statement(y),y@location>> in relMogelijk) {
					relIndependentStats += <<statement(x),x@location>,<statement(y),y@location>>;
				}
			}
		}
	}
	
	return relIndependentStats;
}

public rel[tuple[AstNode, loc],tuple[AstNode, loc]] ValidatePossibilities(rel[tuple[AstNode Node, loc l] s1,tuple[AstNode Node, loc l] s2] relPossible)
{
	rel[tuple[AstNode, loc],tuple[AstNode, loc]] relValid = {};
	for(p <- relPossible)
	{
		if(canSwap(p.s1,p.s2))
			relValid += <p.s1,p.s2>;
	}
	return relValid;
}
bool canSwap(tuple[AstNode, loc] A, tuple[AstNode, loc] B)
{
	bool found = false;
	visit (Project) {
   		case b:blockStatement(_stats): {
   			stats = [<StatementLoc(s),s@location> |  s<- _stats];
			for(A in stats,
			    B in stats,
			    s <- stats)
			{
				if(s == A)
				{
					found = true;
					continue;
				}
				
				x = relDeps[s];
				if(found,
				   A in relDeps[s])
				{
					return false;
				}
				
				//No statement between A and B(including B) is dependend on A
				if(s == B)
				{
					return true;
				}
		    }
		}
	}
	return false;
}

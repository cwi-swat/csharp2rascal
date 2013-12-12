module csharp::analyzing::try2::IndependentStats

import Set;
import Relation;
import IO;
import List;

import csharp::processing::Globals;
import csharp::CSharpSyntax::CSharpSyntax;
import csharp::processing::Main;
import csharp::processing::utils::utils;
import csharp::processing::utils::locationIncluder;
import csharp::analyzing::dependence::collector;

bool PrintSingleSwap = false;
bool PrintMultiSwap = true;
bool PrintForDOT = true;

public void main()
{
	if(isEmpty(relDependence) || forceCalc)
		StartProcessing();
	
	Read(relDependence, "relDeps");
	GetIndependentStats();
}
rel[tuple[AstNode,loc] from, tuple[AstNode,loc] to] relDeps = {};
public rel[tuple[AstNode, loc],tuple[AstNode, loc]] GetIndependentStats()
{
	relIndependent = GetIndependentStatements();
	
	Read(relIndependent, "Independent Statements");
	
	relSingleSwapping = GetSingleSwapping(relIndependent);
	
	if(PrintSingleSwap)
		Read(relSingleSwapping, "Single Swapping");
	
	relMultiSwapping = GetMultiSwapping(relIndependent);
	
	
	if(PrintMultiSwap)
	{
		println();
		println("Multi swapping");
		for(key <- relMultiSwapping.s)
		{
			//swappable statement
			Println(key, 1);
			for(r <- relMultiSwapping[key]) 
			{
				//swap with statement
				Println(r.from,2);
				//untill statement
				Println(r.to,3);
			}
		}
		
		println();
		println();
		
		//print for swapping tool:

		for(key <- relMultiSwapping.s)
		{
			PrintlnForMultiSwapping(key, "line");
			for(r <- relMultiSwapping[key]) 
			{
				PrintlnForMultiSwapping(r.from, "from");
				PrintlnForMultiSwapping(r.to, "to");
			}
		}
	}
	if(PrintForDOT)
		ReadForDOT(relDependence, "relDeps");
	
	return relIndependent;
}

public rel[tuple[AstNode, loc],tuple[AstNode, loc]] GetIndependentStatements()
{
	rel[tuple[AstNode, loc],tuple[AstNode, loc]] relIndependentStats = {}; 
	
	if(isEmpty(relDependence))
		StartProcessing();
	
	//Read(relDependence, "relDependence");
	
	//Transitive closure + self to self
	relDeps = relDependence*;
	
	////But why do this?!
	////Add both ways (x -> y, then y -> x)
	//for(d <- relDeps, !(<d.to,d.from> in relDeps))
	//{
	//	relDeps += <d.to,d.from>;
	//}
	
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

public rel[tuple[AstNode, loc],tuple[AstNode, loc]] GetSingleSwapping(rel[tuple[AstNode Node, loc l] s1,tuple[AstNode Node, loc l] s2] relPossible)
{
	rel[tuple[AstNode, loc],tuple[AstNode, loc]] relValid = {};
	for(p <- relPossible)
	{
		if(canSingleSwap(p.s1,p.s2))
			relValid += <p.s1,p.s2>;
	}
	return relValid;
}
public bool canSingleSwap(tuple[AstNode, loc] A, tuple[AstNode, loc] B)
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
				
				dbg1 = relDeps[s];
				if(found)
				{
					//Does a statement between A and B depend on A? 
					if(A in relDeps[s])
					{
						return false;
					}
					
					//Does B depend on a statement between A and B?
					if(s in relDeps[B] &&
					   s != B)
					{
						return false;
					}
				}
				//No statement between A and B(including B) is dependend on A
				//and B depends on no statement between A and B
				if(s == B)
				{
					return true;
				}
		    }
		}
	}
	return false;
}

public rel[tuple[AstNode, loc] s, tuple[tuple[AstNode, loc] from,tuple[AstNode, loc] to] t] GetMultiSwapping(rel[tuple[AstNode Node, loc l] s1,tuple[AstNode Node, loc l] s2] relPossible)
{
	rel[tuple[AstNode, loc],tuple[tuple[AstNode, loc],tuple[AstNode, loc]]] relValid = {};
	for(p <- relPossible)
	{
		untillStatement = p.s2;
		canMultiSwap(p.s1, p.s2);
		if(untillStatement != p.s2)
			relValid += <p.s1,<p.s2,untillStatement>>;
	}
	return relValid;
}
tuple[AstNode, loc] untillStatement;
public void canMultiSwap(tuple[AstNode, loc] A, tuple[AstNode, loc] B)
{
	bool Afound = false;
	bool BFound = false;
	visit (Project) {
   		case b:blockStatement(_stats): {
   			stats = [<StatementLoc(s),s@location> |  s<- _stats];
			for(A in stats,
			    B in stats,
			    s <- stats)
			{
				if(s == A)
				{
					Afound = true;
					continue;
				}
				
				
				if(Afound)
				{
					//Does a statement between A and B depend on A?
					dbg1 = relDeps[s]; 
					if(A in relDeps[s])
					{
						return;
					}
					
					//Does B depend on a statement between A and B?
					dbg2 = relDeps[B];
					dom = domain(relDeps); 
					if(s in relDeps[B] &&
					   s != B)
					{
						//Read(relDeps, "Where is result2?");
						return;
					}
				}
				
				if(s == B)
				{
					BFound = true;
				}
				
				if(BFound)
				{
					untillStatement = s;
				}
		    }
		}
	}
}
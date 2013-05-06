module csharp::reader::FileInput

import csharp::syntax::CSharpSyntax;
import ValueIO;


public loc folderPath = |file:///C:/Uitvoering/Workspace/git/csharp2rascal/NRefactory/ASTGetter/GeneratedOutput/|;

list[str] files = 
[
	
];

//str filename = "All.rsc";
//str filename = "specificcases/UsingAliasCase.rsc";
//str filename = "Aisle.rsc";
//str filename = "Company.rsc";
//str filename = "ISellable.rsc";
//str filename = "Item.rsc";
//str filename = "Milk.rsc";
str filename = "Product.rsc";
//str filename = "Shopper.rsc";
//str filename = "ShoppingCart.rsc";
//str filename = "Store.rsc";
//str filename = "specificcases/linq.rsc";
//str filename = "specificcases/dowhilecase.rsc";
//str filename = "specificcases/forcase.rsc";
//str filename = "specificcases/foreachcase.rsc";
//str filename = "specificcases/enumCase.rsc";
//str filename = "specificcases/eventCase.rsc";
//str filename = "specificcases/fixedUnsafeCheckedUncheckedCase.rsc";
//str filename = "specificcases/yieldcase.rsc";
//str filename = "specificcases/typeparameter.rsc";
//str filename = "specificcases/AttributeCase.rsc";
//str filename = "specificcases/EventCase.rsc";


public CSharpProject readCSharpProject()
{
	return readCSharpProject(folderPath + filename);
}
public CSharpProject readCSharpProject(loc file)
{
	return readTextValueFile(#CSharpProject, file);
}

public bool parseAllFiles()
{
	for(file <- files)
	{
		readCSharpProject(folderPath + "All.rsc");
	}
	return true;
}

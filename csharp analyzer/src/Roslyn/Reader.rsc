module Roslyn::Reader

import Roslyn::CSharpSyntax;
import ValueIO;

//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/shoppingcart.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/aisle.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/linq.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/dowhilecase.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/forcase.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/foreachcase.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/enumCase.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/eventCase.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/fixedUnsafeCheckedUncheckedCase.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/yieldcase.cs|;
//loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/typeparameter.cs|;
loc filename = |file:///C:/Uitvoering/NRefactory/ASTGetter/Output/specificcases/AttributeCase.cs|;


public CSharpProject read()
{
	return read(filename);
}
public CSharpProject read(loc file)
{
	return  readTextValueFile(#CSharpProject, file);
}
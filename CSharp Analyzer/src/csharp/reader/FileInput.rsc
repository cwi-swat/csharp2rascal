module csharp::reader::FileInput

import csharp::syntax::CSharpSyntax;
import ValueIO;


loc folderPath = |file:///C:/Uitvoering/Workspace/git/csharp2rascal/NRefactory/ASTGetter/GeneratedOutput/|;
//str filename = "product.rsc";
//str filename = "aisle.rsc";
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
str filename = "specificcases/EventCase.rsc";


public CSharpProject read()
{
	return read(folderPath + filename);
}
public CSharpProject read(loc file)
{
	return  readTextValueFile(#CSharpProject, file);
}


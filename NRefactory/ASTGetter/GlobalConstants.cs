using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AST_Getter
{
    public abstract class GlobalConstants
    {
        //coming from the .exe executable in the debug or release folder
        //'C:\Uitvoering\Workspace\git\csharp2rascal\NRefactory\ASTGetter\bin\Debug\'.
        public const string SolutionPath = @"..\..\..\";

        public const string OutputPath = SolutionPath + @"ASTGetter\Output\";
        public const string ExampleCodePath = SolutionPath + @"ExampleCode\";

        public const string FirstFileToProcess = "Aisle";
    }
}

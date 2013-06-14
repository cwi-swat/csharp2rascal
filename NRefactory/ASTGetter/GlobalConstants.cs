namespace AST_Getter
{
    public abstract class GlobalConstants
    {
        //coming from the .exe executable in the debug or release folder
        //'C:\Uitvoering\Workspace\git\csharp2rascal\NRefactory\ASTGetter\bin\Debug\'.
        public const string SolutionPath = @"..\..\..\";

        public const string OutputPath = SolutionPath + @"ASTGetter\GeneratedOutput\";
        public const string ExampleCodePath = SolutionPath + @"ExampleCode\";

        public const string FirstFileToProcess = @"Shopper";
        //public const string FirstFileToProcess = @"Product";


        public const bool IncludingLocations = true;
    }
}

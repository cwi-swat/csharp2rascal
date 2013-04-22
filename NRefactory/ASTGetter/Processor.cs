using System;
using System.IO;
using System.Linq;
using ICSharpCode.NRefactory.CSharp;

namespace AST_Getter
{
    class Processor
    {
        

        public static void Process()
        {
            var reader = File.OpenText(GlobalConstants.Path + GlobalConstants.Filename);
            var parser = new CSharpParser();
            var syntaxTree = parser.Parse(reader.ReadToEnd());
            
            if (!parser.Errors.Any())
            {
                var visitor = new Visitor.Visitor(GlobalConstants.Filename);

                //visit the entire tree -> entry point
                visitor.VisitSyntaxTree(syntaxTree);

                var output = "[" + visitor.Output.S + "]";

                File.WriteAllText(@"C:\Uitvoering\NRefactory\ASTGetter\Output\" + GlobalConstants.Filename, output);
                System.Diagnostics.Process.Start(@"C:\Uitvoering\NRefactory\ASTGetter\Output\" + GlobalConstants.Filename);
            }
            else
            {
                foreach (var error in parser.Errors)
                {
                    Console.WriteLine("Parse error: " + error.Message + ", region: " + error.Region);
                    Console.Read();
                }
            }
        }
    }
}

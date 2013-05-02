using System;
using System.IO;
using System.Linq;
using AST_Getter.Helpers;
using ICSharpCode.NRefactory.CSharp;

namespace AST_Getter
{
    internal class Processor
    {
        public static void Process()
        {
            var files = Directory.GetFiles(GlobalConstants.ExampleCodePath, "*.cs", SearchOption.AllDirectories).ToList();

            var firsttoproces = GlobalConstants.ExampleCodePath + GlobalConstants.FirstFileToProcess + ".cs";
            files.Insert(0, firsttoproces);

            var allFiles = new FormatHelper("[");

            foreach (var file in files)
            {
                if (file.Contains("Temporary") ||
                    file.EndsWith("AssemblyInfo.cs") ||
                    file.Equals(firsttoproces))
                    continue;

                var fileInfo = new FileInfo(file);

                using (var reader = File.OpenText(fileInfo.FullName))
                {
                    var parser = new CSharpParser();
                    var syntaxTree = parser.Parse(reader.ReadToEnd());

                    if (!parser.Errors.Any())
                    {
                        var visitor = new Visitor.Visitor(fileInfo.FullName);

                        //visit the entire tree -> entry point
                        visitor.VisitSyntaxTree(syntaxTree);

                        allFiles.AddWithComma(visitor.Output.S);
                        allFiles.Add(Environment.NewLine);

                        var output = "[" + visitor.Output.S + "]";

                        //prepare path to write to, kind of dynamic
                        var examplepath = GlobalConstants.ExampleCodePath.Trim('.', '\\');
                        var filepath = GlobalConstants.OutputPath +
                                                    fileInfo.FullName.Substring(fileInfo.FullName.IndexOf(examplepath, StringComparison.Ordinal))
                                                    .Replace(examplepath, "")
                                                    .Replace(fileInfo.Extension, "")
                                                    + ".rsc";
                        var fileToWrite = new FileInfo(filepath);

                        //directory might be new
                        if (fileToWrite.DirectoryName != null) Directory.CreateDirectory(fileToWrite.DirectoryName);
                        File.WriteAllText(filepath, output);
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
            allFiles.Add("]");
            File.WriteAllText(GlobalConstants.OutputPath + "All.rsc", allFiles.S);
#if DEBUG
            Console.Write("Open file?");
            Console.WriteLine(GlobalConstants.OutputPath + GlobalConstants.FirstFileToProcess + ".rsc");
            Console.WriteLine("y for open, any for close.");
            var r = Console.ReadKey();
            if(r.Key == ConsoleKey.Y)
                System.Diagnostics.Process.Start(GlobalConstants.OutputPath + GlobalConstants.FirstFileToProcess + ".rsc");
#endif
        }
    }
}
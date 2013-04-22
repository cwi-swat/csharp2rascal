using System;
using System.IO;
using System.Linq;
using ICSharpCode.NRefactory.CSharp;

namespace AST_Getter
{
    internal class Processor
    {
        public static void Process()
        {
            var files = Directory.GetFiles(GlobalConstants.ExampleCodePath, "*.cs", SearchOption.AllDirectories).ToList();
            files.Insert(0, GlobalConstants.ExampleCodePath + GlobalConstants.FirstFileToProcess +".cs");

            foreach (var file in files)
            {
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
            System.Diagnostics.Process.Start(GlobalConstants.OutputPath + GlobalConstants.FirstFileToProcess + ".rsc");
        }
    }
}
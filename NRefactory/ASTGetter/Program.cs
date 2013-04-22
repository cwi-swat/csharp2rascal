using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ICSharpCode.NRefactory.CSharp;
using ICSharpCode.NRefactory.Editor;

namespace AST_Getter
{
    class Program
    {
        public static void Main(string[] args)
        {
            Processor.Process();
        }
    }
}

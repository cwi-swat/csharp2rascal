using ICSharpCode.NRefactory.TypeSystem;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace AST_Getter.Resolve
{
    public class Assemblies
    {
        //todo make this dynamic?

        public static Lazy<IList<IUnresolvedAssembly>> builtInLibs = new Lazy<IList<IUnresolvedAssembly>>(
            delegate
            {
                Assembly[] assemblies = {
					typeof(Uri).Assembly, // System.dll
					typeof(System.Linq.Enumerable).Assembly, // System.Core.dll
					typeof(System.Xml.XmlDocument).Assembly, // System.Xml.dll
                    typeof(System.Xml.Linq.Extensions).Assembly, // System.Xml.Linq.dll
                    typeof(System.Data.DataRow).Assembly, // System.Data
				};
                IUnresolvedAssembly[] projectContents = new IUnresolvedAssembly[assemblies.Length];
                Parallel.For(
                    0, assemblies.Length,
                    delegate(int i)
                    {
                        CecilLoader loader = new CecilLoader();
                        projectContents[i] = loader.LoadAssemblyFile(assemblies[i].Location);
                    });

                return projectContents;
            });
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ICSharpCode.NRefactory.CSharp;

namespace AST_Getter.Helpers
{
    static class CollectionHelper
    {
        public static string Get(AstNodeCollection<AstType> types)
        {
            String type = "";
            types.ToList().ForEach(t =>
                {
                    type += CommonHelper.Get(t, t) + ",";
            });
            return "[" + type + "]";
        }
        
        public static IEnumerable<string> Get<T>(AstNodeCollection<T> astNodeCollection) where T : AstNode
        {
            return (from node in astNodeCollection 
                    where node.RascalString != node.ToString() 
                    select node.RascalString).ToList();
        }
    }
}

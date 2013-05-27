using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ICSharpCode.NRefactory.CSharp;

namespace AST_Getter.Helpers
{
    static class StatementHelper
    {
        internal static string Get<T>(T statement) where T : Statement
        {
            if (statement.IsNull)
                return "emptyStatement()" + LocationHelper.EmptyLocation;
            else
                return statement.RascalString;
        }
    }
}

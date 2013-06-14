using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ICSharpCode.NRefactory.CSharp;

namespace AST_Getter.Helpers
{
    static public class ExpressionHelper
    {
        internal static string Get<T>(T expression) where T : Expression
        {
            if (expression.IsNull)
                return "emptyExpression()" + LocationHelper.EmptyLocation;
                
            return expression.RascalString;
        }
        internal static string Get(Expression expression)
        {
            if (expression.IsNull)
                return "emptyExpression()" + LocationHelper.EmptyLocation;

            return expression.RascalString;
        }
    }
}

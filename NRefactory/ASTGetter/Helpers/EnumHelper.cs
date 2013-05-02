using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ICSharpCode.NRefactory.CSharp;
using ICSharpCode.NRefactory.TypeSystem;

namespace AST_Getter.Helpers
{
    static class EnumHelper
    {
        internal static string Translate(Modifiers modifier)
        {
            var modifiers = modifier.ToString().Split(',');
            var rascalString = "";
            foreach (var m in modifiers)
            {
                rascalString += "modifiers" + m.Trim() + "(),";
            }

            return "[" + rascalString + "]";
        }

        internal static string Translate(ParameterModifier modifier)
        {
            var parameterModifier = "parameterModifier";

            switch (modifier)
            {
                case ParameterModifier.This:
                    parameterModifier += "This";
                    break;
                case ParameterModifier.None:
                    parameterModifier += "None";
                    break;
                case ParameterModifier.Params:
                    parameterModifier += "Params";
                    break;
                case ParameterModifier.Ref:
                    parameterModifier += "Ref";
                    break;
                case ParameterModifier.Out:
                    parameterModifier += "Out";
                    break;
            }

            return parameterModifier + "()";
        }

        internal static string Translate(BinaryOperatorType binaryOperatorType)
        {
            return ConvertToLowerCaseWithParentheses(binaryOperatorType.ToString()); 
        }

        internal static string Translate(UnaryOperatorType unaryOperatorType)
        {
            return ConvertToLowerCaseWithParentheses(unaryOperatorType.ToString());
        }
        
        internal static string Translate(ConstructorInitializerType constructorInitializerType)
        {
            switch (constructorInitializerType)
            {
                case ConstructorInitializerType.Base:
                    return "base()";
                case ConstructorInitializerType.This:
                    return "this()";
                default:
                    throw new NotImplementedException();
            }
        }

        internal static string Translate(QueryOrderingDirection queryOrderingDirection)
        {
            return String.Format("queryOrderingDirection{0}()", queryOrderingDirection.ToString());
        }

        internal static string Translate(FieldDirection fieldDirection)
        {
            return String.Format("fieldDirection{0}()", fieldDirection.ToString());
        }

        internal static string Translate(VarianceModifier varianceModifier)
        {
            string format;

            switch (varianceModifier)
            {
                case ICSharpCode.NRefactory.TypeSystem.VarianceModifier.Contravariant:
                    format = "contravariant()";
                    break;
                case ICSharpCode.NRefactory.TypeSystem.VarianceModifier.Covariant:
                    format = "covariant()";
                    break;
                case ICSharpCode.NRefactory.TypeSystem.VarianceModifier.Invariant:
                    format = "invariant()";
                    break;
                default:
                    throw new ArgumentException("enum value not found on VarianceModifier");
            }

            return format;
        }
 
        internal static string Translate(AssignmentOperatorType Enum)
        {
            return "assignmentOperator" + Enum.ToString() + "()";
        }

        private static string ConvertToLowerCaseWithParentheses(string s)
        {
            var _s = s.Substring(0, 1).ToLower();
            _s += s.Substring(1);
            return _s + "()";
        }

       
    }
}

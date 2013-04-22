using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ICSharpCode.NRefactory.CSharp;

namespace AST_Getter.Helpers
{
    static class CommonHelper
    {
        public static string Get(AstType astType)
        {
            //todo finish
            var type = "";
            if (astType is SimpleType)
            {
                var simpleType = astType as SimpleType;
                type += "simpleType(\"" + simpleType.Identifier + "\",";
                type += CollectionHelper.Get(simpleType.TypeArguments);
            }
            else if (astType is ComposedType)
            {
                //composedType(list[AstNode] arraySpecifiers, bool hasNullableSpecifier, int pointerRank, AstType baseType)
                var composedType = astType as ComposedType;
                var formatter = new FormatHelper("composedType(");
                formatter.AddWithComma(CollectionHelper.Get(composedType.ArraySpecifiers));
                formatter.AddWithComma(composedType.HasNullableSpecifier.ToString().ToLower());
                formatter.AddWithComma(composedType.PointerRank.ToString());
                formatter.Add(Get(composedType.BaseType));

                type += formatter.S;
            }
            else if (astType is MemberType)
            {
                //memberType(bool isDoubleColon, str memberName, AstType Target,  list[AstType] typeArguments)
                var memberType = astType as MemberType;
                var formatter = new FormatHelper("memberType(");
                formatter.AddWithComma(memberType.IsDoubleColon.ToString().ToLower());
                formatter.AddWithQuotesAndComma(memberType.MemberName);
                formatter.AddWithComma(Get(memberType.Target));
                formatter.Add(CollectionHelper.Get(memberType.TypeArguments));

                type += formatter.S;
            }
            else if (astType is PrimitiveType)
            {
                var primitiveType = astType as PrimitiveType;
                type += "primitiveType(\"" + primitiveType.Keyword + "\"";
            }
            else
            {
                type += "typePlaceholder(";
            }

            type += ")";
            return type;
        }

        internal static string Get(Accessor accessor)
        {
            if (accessor.IsNull)
                return "noAccessor()";
                
            return accessor.RascalString;
        }

        internal static string Get<T>(T astNode) where T : AstNode
        {
            if (astNode.IsNull)
                return "astNodePlaceholder()";

            if (astNode is Expression)
                return "expression(" + astNode.RascalString + ")";
            if (astNode is Statement)
                return "statement(" + astNode.RascalString + ")";


            return astNode.RascalString;
        }
    }
}

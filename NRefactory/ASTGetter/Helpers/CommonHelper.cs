using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ICSharpCode.NRefactory.CSharp;
using ICSharpCode.NRefactory.TypeSystem;

namespace AST_Getter.Helpers
{
    static class CommonHelper
    {
        public static string Get(AstType astType, AstNode node)
        {
            //todo finish
            var type = "";
            if (astType is SimpleType)
            {
                var simpleType = astType as SimpleType;

                //try to resolve the node and extract the exactType
                var result = Visitor.resolver.Resolve(node);
                if(!result.IsError && !(result.Type.Kind == TypeKind.Unknown))
                    type += "exactType(\"" + result.Type.FullName + "\"";
                else
                {
                    type += "simpleType(\"" + simpleType.Identifier + "\",";
                    type += CollectionHelper.Get(simpleType.TypeArguments);


                    Console.WriteLine();
                    Console.WriteLine(simpleType.Identifier);
                    Console.WriteLine(type);
                }                
            }
            else if (astType is ComposedType) // voorbeeld: int* p; int[] a;
            {
                //composedType(list[AstNode] arraySpecifiers, bool hasNullableSpecifier, int pointerRank, AstType baseType)
                var composedType = astType as ComposedType;
                var formatter = new FormatHelper("composedType(");
                formatter.AddWithComma(CollectionHelper.Get(composedType.ArraySpecifiers));
                formatter.AddWithComma(composedType.HasNullableSpecifier.ToString().ToLower());
                formatter.AddWithComma(composedType.PointerRank.ToString());
                formatter.Add(Get(composedType.BaseType, node));

                type += formatter.S;
            }
            else if (astType is MemberType) //usings
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
                return "noAccessor()" + LocationHelper.EmptyLocation;
                
            return accessor.RascalString;
        }

        internal static string Get<T>(T astNode) where T : AstNode
        {
            if (astNode.IsNull)
                return "astNodePlaceholder()" + LocationHelper.EmptyLocation;

            if (astNode is Expression)
                return "expression(" + astNode.RascalString + ")" + LocationHelper.Get(astNode);
            if (astNode is Statement)
                return "statement(" + astNode.RascalString + ")" + LocationHelper.Get(astNode);


            return astNode.RascalString;
        }
    }
}

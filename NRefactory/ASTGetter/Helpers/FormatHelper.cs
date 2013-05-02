using System;
using System.Collections.Generic;
using System.Linq;
using AST_Getter.Visitor;
using ICSharpCode.NRefactory.CSharp;
using ICSharpCode.NRefactory.TypeSystem;

namespace AST_Getter.Helpers
{
    public class FormatHelper
    {
        public String S { get; set; }

        public FormatHelper() { }
        public FormatHelper(string s) { S = s; }

        public FormatHelper(string start, object[] attributes, string end, AstNode node)
        {
            S = start;
            foreach (var attribute in attributes)
            {
                string str = HandleAttribute((dynamic)attribute);

                if (attribute == attributes.Last())
                    Add(str);
                else
                    AddWithComma(str);
            }
            Add(end);
            Add(LocationHelper.Get(node));
        }

        string HandleAttribute(string str)
        {
            return "\"" + str + "\"";
        }
        string HandleAttribute(int i)
        {
            return i.ToString();
        }
        string HandleAttribute(bool b)
        {
            return b.ToString().ToLower();
        }
        string HandleAttribute<T>(AstNodeCollection<T> astNodeCollection) where T : AstNode
        {
            return FormatCollection(CollectionHelper.Get(astNodeCollection));
        }
        string HandleAttribute(ClassType _class)
        {
            return _class.ToString().ToLower() + "()";
        }
        string HandleAttribute(EmptyCollection empty)
        {
            return "[]";
        }
        string HandleAttribute(Expression expression)
        { return ExpressionHelper.Get(expression); }
        string HandleAttribute(Statement statement)
        { return StatementHelper.Get(statement); }
        string HandleAttribute(ParameterModifier Enum)
        {
            return EnumHelper.Translate(Enum);
        }
        string HandleAttribute(AstNodeCollection<AstType> types)
        {
            return CollectionHelper.Get(types);
        }
        string HandleAttribute(AstType astType)
        {
            return CommonHelper.Get(astType);
        }
        string HandleAttribute(Accessor accessor)
        { return CommonHelper.Get(accessor); }
        string HandleAttribute(AstNode astNode)
        {
            return CommonHelper.Get(astNode);
        }

        #region EnumTranslation
        string HandleAttribute(Modifiers Enum)
        {
            return EnumHelper.Translate(Enum);
        }
        string HandleAttribute(BinaryOperatorType Enum)
        {
            return EnumHelper.Translate(Enum);
        }
        string HandleAttribute(UnaryOperatorType Enum)
        {
            return EnumHelper.Translate(Enum);
        }
        string HandleAttribute(ConstructorInitializerType Enum)
        {
            return EnumHelper.Translate(Enum);
        }
        string HandleAttribute(QueryOrderingDirection Enum)
        {
            return EnumHelper.Translate(Enum);
        }
        string HandleAttribute(FieldDirection Enum)
        {
            return EnumHelper.Translate(Enum);
        }
        string HandleAttribute(VarianceModifier Enum)
        {
            return EnumHelper.Translate(Enum);
        }
        string HandleAttribute(AssignmentOperatorType Enum)
        { return EnumHelper.Translate(Enum); }
        #endregion EnumTranslation


        private string FormatCollection(IEnumerable<string> ienumerable)
        {
            var str = "";
            var list = ienumerable as IList<string> ?? ienumerable.ToList();
            if (!list.Any())
                str += "[]";
            else
            {
                var local_str = str + "[";
                list.ToList().ForEach(e =>
                {
                    local_str += e + ",";
                });
                local_str = local_str.Trim().TrimEnd(',');
                str = local_str + "]";
            }
            return str;
        }
        

        #region StringExtenders
        public void Add(string s)
        {
            S += s;
        }
        public void AddWithQuotes(string s)
        {
            S += "\"" + s + "\"";
        }
        public void Add(IEnumerable<string> ienumerable)
        {
            var list = ienumerable as IList<string> ?? ienumerable.ToList();
            if (!list.Any())
                S += "[]";
            else
            {
                var local_str = S + "[";
                list.ToList().ForEach(e =>
                    {
                        local_str += e + ",";
                    });
                local_str = local_str.Trim().TrimEnd(',');
                S = local_str + "]";
            }
        }

        public void AddWithComma(string s)
        {
            Add(s);
            Add(",");
        }
        public void AddWithQuotesAndComma(string s)
        {
            AddWithQuotes(s);
            Add(",");
        }
        public void AddWithComma(IEnumerable<string> ienumerable)
        {
            Add(ienumerable);
            Add(",");
        }
    
        internal static string WithQuotes(string s)
        {
            return "\"" + s + "\"";
        }
        #endregion StringExtenders
        
        public override string ToString()
        {
            return S;
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;

namespace AST_Getter.Helpers
{
    public class FormatHelper
    {
        public String S;

        public FormatHelper() { }
        public FormatHelper(string s) { S = s; }
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
                var local_str = S + Environment.NewLine + "[";
                list.ToList().ForEach(e =>
                    {
                        local_str += e + "," + Environment.NewLine;
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
        public void AddLine(string s)
        {
            Add(s);
            Add(Environment.NewLine);
        }

        internal static string WithQuotes(string s)
        {
            return "\"" + s + "\"";
        }


        public override string ToString()
        {
            return S;
        }
    }
}

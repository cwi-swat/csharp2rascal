using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace System
{
    public static class StringListExtensions
    {
        public static List<String> Range(this List<String> list, int from, int to)
        {
            #region validations
            if (from > to) throw new InvalidOperationException("from has to be smaller than to");
            if (to > list.Count) throw new InvalidOperationException("to has to be smaller than list.Count");
            #endregion

            var returnList = new List<String>();
            for (int i = from; i < to; i++)
            {
                returnList.Add(list[i]);
            }

            return returnList;
        }
    }
}

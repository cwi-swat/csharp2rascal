using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    class ForEachCase
    {
        void ForEach()
        {
            var list = new int[] { 1, 2, 3, 4 };
            foreach (var i in list)
            {
                if (i - 5 > 0)
                {
                    var j = i;
                }
            }
        }
    }
}

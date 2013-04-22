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
            var list = Enumerable.Range(1, 10);
            foreach (var i in list)
            {
                if (i - 5 > 0)
                    continue;
            }
        }
    }
}

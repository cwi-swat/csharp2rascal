using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    class SizeOfTypeOfDefaultValueCase
    {
        private void test()
        {
            var a = sizeof(long);
            var b = a.GetType() == typeof(SizeOfTypeOfDefaultValueCase);
            b = default(bool);
        }
    }
}

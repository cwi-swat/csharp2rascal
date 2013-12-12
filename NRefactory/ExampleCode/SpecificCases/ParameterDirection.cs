using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    class ParameterDirection
    {
        public ParameterDirection(ref bool a, out bool b)
        {
            b = a;
            a = !a;
        }

        bool test()
        {
            var a = true;
            bool b = false;

            var c = b;
            var d = a;

            new ParameterDirection(ref a, out b);

            return a && b;
        }
    }
}

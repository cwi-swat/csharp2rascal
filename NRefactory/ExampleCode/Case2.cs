using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode
{
    class Case2
    {
        public Case2()
        {
            var e = 1;
            var a = 2;
            if (a == 2)
            {
                var b = 1;
                b++;
                b = b * b;
                b = b + 5;
            }
            if (a == 1)
            {
                var c = 2;
                c++;
                c += 15;
                c *= 20;
            }
            a = 3;
            var d = a + 4;
        }
    }
}

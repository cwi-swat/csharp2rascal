using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode
{
    class Test
    {
        public Test()
        {
            var a = 1;
            var b = 2;
            if (a == b)
            {
                var c = 1;
                var d = 2;
                c = c + d;
            }
            var e = 1;
            var f = e++;
            var g = 0;
            var h = 2 + f;

        }
    }
}
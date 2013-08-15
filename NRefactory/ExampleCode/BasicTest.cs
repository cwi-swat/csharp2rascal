using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode
{
    class BasicTest
    {
        int field1 = 1;                 //S0.1
        int field2 = 2;                 //S0.2
        public BasicTest()
        {
            var a = 1;                  //S1        No Dep
            var b = 2;                  //S2        No Dep
            if (b == 2)                 //S3        S2
            {
                //field2 = 2;             //S3.1      S3
                var c = 3;
                var d = 1;
                var e = c + d;
            }
            if (a == 1 && b == 2)       //S4        S1, S2
            {
                //field1 = 2;             //S4.1      S4
                var f = 3;
                var g = 1;
                var h = f + g;
            }
        }
    }
}

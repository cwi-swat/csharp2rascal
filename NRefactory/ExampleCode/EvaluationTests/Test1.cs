using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.Evaluation_Tests
{
    public class Test1Class
    {
        int field1 = 1;
        int field2 = 2;
        int field3 = 3;
        public int Test1()
        {
            var a = 1;
            var b = 2;
            if (b == 2)
                field2 = 2;
            if (a == 1 && b == 2)
                field1 = 2;
            var c = field1;
            var d = field2;
            var e = b;
            var f = field1 + field2;
            var g = field3;
            var h = f + g;
            return a + b + c + d + e + f + g + h + field1 + field2 + field3;
        }
    }
}
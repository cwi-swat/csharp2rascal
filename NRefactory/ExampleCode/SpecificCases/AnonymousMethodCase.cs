using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    class AnonymousMethodCase
    {
        void anon()
        {
            int n = 0;
            Action d = delegate() { System.Console.WriteLine("Copy #:{0}{1}{2}{3}{4}{5}", ++n, 1, 2, 3, 4, 5); };

            unsafe
            {
                int* p;
                p++;

            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    public class DoWhileCase
    {
        public void DoWhile()
        {
            var a = 1;
            do
            {
                a++;
                a = 4;
            }
            while (a == 2);
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    class WhileCase
    {
        void While()
        {
            int b = 0;
            bool B = true;
            
            while (B)
            {
                b++;
                if (b == 1)
                    B = false;
            }
        }
    }
}

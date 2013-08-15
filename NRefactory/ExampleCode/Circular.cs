using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode
{
    class Circular
    {
        int counter = 0;

        public Circular()
        {
            counter = One();
        }

        public int One()
        {
            return 1 + MoveTwo();
        }

        public int MoveTwo()
        {
            return One() + counter;
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode
{
    class Indirect
    {
        public Indirect()
        {
            var a = 1;
            var b = 2;
            setField();
            a = 3;
            readField();
            b = 4;
        }

        int _field;
        public void setField()
        {
            _field = 5;
        }
        int readField()
        {
            return _field;
        }
    }
}

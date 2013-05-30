using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode
{
    class Case4
    {
        bool onSale = false;
        public Case4()
        {
            OnSale();
            if (onSale)
            {
                var b = 1;
            }
        }

        private void OnSale()
        {
            onSale = true;
        }
    }
}

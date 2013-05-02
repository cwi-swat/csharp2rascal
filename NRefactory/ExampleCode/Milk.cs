using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Roslyn.Example_source;

namespace ExampleCode
{
    public class Milk : Product, ISellable
    {
        public Milk(string name, string type, int price = 0) : base(name, price)
        {
            const int dag = 1;
            if (type == "halfvol")
                ExpireDays = dag * 5;
            else
                ExpireDays = dag * 3;
        }

        public int ExpireDays;
        public string Type;

        internal Company company;
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Roslyn.Example_source
{
    public class Shopper
    {
        public Shopper(string name)
        {
            this.Name = name;
            this.Credit = 100;
            this.ShoppingCart = new ShoppingCart(this);
        }

        public ShoppingCart ShoppingCart { get; set; }
        public int Credit { get; set; }
        public string Name { get; set; }
    }
}

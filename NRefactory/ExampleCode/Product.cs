using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ExampleCode;

namespace Roslyn.Example_source
{
    public class Product : Item
    {
        public Product(string name, double price)
        {
            var a = 1;
            a += 2;
            Name = name;
            this.Price = price;
        }

        public void OnSale()
        {
            IsOnSale = true;
        }

        public string Name { get; set; }

        public bool IsOnSale = false;

        private double _price;
        public double Price
        {
            get
            {
                var inprop = 2;
                return IsOnSale ? _price * 0.8 : _price;
            }
            set
            {
                _price = value;
            }
        }

    }
}

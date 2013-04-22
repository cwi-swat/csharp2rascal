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
            this.Name = name;
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
                if(IsOnSale)
                    return _price * 0.8;

                return _price;
            }
            set
            {
                _price = value;
            }
        }
     
    }
}

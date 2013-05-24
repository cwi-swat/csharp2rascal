using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ExampleCode;

namespace Example_source
{
    public class Product : Item
    {
        public Product(string name, double price)
        {
            var a = 1;
            a += 2;
            Name = name;
            this.Price = price;

            bool bl = true;
            bl = this.IsOnSale;

            if (IsOnSale ?
                false :
                true)
            {
                //sure, this works
            }

            switch (a == 2 ?
                    3 :
                    4)
            {
                case 3:
                    break;
                //works for switch aswell
            }

            for (int i = a == 2 ?
                    3 :
                    4; i < 1; i++)
            {
                //and in for for
            }
            var b = new int[] {1,2};
            var c = new int[] {3,4};
            foreach (var item in IsOnSale ? b : c)
            {
                //ofcourse foreach cant stay behind
            }
            //while probably works too, etc...

            var p = new Product(IsOnSale ? "b" : "c", 0);
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
                return IsOnSale ? _price * 0.8 : _price;
            }
            set
            {
                _price = value;
            }
        }

    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Example_source
{
    public class ShoppingCart
    {
        public ShoppingCart(Shopper shopper)
        {
            this.Owner = shopper;
            this.Products = new List<Product>
                {
                    new Product("product a", 1.00)
                        {
                            IsOnSale = true
                        },
                    new Product("product b", 2.00)
                };

            int myint = 0;
            TotalProductsAddedToShoppingCarts(total: out myint);
        }

        public Shopper Owner { get; private set; }
        public List<Product> Products
        {
            get
            {
                return _products;
            }
            set
            {
                _totalProductsAddedToShippingCarts++;
                _products = value;
            }
        }
        private List<Product> _products;

        private static int _totalProductsAddedToShippingCarts;
        public static void TotalProductsAddedToShoppingCarts(out int total)
        {
            total = _totalProductsAddedToShippingCarts;
        }

        public static bool AddToShoppingCart(ShoppingCart sc, Product p)
        {
            sc.Products.Add(p);
            return true;
        }
    }
}
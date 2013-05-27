using ExampleCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Example_source
{
    public class TestClass
    {
        internal static string StaticField;
        public string Description { get; set; }
        private string Name;

        public TestClass(string Name)
        {
            // TODO: Complete member initialization
            this.Name = Name;
        }

        internal void DoFunction()
        {
            throw new NotImplementedException();
        }
      
        internal void RefFunction(ref string p, string o)
        {
            throw new NotImplementedException();
        }
        internal static void StaticFunction()
        {
        }
    }
    public class Shopper
    {
        public ShoppingCart shoppingCart;

        private int credit;
        public int Credit;
        public string Name { get; set; }
        public string fieldName;
        public TestClass FieldTestClass;

        public Shopper(TestClass testClass)
        {
            this.Name = testClass.Description;
            this.Credit = 100;

            //invocationExp
            testClass.DoFunction();

            //mem ref
            testClass.Description = this.Name;

            //static invocation
            //TestClass.StaticFunction();

            //assign to invocation
            //depends on testClass -> param
            //           ReturnString -> method
            //           Credit -> property, but last assigned at this.credit=100
            //this.Name = testClass.ReturnString(Credit);

            //ref keyword
            //var mystring = "a";
            //mystring = "b";
            //fieldName = "1";
            //testClass.RefFunction(ref fieldName, "a");
            //this.Name = fieldName;

            //static field
            //TestClass.StaticField = this.Name;

            //afhankelijkheid naar juiste constructor  <--
            //en een calls rel
            this.FieldTestClass = new TestClass(Name);
        }


        String Function(string a)
        {
            return a;
        }
    }
}
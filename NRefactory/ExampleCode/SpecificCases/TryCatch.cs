using System;
using System.Linq;

namespace ExampleCode.SpecificCases
{
    public class TryCatch
    {
        public int _TryCatch()
        {
            var myreturn = 0;
            try
            {
                myreturn = 1;
                throw new Exception("blaa");
            }
            catch (Exception ex)
            {
                myreturn = 2;
                ex = new Exception("error in casting", ex);
                
                throw;
                //this line does not matter for the finally block.
                //even if it is rethrown the finally is executed first before bubbling
            }            

            return myreturn;
        }
    }
}

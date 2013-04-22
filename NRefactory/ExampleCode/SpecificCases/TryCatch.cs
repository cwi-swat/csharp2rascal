using System;

namespace ExampleCode.SpecificCases
{
    class TryCatch
    {
        void _TryCatch()
        {
            object a = "asd";
            try
            {
                a = 1;
            }
            catch (Exception ex)
            {
                ex = new Exception("error in casting", ex);
                throw;
            }
            finally
            {
                a = null;
            }
        }
    }
}

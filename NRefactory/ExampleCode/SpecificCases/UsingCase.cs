using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    class UsingCase : IDisposable
    {
        public void Dispose()
        {
            throw new NotImplementedException();
        }
        
        void Using()
        {
            using (UsingCase Var = new UsingCase(),
                             Dar = new UsingCase())
            {
                var a = 1;
                Var.Using();
            }
        }
    }
}
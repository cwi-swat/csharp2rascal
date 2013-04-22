using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    class LockCase
    {
        readonly object _lock = new object();

        double _vulnerableVariable = 50.00;
        
        void Lock()
        {
            lock (_lock)
            {
                _vulnerableVariable -= 50;
            }
        }
    }
}

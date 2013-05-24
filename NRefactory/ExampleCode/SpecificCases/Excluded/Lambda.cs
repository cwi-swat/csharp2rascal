using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode.SpecificCases
{
    class Lambda
    {
        delegate void MyEventHandler(object sender, EventArgs e);
        event MyEventHandler Event;
        
        public Lambda()
        {
            var variable = 2;

            var l = new List<int>(){1,2,3,4,5};
            l.ForEach(x => variable = x * variable);
            
            Func<int,bool> a = (x => x == variable);

            Event += (sender, e) =>
            {
                variable = 3;
            };
        }
    }
}
using System.Collections.Generic;
using System.Linq;

namespace ExampleCode.SpecificCases
{
    class Linq
    {
        void _Linq()
        {
            var examples = new List<example>();
            var examples2 = new List<example>();

            var a = from l1 in examples
                    orderby l1.lastname
                    where l1.firstname == "a"
                    select l1;

            foreach (var item in from l2 in examples
                                 orderby l2.firstname
                                 select l2)
            {
                
            }

            //todo groupings
            //var groupings = from element in examples
            //                group element by element into groups
            //                select new
            //                {
            //                    Key = groups.Key,
            //                    Count = groups.Count()
            //                };

            
        }
    }

    partial class example
    {
        public string firstname;
        public string lastname;

        public example(string firstname, string lastname)
        {
            this.firstname = firstname;
            this.lastname = lastname;
        }
    }
}
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



            var groupings = from element in examples
                            group element by element into groups
                            select new
                            {
                                Key = groups.Key,
                                Count = groups.Count()
                            };

            var a = from e in examples
                    orderby e.lastname
                    select e;
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
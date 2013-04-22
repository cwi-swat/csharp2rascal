using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Roslyn.Example_source
{
    public class Store
    {
        public Store(string name)
        {
            Name = name;
            Aisles = new List<Aisle>();
        }
        
        public string  Name { get; private set; }
        public List<Aisle> Aisles
        {
            get
            {
                return _aisles;
            }
            set
            {
                _aisles = value;
            }
        }

        private List<Aisle> _aisles;
    }
}

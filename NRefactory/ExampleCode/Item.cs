using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode
{
    public class Item : Object
    {
        public String Description { get; set; }
        int _field = 1,
            _field2 = 3;

        public Item()
        {
            var b = 1;
            b = 3;
            if (b == 2)
                b += 1;
            else
                b += 2;
            
            var cCCCCCCCCCCCCCCCCc = b;

            //var d = 0;
            //switch (b)
            //{
            //    case 0:
            //    case 1:
            //        d += 1;
            //        break;
            //    case 2:
            //        d += 2;
            //        break;
            //    default:
            //        d += 3;
            //        break;
            //}

           
            //cCCCCCCCCCCCCCCCCc += d;

        }

        //public Item()
        //{
        //    var b =2;
        //    b = _field;

        //    if (b == 2)
        //    {
        //        b += 1;

        //        if (b == 1)
        //        {
        //            var f = 2;
        //        }
        //    }
        //}
    }

    public enum ItemType
    {
        Created,
        Existing,
        Deleted
    }
}
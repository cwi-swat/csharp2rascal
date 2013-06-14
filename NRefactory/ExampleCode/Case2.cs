using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExampleCode
{
    class Case2
    {
        int field1 = 1;
        int field2 = 2;

        public Case2()
        {
            var a = 1;                  //S1        No Dep
            var b = 2;                  //S2        No Dep
            if (b == 2)                 //S3        S2
            {
                field2 = 2;             //          S3
            }
            if (a == 1 && b == 2)       //S4        S1, S2
            {
                field1 = 2;             //          S4
            }
            var c = field1;             //S5        S4, field1
            var d = field2;             //S6        S3, field2
            var e = b;                  //S7        S2
            var f = field1 + field2;    //S8        S3,S4,field1,field2
            var g = field3;             //S9        field3
            var h = f + g;              //S10       S8,S9

            _field4 = 4;                //S11       No Dep
            var i = field4();           //S12       S11, indirect

            _field4 = 1;
            setField4();                //S13       No Dep
            var j = field4();           //S14       field4(), _field4, (setField4), S13
            
            var TESTFIELDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD = a;
        }

        int field3 = 3;
        int _field4;

        public bool setField4()
        {
            _field4 = 5;
            return true;
        }
        int field4()
        {
            return _field4; 
        }

        
        //public int Test() 
        //{
        //    var M = 2;
        //    var O = 1;
            
        //    M = 3;
        //    O = 1 + 2;

        //    if (O == 1)
        //    {
        //        var E = M;
        //        O = E;
        //    }

        //    return O;
        //}
        
    }
}

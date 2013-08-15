namespace ExampleProg
{
    class ExampleClass
    {
        public ExampleClass()
        {
            var a = 1;
            var b = 2;
            var c = a + b;
            if (c == 3)
            {
                var d = 1;
                b += d;
            }
            else
            {
                var e = 3;
                a += e;
            }
            var f = 2;
        }
    }
}

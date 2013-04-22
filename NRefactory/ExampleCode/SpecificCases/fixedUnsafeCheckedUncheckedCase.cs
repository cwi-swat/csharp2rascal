namespace ExampleCode.SpecificCases
{
    class Point
    {
        public int x;
        public int y;
    }

    class fixedCase
    {
        static void TestMethod()
        {

            var pt = new Point
            {
                y = checked(1),
                x = unchecked(1)
            };
            
            unsafe
            {
                pt.x = 1;
                
                fixed (int* p = &pt.x)
                {
                    *p = 1;
                }
            }

            

            checked
            {
                pt.y = 1;
            }

            unchecked
            {
                pt = new Point();
            }
        }
    }
}

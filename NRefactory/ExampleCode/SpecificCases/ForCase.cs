namespace ExampleCode.SpecificCases
{
    class ForCase
    {
        void forCase()
        {
            var a = "dont know m";
            for (int m = 1; m < 1; m--)
            {
                for (int i = 0; i < 0; i++)
                {
                    a = "known m + i";
                    m++;
                    if (m == 1)
                    { }
                }
                a = "Know m";
            }

            a = "don't know m+i";

            //int k = 3;
            //int i = 2;
            //for (i = 0, k = 6; i < 6 && k > 0; i+= k, k--)
            //{
            //    i = k * i;
            //}
        }
    }
}
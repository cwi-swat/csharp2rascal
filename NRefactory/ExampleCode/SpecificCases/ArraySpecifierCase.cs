namespace ExampleCode.SpecificCases
{
    class ArraySpecifierCase
    {
        public ArraySpecifierCase()
        {
            var a = 2;

            int[] arr;
            int[] arrInts = new int[5];
            int[, ,] arrDimInts = new int[1, 2, 3]
            {
                { //1
                    { //2
                        1,2,3 //3
                    },
                    { //2
                        1,2,3 //3
                    }
                } 
            };
        }
        
    }
}

namespace ExampleCode.Specific_cases
{
    class SwitchCase
    {
        string Content(int switchOn)
        {
            string variable;

            switch (switchOn)       //switch statement
            {
                                        //switch section
                case 1:                     //case label
                case 2:                     //case label
                    variable = "<3";            //statement
                    break;                      //statement
                                        //switch section

                case 3:
                    variable = "3";
                    break;
                case 4:
                    variable = "4";
                    break;
                default:
                    variable = "0";
                    break;
            }

            return variable;
        }
    }
}

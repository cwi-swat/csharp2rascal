namespace ExampleCode.Specific_cases
{
    class SwitchCase
    {
        string Content(int switchOn)
        {
            switchOn = 2;
            string variable = "a";
            
            if (switchOn == 3)
            {
                variable = "b";
            }

            if (switchOn == 2)
            {
                variable = "c";
            }

            switch (switchOn)       //switch statement
            {
                case 3:
                    variable = "3";
                    break;
                case 4:
                    variable = "4";
                    break;
            }
            
            return variable;
        }
    }
}
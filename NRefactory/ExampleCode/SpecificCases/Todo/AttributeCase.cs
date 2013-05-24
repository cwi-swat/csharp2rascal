using System.Diagnostics;

namespace ExampleCode.SpecificCases
{
    [System.Serializable]
    internal class AttributeCase
    {

        [Conditional("DEBUG"), Conditional("TEST1")]
        private void Method()
        {
        }
    }
}

    



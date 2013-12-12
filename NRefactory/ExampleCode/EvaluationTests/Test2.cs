namespace ExampleCode.EvaluationTests{    public class Test2Class    {public int Test2()
{
    var result1 = 1;
    while (result1 < 100)
        result1 += 15;
    var a = result1 / 2;
    if (a > 50)
        result1 += a;
    else
        result1 -= a;

    var result2 = 1;
    while (result2 < 100)
        result2 += 30;
    var b = result2 / 2;
    if (b < 50)
        result2 += b;
    else
        result2 -= b;
    return result1 + result2;
}}}
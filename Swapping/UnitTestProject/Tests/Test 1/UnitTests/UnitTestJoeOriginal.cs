using Joe;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using UnitTestProject.Tests.Test_1.UnitTests.Original;

namespace UnitTestProject.Tests.Test_1.UnitTests
{
    [TestClass]
    public class UnitTestJoeOriginal
    {
        [TestMethod]
        public void TestJoeOriginal()
        {
            var originalJoe = HelperOriginal.GenerateOriginalJoe();
            Joe.Live.LiveDay(ref originalJoe);

            var compareJoe = HelperOriginal.GenerateOriginalJoe();
            Live.LiveDay(ref compareJoe);
            Assert.IsTrue(HelperOriginal.CompareJoe(originalJoe, compareJoe.IsAlive, compareJoe.Energy, compareJoe.Position, compareJoe.InCarAccident, compareJoe.DaysAlive, compareJoe.Refrigerator.Foods.Length));

            //fridge empty
            originalJoe = HelperOriginal.GenerateOriginalJoe();
            originalJoe.Refrigerator.IsEmpty = true;
            Joe.Live.LiveDay(ref originalJoe);

            compareJoe = HelperOriginal.GenerateOriginalJoe();
            compareJoe.Refrigerator.IsEmpty = true;
            Live.LiveDay(ref compareJoe);
            Assert.IsTrue(HelperOriginal.CompareJoe(originalJoe, compareJoe.IsAlive, compareJoe.Energy, compareJoe.Position, compareJoe.InCarAccident, compareJoe.DaysAlive, compareJoe.Refrigerator.Foods.Length));


            //In deadly accident
            originalJoe = HelperOriginal.GenerateOriginalJoe();
            originalJoe.InCarAccident = "deadly";
            Joe.Live.LiveDay(ref originalJoe);

            compareJoe = HelperOriginal.GenerateOriginalJoe();
            compareJoe.InCarAccident = "deadly";
            Live.LiveDay(ref compareJoe);
            Assert.IsTrue(HelperOriginal.CompareJoe(originalJoe, compareJoe.IsAlive, compareJoe.Energy, compareJoe.Position, compareJoe.InCarAccident, compareJoe.DaysAlive, compareJoe.Refrigerator.Foods.Length));


            //over 9000
            originalJoe = HelperOriginal.GenerateOriginalJoe();
            originalJoe.DaysAlive = 9000;
            Joe.Live.LiveDay(ref originalJoe);

            compareJoe = HelperOriginal.GenerateOriginalJoe();
            compareJoe.DaysAlive = 9000;
            Live.LiveDay(ref compareJoe);
            Assert.IsTrue(HelperOriginal.CompareJoe(originalJoe, compareJoe.IsAlive, compareJoe.Energy, compareJoe.Position, compareJoe.InCarAccident, compareJoe.DaysAlive, compareJoe.Refrigerator.Foods.Length));

            //fridge has enough food
            originalJoe = HelperOriginal.GenerateOriginalJoe();
            originalJoe.Refrigerator.Fill(new[] { new Joe.Food(), new Joe.Food(), new Joe.Food() });
            Joe.Live.LiveDay(ref originalJoe);

            compareJoe = HelperOriginal.GenerateOriginalJoe();
            compareJoe.Refrigerator.Fill(new[] { new Food(), new Food(), new Food() });
            Live.LiveDay(ref compareJoe);
            Assert.IsTrue(HelperOriginal.CompareJoe(originalJoe, compareJoe.IsAlive, compareJoe.Energy, compareJoe.Position, compareJoe.InCarAccident, compareJoe.DaysAlive, compareJoe.Refrigerator.Foods.Length));
        }
    }
}


namespace UnitTestProject.Tests.Test_1.UnitTests.Original
{
    internal static class HelperOriginal
    {
        public static Joe.Person GenerateOriginalJoe()
        {
            return new Joe.Person("joe")
            {
                IsHungry = true,
                IsAlive = true,
                Energy = 100,
                Position = 0,
                InCarAccident = "",
                DaysAlive = 100,
                Refrigerator = new Joe.Refrigerator
                {
                    Foods = new[] { new Joe.Food(), new Joe.Food() }
                },
                Work = new Joe.Work() { Position = 10 },
            };
        }

        public static bool CompareJoe(Joe.Person joe, bool isAlive, int energy, int position, string inCarAccident, int daysAlive, int refrigeratorFoodsCount)
        {
            return joe.IsAlive == isAlive &&
                   joe.Energy == energy &&
                   joe.Position == position &&
                   joe.InCarAccident == inCarAccident &&
                   joe.DaysAlive == daysAlive &&
                   joe.Refrigerator.Foods.Length == refrigeratorFoodsCount;
        }
    }
}
namespace Joe1.Helper
{
    internal static class Helper
    {
        public static Joe1.Person GenerateJoe()
        {
            return new Joe1.Person("joe")
            {
                IsHungry = true,
                IsAlive = true,
                Energy = 100,
                Position = 0,
                InCarAccident = "",
                DaysAlive = 100,
                Refrigerator = new Joe1.Refrigerator
                {
                    Foods = new[] { new Joe1.Food(), new Joe1.Food() }
                },
                Work = new Joe1.Work() { Position = 10 },
            };
        }
    }
}
namespace Joe2.Helper
{
    internal static class Helper
    {
        public static Joe2.Person GenerateJoe()
        {
            return new Joe2.Person("joe")
            {
                IsHungry = true,
                IsAlive = true,
                Energy = 100,
                Position = 0,
                InCarAccident = "",
                DaysAlive = 100,
                Refrigerator = new Joe2.Refrigerator
                {
                    Foods = new[] { new Joe2.Food(), new Joe2.Food() }
                },
                Work = new Joe2.Work() { Position = 10 },
            };
        }
    }
}
namespace Joe3.Helper
{
    internal static class Helper
    {
        public static Joe3.Person GenerateJoe()
        {
            return new Joe3.Person("joe")
            {
                IsHungry = true,
                IsAlive = true,
                Energy = 100,
                Position = 0,
                InCarAccident = "",
                DaysAlive = 100,
                Refrigerator = new Joe3.Refrigerator
                {
                    Foods = new[] { new Joe3.Food(), new Joe3.Food() }
                },
                Work = new Joe3.Work() { Position = 10 },
            };
        }
    }
}
namespace Joe4.Helper
{
    internal static class Helper
    {
        public static Joe4.Person GenerateJoe()
        {
            return new Joe4.Person("joe")
            {
                IsHungry = true,
                IsAlive = true,
                Energy = 100,
                Position = 0,
                InCarAccident = "",
                DaysAlive = 100,
                Refrigerator = new Joe4.Refrigerator
                {
                    Foods = new[] { new Joe4.Food(), new Joe4.Food() }
                },
                Work = new Joe4.Work() { Position = 10 },
            };
        }
    }
}
namespace Joe5.Helper
{
    internal static class Helper
    {
        public static Joe5.Person GenerateJoe()
        {
            return new Joe5.Person("joe")
            {
                IsHungry = true,
                IsAlive = true,
                Energy = 100,
                Position = 0,
                InCarAccident = "",
                DaysAlive = 100,
                Refrigerator = new Joe5.Refrigerator
                {
                    Foods = new[] { new Joe5.Food(), new Joe5.Food() }
                },
                Work = new Joe5.Work() { Position = 10 },
            };
        }

    }
}

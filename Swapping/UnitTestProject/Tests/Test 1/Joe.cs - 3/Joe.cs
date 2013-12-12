namespace Joe3
{
    using System.Threading;
    using System.Linq;
    using System;
    #region Model
    class Person
    {
        private string p;

        public Person(string p)
        {
        }
        public Work Work { get; set; }
        public Refrigerator Refrigerator { get; set; }
        public Car Car { get; set; }
        public Home Home { get; set; }

        internal void Eat(object food)
        {
            Energy += 5;
        }

        public bool IsAlive { get; set; }

        public bool IsSleeping { get; set; }

        public bool IsHungry { get; set; }

        internal Food[] DoGroceries(Supermarket supermarket)
        {
            return new Food[2];
        }

        public bool IsTired { get; set; }

        public int SleptForHours = 0;
        internal void SleepForHour()
        {
            SleptForHours += 1;
        }

        public int Energy { get; set; }

        internal void Drive(Car car, Work work)
        {
            Energy -= 15;
            Position += 1;
        }
        public int DaysAlive { get; set; }

        public bool Driving { get; set; }

        internal void DoWork(Work work)
        {
            Energy -= 50;
        }
        
        internal void CallMechanic()
        {
        }

        internal string InCarAccident
        {
            get;
            set;
        }

        public int Position { get; set; }
    }
    class Refrigerator
    {
        public Food[] Foods;
        public bool IsEmpty { get; set; }
        internal Food[] GetFavoriteFood(Person joe)
        {
            return new[] { Foods[1], Foods[2] };
        }
        internal void Fill(Food[] list)
        {
            Foods = list;
        }
    }
    class Food
    {
    }
    class Supermarket
    {
    }
    class Work
    {
        internal bool HasToGoToWork(Person joe)
        {
            return true;
        }
        public int Position { get; set; }
    }
    class Car
    {
    }
    class Home { }
    #endregion
    class Live
    {

public static void LiveDay(ref Person joe)
{
    var isAlive = joe.IsAlive;
    
    var work = joe.Work;
    if ( work.HasToGoToWork(joe) ) {
        var car = joe.Car;
        joe.Driving = joe.Position != work.Position;
        while ( joe.Driving ) {
            joe.Drive(car, work);
            joe.Driving = joe.Position != work.Position;
            var accident = joe.InCarAccident;
            if ( accident == "deadly" ) {
                isAlive = false;
                joe.Driving = false;
            }
        }
        if(joe.IsAlive)
            joe.DoWork(work);
    }
    if ( isAlive ) {
        joe.DaysAlive += 1;
        if ( joe.DaysAlive > 9000 )
            isAlive = false;
    }
    joe.IsAlive = isAlive;

    if ( joe.IsHungry ) {
        var refrigerator = joe.Refrigerator;
        try {
            var foods = refrigerator.GetFavoriteFood(joe);
            foreach ( var food in foods ) {
                joe.Eat(food);
            }
        }
        catch ( Exception ex ) {
            if ( refrigerator.IsEmpty ) {
                refrigerator.Fill(joe.DoGroceries(new Supermarket()));
            }
            else //joe is no expert
                joe.CallMechanic();
        }
    }

    while ( joe.SleptForHours <= 8) {
        joe.SleepForHour();
    }
}
//joe.IsAlive
//joe.Energy
//joe.Position
//joe.InCarAccident
//joe.DaysAlive
//joe.Refrigetator.Foods
}
}

using System;
using System.Collections.Generic;
using System.Threading;
namespace ExampleCode.EvaluationTests
{
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
        }

        public bool IsAlive { get; set; }

        public bool IsSleeping { get; set; }

        public bool IsHungry { get; set; }

        internal Food[] DoGroceries(Supermarket supermarket)
        {
            return new Food[1];
        }

        public bool IsTired { get; set; }

        internal bool Sleep()
        {
            Energy += 10;
            return Energy >= 100;
        }

        public int Energy { get; set; }

        internal void Drive(Car car, Work work)
        {
        }
        public delegate void CarAccidentEventHandler(object sender, string accident);
        public event CarAccidentEventHandler OnCarAccident;

        public int DaysAlive { get; set; }

        internal void Die()
        {
        }

        public bool Driving { get; set; }

        internal void DoWork(Work work)
        {
        }

        internal void Drive(Car car, Home home)
        {
        }

        internal void CallMechanic()
        {
        }

        internal string InCarAccident()
        {
            return "deadly";
        }
    }
    class Refrigerator
    {

        internal Food[] GetFavoriteFood(Person joe)
        {
            return new Food[1];
        }

        public static string IsEmpty;


        internal void Fill(Food[] list)
        {
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
    }
    class Car
    {

    }
    class Home { }
    #endregion
    class Test3
    {
        public void DoLife(Person joe)
        {
            while ( joe.IsSleeping )
            {
                Thread.Sleep(10);
                joe.IsSleeping = joe.Sleep();
            }

            if ( joe.IsHungry )
            {

            }

            var work = joe.Work;
            if ( work.HasToGoToWork(joe) )
            {

            }
            if ( joe.Energy <= 0 )
            {

            }
        }
    }
}
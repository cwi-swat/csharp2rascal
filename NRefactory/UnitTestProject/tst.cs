//namespace UnitTestProject {class tst{public static void LiveDay(ref Person joe)
//{
//    var isAlive = joe.IsAlive;

//    while ( joe.SleptForHours <= 8 ) {
//        joe.SleepForHour();
//    }

//    if ( joe.IsHungry ) {
//        var refrigerator = joe.Refrigerator;
//        try {
//            var foods = refrigerator.GetFavoriteFood(joe);
//            foreach ( var food in foods ) {
//                joe.Eat(food);
//            }
//        }
//        catch ( Exception ex ) {
//            if ( refrigerator.IsEmpty )
//                refrigerator.Fill(joe.DoGroceries(new Supermarket()));
//            else //joe is no expert
//                joe.CallMechanic();
//        }
//    }

//    var work = joe.Work;
//    if ( work.HasToGoToWork(joe) ) {
//        var car = joe.Car;
//        joe.Driving = joe.Position != work.Position;
//        while ( joe.Driving ) {
//            joe.Drive(car, work);
//            joe.Driving = joe.Position != work.Position;
//            var accident = joe.InCarAccident;
//            if ( accident == "deadly" ) {
//                isAlive = false;
//                joe.Driving = false;
//            }
//        }
//        if ( joe.IsAlive )
//            joe.DoWork(work);
//    }
//    if ( isAlive ) {
//        joe.DaysAlive += 1;
//        if ( joe.DaysAlive > 9000 )
//            isAlive = false;
//    }
//    joe.IsAlive = isAlive;
//}}}
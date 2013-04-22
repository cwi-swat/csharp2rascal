using System;

namespace ExampleCode.SpecificCases
{
    class EventCase
    {
        void EventCase_Event(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }


        delegate void MyEventHandler(object sender, EventArgs e);
        delegate String MySecondEventHandler(object sender, EventArgs e);
        delegate void MyThirdEventHandler<in T>(object sender, T e);
        //todo contravariant testen

        event MyEventHandler Event;
        event MySecondEventHandler Event2;
        event MyThirdEventHandler<String> Event3;

        private EventHandler _onDraw;
        event EventHandler OnDraw
        {
            add
            {
                _onDraw += value;
            }
            remove
            {
                _onDraw -= value;
            }
        }

        public EventCase()
        {
            this.Event += EventCase_Event;
            this.Event2 += EventCase_Event2;
            this.Event3 += EventCase_Event3;
        }


        String EventCase_Event2(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }

        void EventCase_Event3(object sender, string e)
        {
            throw new NotImplementedException();
        }
    }
}

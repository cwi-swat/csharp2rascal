module example

data myData = ExampleNode(str name);

public void function(myData d)
{
    visit(d)
    {
    	case e:ExampleNode: 	;
    }
}
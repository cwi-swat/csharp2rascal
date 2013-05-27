module example

import IO;

data myData = ExampleNode(str name);

public void main()
{
	int i = 1;
	myData d = ExampleNode("1");
	
	visit(d)
	{
		case i:ExampleNode(_): println("will not execute");
	}
}
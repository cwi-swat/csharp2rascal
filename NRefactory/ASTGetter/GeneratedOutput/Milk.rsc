[cSharpFile("C:\\Uitvoering\\Workspace\\git\\csharp2rascal\\NRefactory\\ExampleCode\\Milk.cs",[
usingDeclaration("System"),
usingDeclaration("System.Collections.Generic"),
usingDeclaration("System.Linq"),
usingDeclaration("System.Text"),
usingDeclaration("System.Threading.Tasks"),
usingDeclaration("Roslyn.Example_source"),
namespaceDeclaration("ExampleCode","ExampleCode",[],
[attributedNode(typeDeclaration("Milk",[],[simpleType("Product",[]),simpleType("ISellable",[]),],class(),[],
[constructorDeclaration("Milk",[],blockStatementPlaceholder(
[variableDeclarationStatement([modifiersConst(),],
[variableInitializer("dag",primitiveExpression(1))],primitiveType("int")),
ifElseStatement(binaryOperatorExpression(identifierExpression("type",[]),equality(),primitiveExpression("halfvol"),),expressionStatement(assignmentExpression(identifierExpression("ExpireDays",[]),assignmentOperatorAssign(),binaryOperatorExpression(identifierExpression("dag",[]),multiply(),primitiveExpression(3),),)
),expressionStatement(assignmentExpression(identifierExpression("ExpireDays",[]),assignmentOperatorAssign(),binaryOperatorExpression(identifierExpression("dag",[]),multiply(),primitiveExpression(5),),)
),)]),constructorInitializer(
[identifierExpression("name",[]),
identifierExpression("price",[])],base())
,[],[modifiersPublic(),],
[parameterDeclaration("name",[],expressionPlaceholder(),parameterModifierNone())
,
parameterDeclaration("type",[],expressionPlaceholder(),parameterModifierNone())
,
parameterDeclaration("price",[],primitiveExpression(0),parameterModifierNone())
],)
,
memberDeclaration(fieldDeclaration("ExpireDays",[],[],[modifiersPublic(),],
[variableInitializer("ExpireDays",emptyExpression())],primitiveType("int")))
,
memberDeclaration(fieldDeclaration("Type",[],[],[modifiersPublic(),],
[variableInitializer("Type",emptyExpression())],primitiveType("string")))
,
memberDeclaration(fieldDeclaration("company",[],[],[modifiersInternal(),],
[variableInitializer("company",emptyExpression())],simpleType("Company",[])))
],[],[modifiersPublic(),],[],))
])
])]
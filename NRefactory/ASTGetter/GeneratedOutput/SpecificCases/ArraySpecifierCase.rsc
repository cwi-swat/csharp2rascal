[cSharpFile("C:\\Uitvoering\\Workspace\\git\\csharp2rascal\\NRefactory\\ExampleCode\\SpecificCases\\ArraySpecifierCase.cs",[
namespaceDeclaration("SpecificCases","ExampleCode.SpecificCases",[],
[attributedNode(typeDeclaration("ArraySpecifierCase",[],[],class(),[],
[memberDeclaration(fieldDeclaration("arr",[],[],[modifiersNone(),],
[variableInitializer("arr",emptyExpression())],composedType(
[arraySpecifier(1)],false,0,primitiveType("int"))))
,
memberDeclaration(fieldDeclaration("arrInts",[],[],[modifiersNone(),],
[variableInitializer("arrInts",arrayCreateExpression([],
[primitiveExpression(5)],emptyExpression()))],composedType(
[arraySpecifier(1)],false,0,primitiveType("int"))))
,
memberDeclaration(fieldDeclaration("arrDimInts",[],[],[modifiersNone(),],
[variableInitializer("arrDimInts",arrayCreateExpression([],
[primitiveExpression(1),
primitiveExpression(2),
primitiveExpression(3)],arrayInitializerExpression(
[arrayInitializerExpression(
[arrayInitializerExpression(
[primitiveExpression(1),
primitiveExpression(2),
primitiveExpression(3)]),
arrayInitializerExpression(
[primitiveExpression(1),
primitiveExpression(2),
primitiveExpression(3)])])])))],composedType(
[arraySpecifier(3)],false,0,primitiveType("int"))))
],[],[modifiersNone(),],[],))
])
])]
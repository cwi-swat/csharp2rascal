[cSharpFile("C:\\Uitvoering\\Workspace\\git\\csharp2rascal\\NRefactory\\ExampleCode\\Store.cs",[
usingDeclaration("System"),
usingDeclaration("System.Collections.Generic"),
usingDeclaration("System.Linq"),
usingDeclaration("System.Text"),
usingDeclaration("System.Threading.Tasks"),
namespaceDeclaration("Example_source","Roslyn.Example_source",[],
[attributedNode(typeDeclaration("Store",[],[],class(),[],
[constructorDeclaration("Store",[],blockStatementPlaceholder(
[expressionStatement(assignmentExpression(identifierExpression("Name",[]),assignmentOperatorAssign(),identifierExpression("name",[]),)
),
expressionStatement(assignmentExpression(identifierExpression("Aisles",[]),assignmentOperatorAssign(),objectCreateExpression([],emptyExpression(),simpleType("List",[simpleType("Aisle",[]),])),)
)]),astNodePlaceholder(),[],[modifiersPublic(),],
[parameterDeclaration("name",[],expressionPlaceholder(),parameterModifierNone())
],)
,
memberDeclaration(propertyDeclaration("Name",[],accessor([],emptyStatement(),[],[modifiersNone(),],)
,[],[modifiersPublic(),],accessor([],emptyStatement(),[],[modifiersPrivate(),],)
,primitiveType("string")))
,
memberDeclaration(propertyDeclaration("Aisles",[],accessor([],blockStatementPlaceholder(
[returnStatement(identifierExpression("_aisles",[]))]),[],[modifiersNone(),],)
,[],[modifiersPublic(),],accessor([],blockStatementPlaceholder(
[expressionStatement(assignmentExpression(identifierExpression("_aisles",[]),assignmentOperatorAssign(),identifierExpression("value",[]),)
)]),[],[modifiersNone(),],)
,simpleType("List",[simpleType("Aisle",[]),])))
,
memberDeclaration(fieldDeclaration("_aisles",[],[],[modifiersPrivate(),],
[variableInitializer("_aisles",emptyExpression())],simpleType("List",[simpleType("Aisle",[]),])))
],[],[modifiersPublic(),],[],))
])
])]
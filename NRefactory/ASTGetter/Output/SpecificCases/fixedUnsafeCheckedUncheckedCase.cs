[cSharpFile("SpecificCases\fixedUnsafeCheckedUncheckedCase.cs",[
namespaceDeclaration("SpecificCases","ExampleCode.SpecificCases",[],
[attributedNode(typeDeclaration("Point",[],[],class(),[],
[memberDeclaration(fieldDeclaration("x",[],[],[modifiersPublic(),],[],primitiveType("int"),))
,
memberDeclaration(fieldDeclaration("y",[],[],[modifiersPublic(),],[],primitiveType("int"),))
,
],[],[modifiersNone(),],[],))
,
attributedNode(typeDeclaration("fixedCase",[],[],class(),[],
[memberDeclaration(methodDeclaration("TestMethod",[],blockStatementPlaceholder(
[variableDeclarationStatement([modifiersNone(),],
[variableInitializer("pt",objectCreateExpression([],emptyExpression(),simpleType("Point",[]),)),
],simpleType("var",[]),),
unsafeStatement(blockStatementPlaceholder(
[expressionStatement(assignmentExpression(memberReferenceExpression("x",identifierExpression("pt",[]),[]),assignmentOperatorAssign(),primitiveExpression(1),)
),
fixedStatement(blockStatementPlaceholder(
[expressionStatement(assignmentExpression(unaryOperatorExpression(identifierExpression("p",[]),dereference()),assignmentOperatorAssign(),primitiveExpression(1),)
),
]),
[variableInitializer("p",unaryOperatorExpression(memberReferenceExpression("x",identifierExpression("pt",[]),[]),addressOf())),
]),
])),
checkedStatement(blockStatementPlaceholder(
[expressionStatement(assignmentExpression(memberReferenceExpression("y",identifierExpression("pt",[]),[]),assignmentOperatorAssign(),primitiveExpression(1),)
),
])),
uncheckedStatement(blockStatementPlaceholder(
[expressionStatement(assignmentExpression(identifierExpression("pt",[]),assignmentOperatorAssign(),objectCreateExpression([],emptyExpression(),simpleType("Point",[]),),)
),
])),
]),[],false,[],[modifiersStatic(),],[],[],primitiveType("void"),))
,
],[],[modifiersNone(),],[],))
,
])
])]
[cSharpFile("SpecificCases\linq.cs",[
usingDeclaration("System.Collections.Generic"),
usingDeclaration("System.Linq"),
namespaceDeclaration("SpecificCases","ExampleCode.SpecificCases",[],
[attributedNode(typeDeclaration("Linq",[],[],class(),[],
[memberDeclaration(methodDeclaration("_Linq",[],blockStatementPlaceholder(
[variableDeclarationStatement([modifiersNone(),],
[variableInitializer("examples",objectCreateExpression([],emptyExpression(),simpleType("List",[simpleType("example",[]),]),)),
],simpleType("var",[]),),
variableDeclarationStatement([modifiersNone(),],
[variableInitializer("examples2",objectCreateExpression([],emptyExpression(),simpleType("List",[simpleType("example",[]),]),)),
],simpleType("var",[]),),
variableDeclarationStatement([modifiersNone(),],
[variableInitializer("groupings",queryExpression(
[queryContinuationClause("groups",queryExpression(
[queryFromClause(identifierExpression("examples",[]),"element"),
queryGroupClause(identifierExpression("element",[]),emptyExpression()),
])),
querySelectClause(anonymousTypeCreateExpression(
[namedExpression(memberReferenceExpression("Key",identifierExpression("groups",[]),[]),"Key"),
namedExpression(invocationExpression([],memberReferenceExpression("Count",identifierExpression("groups",[]),[])),"Count"),
])),
])),
],simpleType("var",[]),),
variableDeclarationStatement([modifiersNone(),],
[variableInitializer("a",queryExpression(
[queryFromClause(identifierExpression("examples",[]),"e"),
queryOrderClause(
[queryOrdering(queryOrderingDirectionNone(),memberReferenceExpression("lastname",identifierExpression("e",[]),[])),
]),
querySelectClause(identifierExpression("e",[])),
])),
],simpleType("var",[]),),
]),[],false,[],[modifiersNone(),],[],[]))
,
],[],[modifiersNone(),],[],))
,
attributedNode(typeDeclaration("example",[],[],class(),[],
[memberDeclaration(fieldDeclaration("firstname",[],[],[modifiersPublic(),],[],primitiveType("string"),))
,
memberDeclaration(fieldDeclaration("lastname",[],[],[modifiersPublic(),],[],primitiveType("string"),))
,
constructorDeclaration("example",[],blockStatementPlaceholder(
[expressionStatement(assignmentExpression(memberReferenceExpression("firstname",thisReferenceExpression(),[]),assignmentOperatorAssign(),identifierExpression("firstname",[]),)
),
expressionStatement(assignmentExpression(memberReferenceExpression("lastname",thisReferenceExpression(),[]),assignmentOperatorAssign(),identifierExpression("lastname",[]),)
),
]),astNodePlaceholder(),[],[modifiersPublic(),],
[parameterDeclaration("firstname",[],expressionPlaceholder(),parameterModifierNone())
,
parameterDeclaration("lastname",[],expressionPlaceholder(),parameterModifierNone())
,
],)
,
],[],[modifiersPartial(),],[],))
,
])
])]
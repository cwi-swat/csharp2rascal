[cSharpFile("C:\\Uitvoering\\Workspace\\git\\csharp2rascal\\NRefactory\\ExampleCode\\ShoppingCart.cs",[usingDeclaration("System"),usingDeclaration("System.Collections.Generic"),usingDeclaration("System.Linq"),usingDeclaration("System.Text"),usingDeclaration("System.Threading.Tasks"),namespaceDeclaration("Example_source","Example_source",[],[attributedNode(typeDeclaration("ShoppingCart",[],[],class(),[],[constructorDeclaration("ShoppingCart",[],blockStatement([expressionStatement(assignmentExpression(memberReferenceExpression("Owner",thisReferenceExpression(),[]),assignmentOperatorAssign(),identifierExpression("shopper",[],exactType("Example_source.Shopper")))),expressionStatement(assignmentExpression(memberReferenceExpression("Products",thisReferenceExpression(),[]),assignmentOperatorAssign(),objectCreateExpression([],arrayInitializerExpression([arrayInitializerExpression([objectCreateExpression([primitiveExpression("product a"),primitiveExpression(1)],arrayInitializerExpression([namedExpression(primitiveExpression(true),"IsOnSale")]),exactType("Example_source.Product"))]),arrayInitializerExpression([objectCreateExpression([primitiveExpression("product b"),primitiveExpression(2)],emptyExpression(),exactType("Example_source.Product"))])]),simpleType("List",[exactType("Example_source.Product"),])))),variableDeclarationStatement([modifiersNone(),],[variableInitializer("myint",primitiveExpression(0))],primitiveType("int")),expressionStatement(invocationExpression([namedArgumentExpression(directionExpression(identifierExpression("myint",[],typePlaceholder()),fieldDirectionOut()),"total")],identifierExpression("TotalProductsAddedToShoppingCarts",[],typePlaceholder())))]),astNodePlaceholder(),[],[modifiersPublic(),],[parameterDeclaration("shopper",[],emptyExpression(),parameterModifierNone(),exactType("Example_source.Shopper"))]),memberDeclaration(propertyDeclaration("Owner",[],accessor([],emptyStatement(),[],[modifiersNone(),]),[],[modifiersPublic(),],accessor([],emptyStatement(),[],[modifiersPrivate(),]),exactType("Example_source.Shopper"))),memberDeclaration(propertyDeclaration("Products",[],accessor([],blockStatement([returnStatement(identifierExpression("_products",[],typePlaceholder()))]),[],[modifiersNone(),]),[],[modifiersPublic(),],accessor([],blockStatement([expressionStatement(unaryOperatorExpression(identifierExpression("_totalProductsAddedToShippingCarts",[],typePlaceholder()),postIncrement())),expressionStatement(assignmentExpression(identifierExpression("_products",[],typePlaceholder()),assignmentOperatorAssign(),identifierExpression("value",[],typePlaceholder())))]),[],[modifiersNone(),]),simpleType("List",[exactType("Example_source.Product"),]))),memberDeclaration(fieldDeclaration("_products",[],[],[modifiersPrivate(),],[variableInitializer("_products",emptyExpression())],simpleType("List",[exactType("Example_source.Product"),]))),memberDeclaration(fieldDeclaration("_totalProductsAddedToShippingCarts",[],[],[modifiersPrivate(),modifiersStatic(),],[variableInitializer("_totalProductsAddedToShippingCarts",emptyExpression())],primitiveType("int"))),memberDeclaration(methodDeclaration("TotalProductsAddedToShoppingCarts",[],blockStatement([expressionStatement(assignmentExpression(identifierExpression("total",[],typePlaceholder()),assignmentOperatorAssign(),identifierExpression("_totalProductsAddedToShippingCarts",[],typePlaceholder())))]),[],false,[],[modifiersPublic(),modifiersStatic(),],[parameterDeclaration("total",[],emptyExpression(),parameterModifierOut(),primitiveType("int"))],[],primitiveType("void"))),memberDeclaration(methodDeclaration("AddToShoppingCart",[],blockStatement([expressionStatement(invocationExpression([identifierExpression("p",[],exactType("Example_source.Product"))],memberReferenceExpression("Add",memberReferenceExpression("Products",identifierExpression("sc",[],exactType("Example_source.ShoppingCart")),[]),[]))),returnStatement(primitiveExpression(true))]),[],false,[],[modifiersPublic(),modifiersStatic(),],[parameterDeclaration("sc",[],emptyExpression(),parameterModifierNone(),exactType("Example_source.ShoppingCart")),parameterDeclaration("p",[],emptyExpression(),parameterModifierNone(),exactType("Example_source.Product"))],[],primitiveType("bool")))],[],[modifiersPublic(),],[]))]),])]
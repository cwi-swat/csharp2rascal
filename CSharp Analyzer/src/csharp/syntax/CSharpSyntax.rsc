module csharp::syntax::CSharpSyntax

public alias CSharpProject = list[CSharpFile];

data CSharpFile = 
	cSharpFile(str filename, list[AstNode]);

data AstNode = 
	 	comment(Comment commentType, str content, bool startsLine)
  |  	namespaceDeclaration(str name, str fullName, list[AstNode] identifiers, list[AstNode] members)
  |  	constraint(list[AstType] baseTypes, AstType typeParameter) //Edit: typeparameter is AstNode geworden van str
  |  	attribute(list[Expression] arguments, AstType \type) //EDIT: type toegevoegd
  |  	attributeSection(str attributeTarget, list[AstNode] attributes) //EDIT: AttributeType naar str
  |  cSharpModifierToken(list[Modifiers] allModifiers, list[Modifiers] modifier)
  |  	cSharpTokenNode()
  |  variablePlaceholder(str name, Expression initializer)
  |  	usingDeclaration(str namespace)
  |  	parameterDeclaration(str name, list[AstNode] attributes, Expression defaultExpression, ParameterModifier parameterModifier)
  |  	switchSection(list[AstNode] caseLabels, list[Statement] statements)
  |  usingAliasDeclaration(str \alias)
  |  typeParameterDeclaration(str name, VarianceModifier variance)
  |  	catchClause(Statement body, str variableName)
  |  	identifier(str name)
  |  	constructorInitializer(list[Expression] arguments, ConstructorInitializer constructorInitializerType)
  |  	variableInitializer(str name, Expression initializer)
  |  arraySpecifier(int dimensions)
  |  	caseLabel(Expression expression)
  |  	statement(Statement nodeStatement)
  |  	astType(AstType nodeAstType)
  |  	attributedNode(AttributedNode nodeAttributedNode)
  |  	expression(Expression nodeExpression)
  |  	queryClause(QueryClause nodeQueryClause)
  |  	queryOrdering(QueryOrderingDirection direction, Expression expression)
  |  	astNodePlaceholder();   //EDIT: nieuw

data Expression = 
	 	lambdaExpression(AstNode body, list[AstNode] parameters)
  |  conditionalExpression(Expression condition, Expression falseExpression, Expression trueExpression)
  |  	binaryOperatorExpression(Expression left, BinaryOperator operator, Expression right)
  |  	directionExpression(Expression expression, FieldDirection fieldDirection)
  |  castExpression(Expression expression)
  |  indexerExpression(list[Expression] arguments, Expression target)
  |  	parenthesizedExpression(Expression expression)
  |  	baseReferenceExpression()
  |  sizeOfExpression()
  |  arrayCreateExpression(list[AstNode] additionalArraySpecifiers, list[Expression] arguments, Expression initializer)
  |  	unaryOperatorExpression(Expression expression, UnaryOperator operatorU)
  |  asExpression(Expression expression)
  |  typeReferenceExpression(AstType \type) //EDIT: type toegevoegd
  |  typeOfExpression()
  |  defaultValueExpression()
  |  anonymousMethodExpression(Statement bodyS, bool hasParameterList, list[AstNode] parameters)
  |	 	anonymousTypeCreateExpression(list[Expression] Initializers)
  |  uncheckedExpression(Expression expression)
  |  isExpression(Expression expression)
  |  	identifierExpression(str identifier, list[AstType] typeArguments)
  |  checkedExpression(Expression expression)
  |  	primitiveExpression(value \value)
  |  	expressionPlaceholder()
  |  	objectCreateExpression(list[Expression] arguments, Expression initializer, AstType \type) //EDIT:  type toegevoegd
  |  	namedArgumentExpression(Expression expression, str name)
  |  	namedExpression(Expression expression, str name)
  |  argListExpression(list[Expression] arguments, bool isAccess)
  |  	memberReferenceExpression(str memberName, Expression target, list[AstType] typeArguments)
  |  	invocationExpression(list[Expression] arguments, Expression target)
  |  pointerReferenceExpression(str memberName, Expression target, list[AstType] typeArguments)
  |  	assignmentExpression(Expression left, AssignmentOperator operatorA, Expression right)
  |  	thisReferenceExpression()
  |  stackAllocExpression(Expression countExpression)
  |  arrayInitializerExpression(list[Expression] elements)
  |  	queryExpression(list[QueryClause] clauses)
  |  	emptyExpression()  //EDIT: nieuw, aangemaakt voor objectCreateExpression, initializer is optioneel.
  |  	null(); 			//EDIT: toegevoegd

data MemberDeclaration = 
 	 indexerDeclaration(str name, list[AstNode] attributes, AttributedNode getter, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters, AttributedNode setter)
  | 	methodDeclaration(str name, list[AstNode] attributes, Statement body, list[AstNode] constraints, bool isExtensionMethod, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters, list[AstNode] typeParameters, AstType \type) //EDIT: type toegevoegd
  |  operatorDeclaration(str name, list[AstNode] attributes, Statement body, list[AstNode] modifierTokens, list[Modifiers] modifiers, Operator operatorType, list[AstNode] parameters)
  |  	propertyDeclaration(str name, list[AstNode] attributes, AttributedNode getter, list[AstNode] modifierTokens, list[Modifiers] modifiers, AttributedNode setter, AstType \type) //EDIT: type toegevoegd
  |  customEventDeclaration(str name, AttributedNode addAccessor, list[AstNode] attributes, list[AstNode] modifierTokens, list[Modifiers] modifiers, AttributedNode removeAccessor)
  |  	fieldDeclaration(str name, list[AstNode] attributes, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] variables, AstType \type)  //EDIT: type toegevoegd
  |  	eventDeclaration(str name, list[AstNode] attributes, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] variables, AstType \type); //EDIT: type toegevoegd

data AstType = 
		simpleType(str identifier, list[AstType] typeArguments)
  |  composedType(list[AstNode] arraySpecifiers, bool hasNullableSpecifier, int pointerRank)
  |  	typePlaceholder()
  |  	memberType(bool isDoubleColon, str memberName, AstType Target,  list[AstType] typeArguments) //EDIT: Target toegevoegd
  |  	primitiveType(str keyword);

data Statement = 
		returnStatement(Expression expression)
  |  	whileStatement(Expression condition, Statement embeddedStatement)
  |  	blockStatementPlaceholder(list[Statement] statements)
  |  	switchStatement(Expression expression, list[AstNode] switchSections)
  |  	ifElseStatement(Expression condition, Statement falseStatement, Statement trueStatement)
  |  	expressionStatement(Expression expression)
  |  	variableDeclarationStatement(list[Modifiers] modifiers, list[AstNode] variables, AstType \type) // EDIT: type toegevoegd
  |  	breakStatement()
  |  	tryCatchStatement(list[AstNode] catchClauses, Statement finallyBlock, Statement tryBlock)
  |  	usingStatement(Statement embeddedStatement, AstNode resourceAcquisition)
  |  	throwStatement(Expression expression)
  |  	doWhileStatement(Expression condition, Statement embeddedStatement)
  |  	continueStatement()
  |  	statementPlaceholder()
  |  	forStatement(Expression condition, Statement embeddedStatement, list[Statement] initializers, list[Statement] iterators)
  |  	foreachStatement(Statement embeddedStatement, Expression inExpression, str variableName)
  |  	lockStatement(Statement embeddedStatement, Expression expression)
  |  	blockStatement(list[Statement] statements)
  |  	emptyStatement()
  |  	yieldBreakStatement()
  |  	yieldStatement(Expression expression)
  |  	unsafeStatement(Statement body)
  |  	fixedStatement(Statement embeddedStatement, list[AstNode] variables)
  |  	uncheckedStatement(Statement body)
  |  	checkedStatement(Statement body)
  //wont do goto's:
  |  labelStatement(str label)
  |  gotoDefaultStatement()
  |  gotoCaseStatement(Expression labelExpression)
  |  gotoStatement(str label);





/////////////////////////////////////////////////
//////////////      Done      ///////////////////    
/////////////////////////////////////////////////

data AttributedNode = 
	 	enumMemberDeclaration(str name, list[AstNode] attributes, Expression initializer, list[AstNode] modifierTokens, list[Modifiers] modifiers)
  |  	accessor(list[AstNode] attributes, Statement body, list[AstNode] modifierTokens, list[Modifiers] modifiers)
  |  	noAccessor() //EDIT toegevoegd, beide accessors zijn niet verplicht
  |  	delegateDeclaration(str name, list[AstNode] attributes, list[AstNode] constraints, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters, list[AstNode] typeParameters)
  |  	destructorDeclaration(str name, list[AstNode] attributes, Statement body, list[AstNode] modifierTokens, list[Modifiers] modifiers)
  |  	typeDeclaration(str name, list[AstNode] attributes, list[AstType] baseTypes, Class classType, list[AstNode] constraints, list[AttributedNode] members, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] typeParameters)
  |  	constructorDeclaration(str name, list[AstNode] attributes, Statement body, AstNode initializerA, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters)
  |  	memberDeclaration(MemberDeclaration nodeMemberDeclaration);

//done
data VarianceModifier = invariant()
  |  covariant()
  |  contravariant();
  
//done
data FieldDirection = fieldDirectionNone()
  |  fieldDirectionRef()
  |  fieldDirectionOut();

//done?
data BinaryOperator = conditionalOr()
  |  divide()
  |  inEquality()
  |  conditionalAnd()
  |  bitwiseOr()
  |  bitwiseAnd()
  |  modulus()
  |  equality()
  |  lessThanOrEqual()
  |  lessThan()
  |  shiftLeft()
  |  greaterThan()
  |  add()
  |  exclusiveOr()
  |  shiftRight()
  |  multiply()
  |  \any()
  |  nullCoalescing()
  |  greaterThanOrEqual()
  |  subtract();

//done
data AssignmentOperator = assignmentOperatorShiftLeft()
  |  assignmentOperatorDivide()
  |  assignmentOperatorAssign()
  |  assignmentOperatorBitwiseOr()
  |  assignmentOperatorAdd()
  |  assignmentOperatorExclusiveOr()
  |  assignmentOperatorShiftRight()
  |  assignmentOperatorMultiply()
  |  assignmentOperatorAny()
  |  assignmentOperatorBitwiseAnd()
  |  assignmentOperatorModulus()
  |  assignmentOperatorSubtract();

//done?
data QueryClause = queryContinuationClause(str identifier, Expression precedingQuery)
  |  queryWhereClause(Expression condition)
  |  queryGroupClause(Expression key, Expression projection)
  |  queryOrderClause(list[AstNode] orderings)
  |  querySelectClause(Expression expression)
  |  queryLetClause(Expression expression, str identifier)
  |  queryFromClause(Expression expression, str identifier)
  |  queryJoinClause(Expression equalsExpression, Expression inExpression, str intoIdentifier, bool isGroupJoin, str joinIdentifier, Expression onExpression);
  
//done?
data Class = delegate() //EDIT: deze staat niet in de NRefactory enum
  |  interface()
  |  \module()			//EDIT: deze staat niet in de NRefactory enum
  |  class()
  |  enum()
  |  struct();

//done
data Modifiers = modifiersReadonly()  
  |  modifiersVirtual()
  |  modifiersPartial()
  |  modifiersNew()
  |  modifiersConst()
  |  modifiersProtected()
  |  modifiersPublic()
  |  modifiersSealed()
  |  modifiersAbstract()
  |  modifiersExtern()
  |  modifiersNone()
  |  modifiersStatic()
  |  modifiersVisibilityMask()
  |  modifiersOverride()
  |  modifiersInternal()
  |  modifiersUnsafe()
  |  modifiersFixed()   	//EDIT: deze staat niet in de NRefactory enum		
  |  modifiersVolatile()
  |  modifiersPrivate()
  |  modifiersAsync();		//EDIT: nieuw

//done
data ConstructorInitializer = this()
  |  base();

//done
data ParameterModifier = parameterModifierThis()
  |  parameterModifierNone()
  |  parameterModifierParams()
  |  parameterModifierRef()
  |  parameterModifierOut();

//done
data UnaryOperator = bitNot()
  |  dereference()
  |  not()
  |  plus()
  |  decrement()
  |  minus()
  |  postIncrement()
  |  postDecrement()
  |  addressOf()
  |  increment()
  |  await();  //EDIT: nieuw

//done
data QueryOrderingDirection = queryOrderingDirectionAscending()
  |  queryOrderingDirectionNone()
  |  queryOrderingDirectionDescending();


/////////////////////////////////////////////////
//////////////     Dont need    /////////////////    
/////////////////////////////////////////////////

//dont need
data Comment = multiLine()
  |  singleLine()
  |  documentation();


//will not use at first, maybe later
data Operator = operatorImplicit()
  |  operatorTrue()
  |  operatorBitwiseOr()
  |  operatorDivision()
  |  operatorDecrement()
  |  operatorUnaryNegation()
  |  operatorLeftShift()
  |  operatorBitwiseAnd()
  |  operatorSubtraction()
  |  operatorRightShift()
  |  operatorModulus()
  |  operatorIncrement()
  |  operatorEquality()
  |  operatorInequality()
  |  operatorLessThanOrEqual()
  |  operatorLessThan()
  |  operatorLogicalNot()
  |  operatorGreaterThan()
  |  operatorUnaryPlus()
  |  operatorExclusiveOr()
  |  operatorExplicit()
  |  operatorMultiply()
  |  operatorFalse()
  |  operatorAddition()
  |  operatorGreaterThanOrEqual()
  |  operatorOnesComplement();
  
  
/////////////////////////////////////////////////
////////   no longer used in NRefactory   ///////    
/////////////////////////////////////////////////
data AttributeTarget = attributeTargetField()
  |  attributeTargetNone()
  |  attributeTargetReturn()
  |  attributeTargetUnknown()
  |  attributeTargetType()
  |  attributeTargetModule()
  |  attributeTargetAssembly()
  |  attributeTargetMethod()
  |  attributeTargetParam();
  
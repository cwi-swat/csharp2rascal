module csharp::CSharpSyntax::CSharpSyntax

anno loc CSharpFile@location;
anno loc AstNode@location;
anno loc Expression@location;
anno loc Statement@location;
anno loc AttributedNode@location;
anno loc MemberDeclaration@location;
anno loc QueryClause@location;
anno loc ConstructorInitializer@location;

public alias CSharpProject = list[CSharpFile];

data CSharpFile = 
	cSharpFile(str filename, list[AstNode] contents);

data AstNode = 
	 	comment(Comment commentType, str content, bool startsLine)
  |  	namespaceDeclaration(str name, str fullName, list[AstNode] identifiers, list[AstNode] members)
  |  	usingDeclaration(str namespace)
  |  	usingAliasDeclaration(str \alias, AstType \import) //EDIT: import toegevoegd
  |  	constraint(list[AstType] baseTypes, AstType typeParameter) //Edit: typeparameter is AstNode geworden van str
  |  	attribute(list[Expression] arguments, AstType \type) //EDIT: type toegevoegd
  |  	attributeSection(str attributeTarget, list[AstNode] attributes) //EDIT: AttributeType naar str
  |  	cSharpTokenNode()
  |  	parameterDeclaration(str name, list[AstNode] attributes, Expression defaultExpression, ParameterModifier parameterModifier, AstType \type) //EDIT: added type
  |  	switchSection(list[AstNode] caseLabels, list[Statement] statements)
  |  	typeParameterDeclaration(str name, VarianceModifier variance)
  |  	catchClause(Statement body, str variableName, AstType \type) //EDIT added type
  |  	identifier(str name)
  |  	constructorInitializer(list[Expression] arguments, ConstructorInitializer constructorInitializerType)
  |  	variableInitializer(str name, Expression initializer)
  |  	arraySpecifier(int dimensions)
  |  	caseLabel(Expression expression)
  |  	statement(Statement nodeStatement)
  |  	astType(AstType nodeAstType)
  |  	attributedNode(AttributedNode nodeAttributedNode)
  |  	expression(Expression nodeExpression)
  |  	queryClause(QueryClause nodeQueryClause)
  |  	queryOrdering(QueryOrderingDirection direction, Expression expression)
  |  	astNodePlaceholder()   //EDIT: nieuw
  
  //Have not encoutered and dont recognize
  |  cSharpModifierToken(list[Modifiers] allModifiers, list[Modifiers] modifier)
  |  variablePlaceholder(str name, Expression initializer)
  ;

data Statement = 
		returnStatement(Expression expression)
  |  	whileStatement(Expression condition, Statement embeddedStatement)
  |  	switchStatement(Expression expression, list[AstNode] switchSections)
  |  	ifElseStatement(Expression condition, Statement falseStatement, Statement trueStatement)
  |  	variableDeclarationStatement(list[Modifiers] modifiers, list[AstNode] variables, AstType \type) // EDIT: type toegevoegd
  |  	breakStatement()
  |  	tryCatchStatement(Statement tryBlock, list[AstNode] catchClauses, Statement finallyBlock)
  |  	usingStatement(AstNode resourceAcquisition, Statement embeddedStatement)	//turned the arguments around, the resources can be used in the embed, so should be handled first(top-down)
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
  |  	expressionStatement(Expression expression)
  |  	yieldStatement(Expression expression)
  |  	unsafeStatement(Statement body)
  |  	fixedStatement(Statement embeddedStatement, list[AstNode] variables)
  |  	uncheckedStatement(Statement body)
  |  	checkedStatement(Statement body)
  //wont do goto's:
  |  labelStatement(str label)
  |  gotoDefaultStatement()
  |  gotoCaseStatement(Expression labelExpression)
  |  gotoStatement(str label)
  ;

data Expression = 
    	conditionalExpression(Expression condition, Expression falseExpression, Expression trueExpression)
  |  	binaryOperatorExpression(Expression left, BinaryOperator operator, Expression right)
  |  	directionExpression(Expression expression, FieldDirection fieldDirection)
  |  	castExpression(Expression expression, AstType \type) //EDIT: type toegevoegd 
  |  	parenthesizedExpression(Expression expression)
  |  	baseReferenceExpression()
  |  	unaryOperatorExpression(Expression expression, UnaryOperator operatorU)
  |  	identifierExpression(str identifier, list[AstType] typeArguments, AstType \type) //added type
  |  	primitiveExpression(value \value)
  |  	expressionPlaceholder()
  |  	objectCreateExpression(list[Expression] arguments, Expression initializer, AstType \type) //EDIT:  type toegevoegd
  |  	memberReferenceExpression(str memberName, Expression target, list[AstType] typeArguments)
  |  	invocationExpression(list[Expression] arguments, Expression target)
  |  	assignmentExpression(Expression left, AssignmentOperator operatorA, Expression right)
  |  	thisReferenceExpression()
  |  	arrayInitializerExpression(list[Expression] elements)
  |  	emptyExpression()  //EDIT: nieuw, aangemaakt voor objectCreateExpression, initializer is optioneel.
  |  	typeOfExpression(AstType \type) //EDIT: type
  |  	defaultValueExpression(AstType \type) //EDIT: type
  |  	arrayCreateExpression(list[AstNode] additionalArraySpecifiers, list[Expression] arguments, Expression initializer)
  |  	asExpression(Expression expression, AstType \type) //EDIT: type
  |  	typeReferenceExpression(AstType \type) //EDIT: type toegevoegd
  |  	uncheckedExpression(Expression expression)
  | 	isExpression(Expression expression, AstType \type) //EDIT: type
  |  	checkedExpression(Expression expression)
  |  	null() 			//EDIT: toegevoegd
  |  	sizeOfExpression()
  
  // handle for dep?
  |  	anonymousMethodExpression(Statement bodyS, bool hasParameterList, list[AstNode] parameters)
  |	 	anonymousTypeCreateExpression(list[Expression] Initializers)
  |  	indexerExpression(list[Expression] arguments, Expression target)
  |  	queryExpression(list[QueryClause] clauses)
  |  	namedArgumentExpression(Expression expression, str name)
  |  	namedExpression(Expression expression, str name)
  |	 	lambdaExpression(AstNode body, list[AstNode] parameters)
   
//wont do, out of scope
//pointer is ignored and treated like a normal variable declaration
  |  stackAllocExpression(Expression countExpression)
  |  	pointerReferenceExpression(str memberName, Expression target, list[AstType] typeArguments)

//wont do, it's hidden ffs. and non-existend in NRefactory(probably the same reason)
  |  argListExpression(list[Expression] arguments, bool isAccess)  
  ;


data AstType = 
		simpleType(str identifier, list[AstType] typeArguments)
  |		exactType(str identifier)   //Added type, resolved type including namespace
  |  	composedType(list[AstNode] arraySpecifiers, bool hasNullableSpecifier, int pointerRank, AstType baseType) //EDIT: baseType toegevoegd
  |  	typePlaceholder()
  |  	memberType(bool isDoubleColon, str memberName, AstType Target,  list[AstType] typeArguments) //EDIT: Target toegevoegd
  |  	primitiveType(str \keyword)
  ;

//done
data AttributedNode = 
	 	enumMemberDeclaration(str name, list[AstNode] attributes, Expression initializerA, list[AstNode] modifierTokens, list[Modifiers] modifiers)
  |  	accessor(list[AstNode] attributes, Statement body, list[AstNode] modifierTokens, list[Modifiers] modifiers)
  |  	noAccessor() //EDIT toegevoegd, beide accessors zijn niet verplicht
  |  	delegateDeclaration(str name, list[AstNode] attributes, list[AstNode] constraints, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters, list[AstNode] typeParameters)
  |  	destructorDeclaration(str name, list[AstNode] attributes, Statement body, list[AstNode] modifierTokens, list[Modifiers] modifiers)
  |  	typeDeclaration(str name, list[AstNode] attributes, list[AstType] baseTypes, Class classType, list[AstNode] constraints, list[AttributedNode] members, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] typeParameters)
  |		constructorDeclaration(str name, list[AstNode] attributes, Statement body, AstNode initializer, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters)
  |  	memberDeclaration(MemberDeclaration nodeMemberDeclaration);

data MemberDeclaration = 
 	 	indexerDeclaration(str name, list[AstNode] attributes, AttributedNode getter, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters, AttributedNode setter, AstType \type) //EDIT: type toegevoegd
  | 	methodDeclaration(str name, list[AstNode] attributes, Statement body, list[AstNode] constraints, bool isExtensionMethod, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] parameters, list[AstNode] typeParameters, AstType \type) //EDIT: type toegevoegd
  |  	propertyDeclaration(str name, list[AstNode] attributes, AttributedNode getter, list[AstNode] modifierTokens, list[Modifiers] modifiers, AttributedNode setter, AstType \type) //EDIT: type toegevoegd
  |  	fieldDeclaration(str name, list[AstNode] attributes, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] variables, AstType \type)  //EDIT: type toegevoegd
  |  	eventDeclaration(str name, list[AstNode] attributes, list[AstNode] modifierTokens, list[Modifiers] modifiers, list[AstNode] variables, AstType \type) //EDIT: type toegevoegd
  |  	customEventDeclaration(str name, AttributedNode addAccessor, list[AstNode] attributes, list[AstNode] modifierTokens, list[Modifiers] modifiers, AttributedNode removeAccessor)

//wont do, out of scope  
  |  operatorDeclaration(str name, list[AstNode] attributes, Statement body, list[AstNode] modifierTokens, list[Modifiers] modifiers, Operator operatorType, list[AstNode] parameters)
  ;

//done
data VarianceModifier = invariant()
  |  covariant()
  |  contravariant();
  
//done
data FieldDirection = fieldDirectionNone()
  |  fieldDirectionRef()
  |  fieldDirectionOut();

//done
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
data Class = 
     interface()
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
  
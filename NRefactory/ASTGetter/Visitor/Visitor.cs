using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AST_Getter.Helpers;
using ICSharpCode.NRefactory.CSharp;

namespace AST_Getter.Visitor
{
    public class Visitor : DepthFirstAstVisitor
    {
        public Visitor(string filename)
        {

            Output = new FormatHelper("cSharpFile(");
            //double backslashes, the file will be in .rsc so they will count as escapes
            Output.AddWithQuotesAndComma(filename.Replace("\\", "\\\\"));
        }

        public FormatHelper Output { get; set; }

        #region Root, CSharpFile
        //Root
        public override void VisitSyntaxTree(SyntaxTree syntaxTree)
        {
            //public alias CSharpFile=list[AstNode];

            Output.AddLine("[");

            //visit the tree and extent Output
            base.VisitSyntaxTree(syntaxTree);

            Output.Add("])");
        }

        #endregion Root, CSharpFile

        #region AstNode


        #region Output extenders

        public override void VisitUsingDeclaration(UsingDeclaration usingDeclaration)
        {
            base.VisitUsingDeclaration(usingDeclaration);

            //usingDeclaration(str namespace)
            Output.AddLine("usingDeclaration(\"" + usingDeclaration.Namespace + "\"),");
        }

        public override void VisitNamespaceDeclaration(NamespaceDeclaration namespaceDeclaration)
        {
            base.VisitNamespaceDeclaration(namespaceDeclaration);

            //namespaceDeclaration(str name,
            //                     str fullName, 
            //                     list[AstNode] identifiers, 
            //                     list[AstNode] members)
            //identifier(str name)

            Output.Add("namespaceDeclaration(");
            Output.AddWithQuotesAndComma(namespaceDeclaration.Name.Substring(namespaceDeclaration.Name.LastIndexOf('.') + 1));
            Output.AddWithQuotesAndComma(namespaceDeclaration.FullName);
            Output.AddWithComma(CollectionHelper.Get(namespaceDeclaration.Identifiers));
            Output.Add(CollectionHelper.Get(namespaceDeclaration.Members));
            Output.AddLine(")");
        }

        public override void VisitUsingAliasDeclaration(UsingAliasDeclaration usingDeclaration)
        {
            base.VisitUsingAliasDeclaration(usingDeclaration);
            //usingAliasDeclaration(str \alias, AstType \import)
            Output.Add("usingAliasDeclaration(");
            Output.AddWithQuotesAndComma(usingDeclaration.Alias);
            Output.Add(CommonHelper.Get(usingDeclaration.Import));
            Output.AddLine(")");
        }

        #endregion Output extenders

        public override void VisitParameterDeclaration(ParameterDeclaration parameterDeclaration)
        {
            base.VisitParameterDeclaration(parameterDeclaration);

            //parameterDeclaration(str name, 
            //                     list[AstNode] attributes, 
            //                     Expression defaultExpression, 
            //                     ParameterModifier parameterModifier)

            var formatter = new FormatHelper("parameterDeclaration(");
            formatter.AddWithQuotesAndComma(parameterDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(parameterDeclaration.Attributes));

            formatter.AddWithComma(parameterDeclaration.DefaultExpression.IsNull
                                      ? "expressionPlaceholder()"
                                      : parameterDeclaration.DefaultExpression.RascalString);

            formatter.Add(EnumHelper.Translate(parameterDeclaration.ParameterModifier));
            formatter.AddLine(")");

            parameterDeclaration.RascalString = formatter.S;
        }

        public override void VisitTypeParameterDeclaration(TypeParameterDeclaration typeParameterDeclaration)
        {
            base.VisitTypeParameterDeclaration(typeParameterDeclaration);
            //typeParameterDeclaration(str name, 
            //                         VarianceModifier variance)

            var formatter = new FormatHelper("typeParameterDeclaration(");
            formatter.AddWithQuotesAndComma(typeParameterDeclaration.Name);
            formatter.Add(EnumHelper.Translate(typeParameterDeclaration.Variance));
            formatter.Add(")");

            typeParameterDeclaration.RascalString = formatter.S;
        }

        public override void VisitConstraint(Constraint constraint)
        {
            base.VisitConstraint(constraint);
            //constraint(list[AstType] baseTypes, 
            //           str typeParameter)

            var formatter = new FormatHelper("constraint(");
            formatter.AddWithComma(CollectionHelper.Get(constraint.BaseTypes));
            formatter.Add(CommonHelper.Get((AstType)constraint.TypeParameter));
            formatter.Add(")");
            constraint.RascalString = formatter.S;
        }

        public override void VisitAttribute(ICSharpCode.NRefactory.CSharp.Attribute attribute)
        {
            base.VisitAttribute(attribute);
            //attribute(list[Expression] arguments, AstType \type)
            var formatter = new FormatHelper("attribute(");
            formatter.AddWithComma(CollectionHelper.Get(attribute.Arguments));
            formatter.Add(CommonHelper.Get(attribute.Type));
            formatter.Add(")");
            attribute.RascalString = formatter.S;
        }

        public override void VisitAttributeSection(AttributeSection attributeSection)
        {
            base.VisitAttributeSection(attributeSection);
            //attributeSection(str attributeTarget, list[AstNode] attributesA)

            var formatter = new FormatHelper("attributeSection(");
            formatter.AddWithQuotesAndComma(attributeSection.AttributeTarget);
            formatter.Add(CollectionHelper.Get(attributeSection.Attributes));
            formatter.Add(")");

            attributeSection.RascalString = formatter.S;
        }

        public override void VisitArraySpecifier(ArraySpecifier arraySpecifier)
        {
            base.VisitArraySpecifier(arraySpecifier);
            //arraySpecifier(int dimensions)

            arraySpecifier.RascalString = "arraySpecifier(" + arraySpecifier.Dimensions + ")";
        }

        public override void VisitVariableInitializer(VariableInitializer variableInitializer)
        {
            base.VisitVariableInitializer(variableInitializer);
            //variableInitializer(str name, 
            //                    Expression initializer)

            var formatter = new FormatHelper("variableInitializer(");
            formatter.AddWithQuotesAndComma(variableInitializer.Name);
            formatter.Add(ExpressionHelper.Get(variableInitializer.Initializer));
            formatter.Add(")");

            variableInitializer.RascalString = formatter.S;
        }

        #endregion AstNode

        #region AttributedNode

        //class
        public override void VisitTypeDeclaration(TypeDeclaration typeDeclaration)
        {
            base.VisitTypeDeclaration(typeDeclaration);
            //typeDeclaration(str name, 
            //                list[AstNode] attributes, 
            //                list[AstType] baseTypes, 
            //                Class classType, 
            //                list[AstNode] constraints, 
            //                list[AttributedNode] members, 
            //                list[AstNode] modifierTokens, 
            //                list[Modifiers] modifiers, 
            //                list[AstNode] typeParameters)

            var formatter = new FormatHelper("attributedNode(typeDeclaration(");
            formatter.AddWithQuotesAndComma(typeDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(typeDeclaration.Attributes));
            formatter.AddWithComma(CollectionHelper.Get(typeDeclaration.BaseTypes));
            formatter.AddWithComma(typeDeclaration.ClassType.ToString().ToLower() + "()");
            formatter.AddWithComma(CollectionHelper.Get(typeDeclaration.Constraints));
            formatter.AddWithComma(CollectionHelper.Get(typeDeclaration.Members));
            formatter.AddWithComma("[]");   //typeDeclaration.ModifierTokens.Select(c => c.RascalString));
            formatter.AddWithComma(EnumHelper.Translate(typeDeclaration.Modifiers));
            formatter.AddWithComma(CollectionHelper.Get(typeDeclaration.TypeParameters));
            formatter.AddLine("))");

            typeDeclaration.RascalString = formatter.S;
        }

        public override void VisitConstructorDeclaration(ConstructorDeclaration constructorDeclaration)
        {
            base.VisitConstructorDeclaration(constructorDeclaration);
            //constructorDeclaration(str name, 
            //                      list[AstNode] attributes, 
            //                      Statement body, 
            //                      AstNode initializerA, 
            //                      list[AstNode] modifierTokens, 
            //                      list[Modifiers] modifiers, 
            //                      list[AstNode] parameters)

            //todo complete node content
            var formatter = new FormatHelper("constructorDeclaration(");
            formatter.AddWithQuotesAndComma(constructorDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(constructorDeclaration.Attributes));
            formatter.AddWithComma(StatementHelper.Get(constructorDeclaration.Body));
            formatter.AddWithComma(constructorDeclaration.Initializer.IsNull
                                     ? "astNodePlaceholder()"
                                     : constructorDeclaration.Initializer.RascalString);
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(constructorDeclaration.Modifiers));
            formatter.AddWithComma(CollectionHelper.Get(constructorDeclaration.Parameters));
            formatter.AddLine(")");

            constructorDeclaration.RascalString = formatter.S;
        }

        public override void VisitConstructorInitializer(ConstructorInitializer constructorInitializer)
        {
            base.VisitConstructorInitializer(constructorInitializer);
            //constructorInitializer(list[Expression] arguments, 
            //                       ConstructorInitializer constructorInitializerType)

            var formatter = new FormatHelper("constructorInitializer(");
            formatter.AddWithComma(CollectionHelper.Get(constructorInitializer.Arguments));
            formatter.Add(EnumHelper.Translate(constructorInitializer.ConstructorInitializerType));
            formatter.AddLine(")");
            constructorInitializer.RascalString = formatter.S;
        }

        public override void VisitAccessor(Accessor accessor)
        {
            base.VisitAccessor(accessor);
            //accessor(list[AstNode] attributes, 
            //         Statement body, 
            //         list[AstNode] modifierTokens, 
            //         list[Modifiers] modifiers)

            var formatter = new FormatHelper("accessor(");
            formatter.AddWithComma(CollectionHelper.Get(accessor.Attributes));
            formatter.AddWithComma(StatementHelper.Get(accessor.Body));
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(accessor.Modifiers));
            formatter.AddLine(")");
            accessor.RascalString = formatter.S;
        }

        public override void VisitEnumMemberDeclaration(EnumMemberDeclaration enumMemberDeclaration)
        {
            base.VisitEnumMemberDeclaration(enumMemberDeclaration);
            //enumMemberDeclaration(str name, 
            //                      list[AstNode] attributes, 
            //                      Expression initializer, 
            //                      list[AstNode] modifierTokens, 
            //                      list[Modifiers] modifiers)

            var formatter = new FormatHelper("enumMemberDeclaration(");
            formatter.AddWithQuotesAndComma(enumMemberDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(enumMemberDeclaration.Attributes));
            formatter.AddWithComma(ExpressionHelper.Get(enumMemberDeclaration.Initializer));
            formatter.AddWithComma("[]");
            formatter.Add(EnumHelper.Translate(enumMemberDeclaration.Modifiers));
            formatter.AddLine(")");

            enumMemberDeclaration.RascalString = formatter.S;
        }

        public override void VisitDelegateDeclaration(DelegateDeclaration delegateDeclaration)
        {
            base.VisitDelegateDeclaration(delegateDeclaration);
            //delegateDeclaration(str name, 
            //                    list[AstNode] attributes, 
            //                    list[AstNode] constraints, 
            //                    list[AstNode] modifierTokens, 
            //                    list[Modifiers] modifiers, 
            //                    list[AstNode] parameters, 
            //                    list[AstNode] typeParameters)


            var formatter = new FormatHelper("delegateDeclaration(");

            formatter.AddWithQuotesAndComma(delegateDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(delegateDeclaration.Attributes));
            formatter.AddWithComma(CollectionHelper.Get(delegateDeclaration.Constraints));
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(delegateDeclaration.Modifiers));
            formatter.AddWithComma(CollectionHelper.Get(delegateDeclaration.Parameters));
            formatter.Add(CollectionHelper.Get(delegateDeclaration.TypeParameters));
            formatter.AddLine(")");

            delegateDeclaration.RascalString = formatter.S;
        }

        public override void VisitDestructorDeclaration(DestructorDeclaration destructorDeclaration)
        {
            base.VisitDestructorDeclaration(destructorDeclaration);
            //destructorDeclaration(str name, 
            //                      list[AstNode] attributes, 
            //                      Statement body, 
            //                      list[AstNode] modifierTokens, 
            //                      list[Modifiers] modifiers)

            var formatter = new FormatHelper("destructorDeclaration(");

            formatter.AddWithQuotesAndComma(destructorDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(destructorDeclaration.Attributes));
            formatter.AddWithComma(StatementHelper.Get(destructorDeclaration.Body));
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(destructorDeclaration.Modifiers));
            formatter.AddLine(")");

            destructorDeclaration.RascalString = formatter.S;

        }



        #endregion AttributedNode

        #region MemberDeclaration
        public override void VisitMethodDeclaration(MethodDeclaration methodDeclaration)
        {
            base.VisitMethodDeclaration(methodDeclaration);
            //methodDeclaration(str name, 
            //                  list[AstNode] attributes, 
            //                  Statement body, 
            //                  list[AstNode] constraints, 
            //                  bool isExtensionMethod, 
            //                  list[AstNode] modifierTokens, 
            //                  list[Modifiers] modifiers, 
            //                  list[AstNode] parameters, 
            //                  list[AstNode] typeParameters,
            //                  AstType \type)

            var formatter = new FormatHelper("memberDeclaration(methodDeclaration(");
            formatter.AddWithQuotesAndComma(methodDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(methodDeclaration.Attributes));
            formatter.AddWithComma(StatementHelper.Get(methodDeclaration.Body));
            formatter.AddWithComma(CollectionHelper.Get(methodDeclaration.Constraints));
            formatter.AddWithComma(methodDeclaration.IsExtensionMethod.ToString().ToLower());
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(methodDeclaration.Modifiers));
            formatter.AddWithComma(CollectionHelper.Get(methodDeclaration.Parameters));
            formatter.AddWithComma(CollectionHelper.Get(methodDeclaration.TypeParameters));
            formatter.Add(CommonHelper.Get(methodDeclaration.ReturnType));
            formatter.AddLine("))");

            methodDeclaration.RascalString = formatter.S;
        }

        public override void VisitFieldDeclaration(FieldDeclaration fieldDeclaration)
        {
            //todo next
            base.VisitFieldDeclaration(fieldDeclaration);
            //fieldDeclaration(str name, 
            //                 list[AstNode] attributes, 
            //                 list[AstNode] modifierTokens, 
            //                 list[Modifiers] modifiers, 
            //                 list[AstNode] variables,
            //                 AstType type)

            var formatter = new FormatHelper("memberDeclaration(fieldDeclaration(");
            var name = fieldDeclaration.Variables.First().Name;

            formatter.AddWithQuotesAndComma(name);
            formatter.AddWithComma(CollectionHelper.Get(fieldDeclaration.Attributes));
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(fieldDeclaration.Modifiers));
            formatter.AddWithComma(CollectionHelper.Get(fieldDeclaration.Variables));
            formatter.Add(CommonHelper.Get(fieldDeclaration.ReturnType));
            formatter.AddLine("))");

            fieldDeclaration.RascalString = formatter.S;
        }

        public override void VisitPropertyDeclaration(PropertyDeclaration propertyDeclaration)
        {
            base.VisitPropertyDeclaration(propertyDeclaration);
            //propertyDeclaration(str name, 
            //                    list[AstNode] attributes, 
            //                    AttributedNode getter, 
            //                    list[AstNode] modifierTokens, 
            //                    list[Modifiers] modifiers, 
            //                    AttributedNode setter,
            //                    AstType type)

            var formatter = new FormatHelper("memberDeclaration(propertyDeclaration(");

            formatter.AddWithQuotesAndComma(propertyDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(propertyDeclaration.Attributes));
            formatter.AddWithComma(CommonHelper.Get(propertyDeclaration.Getter));
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(propertyDeclaration.Modifiers));
            formatter.AddWithComma(CommonHelper.Get(propertyDeclaration.Setter));
            formatter.Add(CommonHelper.Get(propertyDeclaration.ReturnType));
            formatter.AddLine("))");

            propertyDeclaration.RascalString = formatter.S;
        }

        public override void VisitEventDeclaration(EventDeclaration eventDeclaration)
        {
            base.VisitEventDeclaration(eventDeclaration);
            //eventDeclaration(str name, 
            //                 list[AstNode] attributes, 
            //                 list[AstNode] modifierTokens, 
            //                 list[Modifiers] modifiers, 
            //                 list[AstNode] variables,
            //                 AstType \type);

            var formatter = new FormatHelper("memberDeclaration(eventDeclaration(");

            formatter.AddWithQuotesAndComma(eventDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(eventDeclaration.Attributes));
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(eventDeclaration.Modifiers));
            formatter.AddWithComma(CollectionHelper.Get(eventDeclaration.Variables));
            formatter.Add(CommonHelper.Get(eventDeclaration.ReturnType));
            formatter.AddLine("))");

            eventDeclaration.RascalString = formatter.S;
        }

        public override void VisitIndexerDeclaration(IndexerDeclaration indexerDeclaration)
        {
            base.VisitIndexerDeclaration(indexerDeclaration);
            //indexerDeclaration(str name, 
            //                   list[AstNode] attributes, 
            //                   AttributedNode getter, 
            //                   list[AstNode] modifierTokens, 
            //                   list[Modifiers] modifiers, 
            //                   list[AstNode] parameters, 
            //                   AttributedNode setter,
            //                   AstType type)



            var formatter = new FormatHelper("memberDeclaration(indexerDeclaration(");

            formatter.AddWithQuotesAndComma(indexerDeclaration.Name);
            formatter.AddWithComma(CollectionHelper.Get(indexerDeclaration.Attributes));
            formatter.AddWithComma(CommonHelper.Get(indexerDeclaration.Getter));
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(indexerDeclaration.Modifiers));
            formatter.AddWithComma(CollectionHelper.Get(indexerDeclaration.Parameters));
            formatter.AddWithComma(CommonHelper.Get(indexerDeclaration.Setter));
            formatter.Add(CommonHelper.Get(indexerDeclaration.ReturnType));
            formatter.AddLine("))");

            indexerDeclaration.RascalString = formatter.S;
        }

        public override void VisitCustomEventDeclaration(CustomEventDeclaration eventDeclaration)
        {
            base.VisitCustomEventDeclaration(eventDeclaration);
            //customEventDeclaration(str name, 
            //                       AttributedNode addAccessor, 
            //                       list[AstNode] attributes, 
            //                       list[AstNode] modifierTokens, 
            //                       list[Modifiers] modifiers,
            //                       AttributedNode removeAccessor)

            var formatter = new FormatHelper("memberDeclaration(customEventDeclaration(");

            formatter.AddWithQuotesAndComma(eventDeclaration.Name);
            formatter.AddWithComma(CommonHelper.Get(eventDeclaration.AddAccessor));
            formatter.AddWithComma(CollectionHelper.Get(eventDeclaration.Attributes));
            formatter.AddWithComma("[]");
            formatter.AddWithComma(EnumHelper.Translate(eventDeclaration.Modifiers));
            formatter.AddWithComma(CommonHelper.Get(eventDeclaration.RemoveAccessor));
            formatter.AddLine("))");

            eventDeclaration.RascalString = formatter.S;

        }

        #endregion MemberDeclaration

        #region Expression

        public override void VisitAssignmentExpression(AssignmentExpression assignmentExpression)
        {
            base.VisitAssignmentExpression(assignmentExpression);
            //assignmentExpression(Expression left, 
            //                     AssignmentOperator operatorA, 
            //                     Expression right)

            var formatter = new FormatHelper("assignmentExpression(");
            formatter.AddWithComma(assignmentExpression.Left.RascalString);
            formatter.AddWithComma("assignmentOperator" + assignmentExpression.Operator.ToString() + "()");
            formatter.AddWithComma(assignmentExpression.Right.RascalString);
            formatter.AddLine(")");

            assignmentExpression.RascalString = formatter.S;
        }

        public override void VisitMemberReferenceExpression(MemberReferenceExpression memberReferenceExpression)
        {
            base.VisitMemberReferenceExpression(memberReferenceExpression);
            //memberReferenceExpression(str memberName, 
            //                          Expression target, 
            //                          list[AstType] typeArguments)

            var formatter = new FormatHelper("memberReferenceExpression(");
            formatter.AddWithQuotesAndComma(memberReferenceExpression.MemberName);
            formatter.AddWithComma(ExpressionHelper.Get(memberReferenceExpression.Target));
            formatter.Add(CollectionHelper.Get(memberReferenceExpression.TypeArguments));
            formatter.Add(")");

            memberReferenceExpression.RascalString = formatter.S;
        }

        public override void VisitThisReferenceExpression(ThisReferenceExpression thisReferenceExpression)
        {
            base.VisitThisReferenceExpression(thisReferenceExpression);
            thisReferenceExpression.RascalString = "thisReferenceExpression()";
        }

        public override void VisitBaseReferenceExpression(BaseReferenceExpression baseReferenceExpression)
        {
            base.VisitBaseReferenceExpression(baseReferenceExpression);
            baseReferenceExpression.RascalString = "baseReferenceExpression()";
        }

        public override void VisitNullReferenceExpression(NullReferenceExpression nullReferenceExpression)
        {
            base.VisitNullReferenceExpression(nullReferenceExpression);
            nullReferenceExpression.RascalString = "null()";
        }

        public override void VisitPrimitiveExpression(PrimitiveExpression primitiveExpression)
        {
            base.VisitPrimitiveExpression(primitiveExpression);
            var formatter = new FormatHelper("primitiveExpression(");

            if (primitiveExpression.Value is string)
                formatter.Add("\"" + primitiveExpression.Value + "\"");
            else if (primitiveExpression.Value is double ||
                     primitiveExpression.Value is decimal ||
                     primitiveExpression.Value is float)
                formatter.Add(primitiveExpression.Value.ToString().Replace(",", "."));
            else if (primitiveExpression.Value is bool)
                formatter.Add(primitiveExpression.Value.ToString().ToLower());
            else
                formatter.Add(primitiveExpression.Value.ToString());

            formatter.Add(")");
            primitiveExpression.RascalString = formatter.S;
        }

        public override void VisitIdentifierExpression(IdentifierExpression identifierExpression)
        {
            base.VisitIdentifierExpression(identifierExpression);
            //identifierExpression(str identifier, 
            //                     list[AstType] typeArguments)

            var formatter = new FormatHelper("identifierExpression(");
            formatter.AddWithQuotesAndComma(identifierExpression.Identifier);
            formatter.Add(CollectionHelper.Get(identifierExpression.TypeArguments));
            formatter.Add(")");
            identifierExpression.RascalString = formatter.S;
        }

        public override void VisitBinaryOperatorExpression(BinaryOperatorExpression binaryOperatorExpression)
        {
            base.VisitBinaryOperatorExpression(binaryOperatorExpression);
            //binaryOperatorExpression(Expression left, 
            //                         BinaryOperator operator, 
            //                         Expression right)

            var formatter = new FormatHelper("binaryOperatorExpression(");
            formatter.AddWithComma(ExpressionHelper.Get(binaryOperatorExpression.Left));
            formatter.AddWithComma(EnumHelper.Translate(binaryOperatorExpression.Operator));
            formatter.AddWithComma(ExpressionHelper.Get(binaryOperatorExpression.Right));
            formatter.Add(")");

            binaryOperatorExpression.RascalString = formatter.S;

        }

        public override void VisitObjectCreateExpression(ObjectCreateExpression objectCreateExpression)
        {
            base.VisitObjectCreateExpression(objectCreateExpression);
            //objectCreateExpression(list[Expression] arguments, 
            //                       Expression initializer,
            //                       AstType type)

            var formatter = new FormatHelper("objectCreateExpression(");
            formatter.AddWithComma(CollectionHelper.Get(objectCreateExpression.Arguments));
            formatter.AddWithComma(ExpressionHelper.Get(objectCreateExpression.Initializer));
            formatter.Add(CommonHelper.Get(objectCreateExpression.Type));
            formatter.Add(")");

            objectCreateExpression.RascalString = formatter.S;
        }

        public override void VisitArrayInitializerExpression(ArrayInitializerExpression arrayInitializerExpression)
        {
            base.VisitArrayInitializerExpression(arrayInitializerExpression);
            //arrayInitializerExpression(list[Expression] elements)

            var formatter = new FormatHelper("arrayInitializerExpression(");
            formatter.Add(CollectionHelper.Get(arrayInitializerExpression.Elements));
            formatter.Add(")");

            arrayInitializerExpression.RascalString = formatter.S;
        }

        public override void VisitUnaryOperatorExpression(UnaryOperatorExpression unaryOperatorExpression)
        {
            base.VisitUnaryOperatorExpression(unaryOperatorExpression);

            //unaryOperatorExpression(Expression expression, 
            //                        UnaryOperator operatorU)

            var formatter = new FormatHelper("unaryOperatorExpression(");
            formatter.AddWithComma(unaryOperatorExpression.Expression.RascalString);
            formatter.Add(EnumHelper.Translate(unaryOperatorExpression.Operator));
            formatter.Add(")");

            unaryOperatorExpression.RascalString = formatter.S;
        }

        public override void VisitQueryExpression(QueryExpression queryExpression)
        {
            base.VisitQueryExpression(queryExpression);
            //queryExpression(list[QueryClause] clauses)
            var formatter = new FormatHelper("queryExpression(");
            formatter.Add(CollectionHelper.Get(queryExpression.Clauses));
            formatter.Add(")");

            queryExpression.RascalString = formatter.S;
        }

        public override void VisitInvocationExpression(InvocationExpression invocationExpression)
        {
            base.VisitInvocationExpression(invocationExpression);
            //invocationExpression(list[Expression] arguments, 
            //                     Expression target)
            var formatter = new FormatHelper("invocationExpression(");
            formatter.AddWithComma(CollectionHelper.Get(invocationExpression.Arguments));
            formatter.Add(ExpressionHelper.Get(invocationExpression.Target));
            formatter.Add(")");

            invocationExpression.RascalString = formatter.S;
        }

        public override void VisitLambdaExpression(LambdaExpression lambdaExpression)
        {
            base.VisitLambdaExpression(lambdaExpression);
            //lambdaExpression(AstNode body, 
            //                 list[AstNode] parameters)
            var formatter = new FormatHelper("lambdaExpression(");
            formatter.AddWithComma(CommonHelper.Get(lambdaExpression.Body));
            formatter.Add(CollectionHelper.Get(lambdaExpression.Parameters));
            formatter.Add(")");

            lambdaExpression.RascalString = formatter.S;
        }

        public override void VisitTypeReferenceExpression(TypeReferenceExpression typeReferenceExpression)
        {
            base.VisitTypeReferenceExpression(typeReferenceExpression);
            //typeReferenceExpression(AstType \type)

            typeReferenceExpression.RascalString = "typeReferenceExpression(" + CommonHelper.Get(typeReferenceExpression.Type) + ")";
        }
        public override void VisitParenthesizedExpression(ParenthesizedExpression parenthesizedExpression)
        {
            base.VisitParenthesizedExpression(parenthesizedExpression);

            parenthesizedExpression.RascalString = "parenthesizedExpression(" + ExpressionHelper.Get(parenthesizedExpression.Expression) + ")";
        }

        /// linq continuation
        /// var groupings = from element in examples
        ///                 group element by element into groups
        ///       -->       select new
        ///                 {
        ///                     Key = groups.Key,
        ///                     Count = groups.Count()
        ///                 }; 
        public override void VisitAnonymousTypeCreateExpression(AnonymousTypeCreateExpression anonymousTypeCreateExpression)
        {
            base.VisitAnonymousTypeCreateExpression(anonymousTypeCreateExpression);
            //anonymousTypeCreateExpression(list[Expression] Initializers)

            var formatter = new FormatHelper("anonymousTypeCreateExpression(");
            formatter.Add(CollectionHelper.Get(anonymousTypeCreateExpression.Initializers));
            formatter.Add(")");

            anonymousTypeCreateExpression.RascalString = formatter.S;
        }

        public override void VisitNamedExpression(NamedExpression namedExpression)
        {
            base.VisitNamedExpression(namedExpression);
            //namedExpression(Expression expression, 
            //                str identifier)

            var formatter = new FormatHelper("namedExpression(");
            formatter.AddWithComma(ExpressionHelper.Get(namedExpression.Expression));
            formatter.AddWithQuotes(namedExpression.Name);
            formatter.Add(")");

            namedExpression.RascalString = formatter.S;
        }

        public override void VisitNamedArgumentExpression(NamedArgumentExpression namedArgumentExpression)
        {
            base.VisitNamedArgumentExpression(namedArgumentExpression);
            //namedArgumentExpression(Expression expression, 
            //                        str identifier)

            var formatter = new FormatHelper("namedArgumentExpression(");
            formatter.AddWithComma(ExpressionHelper.Get(namedArgumentExpression.Expression));
            formatter.AddWithQuotes(namedArgumentExpression.Name);
            formatter.Add(")");

            namedArgumentExpression.RascalString = formatter.S;
        }

        public override void VisitDirectionExpression(DirectionExpression directionExpression)
        {
            base.VisitDirectionExpression(directionExpression);
            //directionExpression(Expression expression, 
            //                    FieldDirection fieldDirection)

            var formatter = new FormatHelper("directionExpression(");
            formatter.AddWithComma(ExpressionHelper.Get(directionExpression.Expression));
            formatter.Add(EnumHelper.Translate(directionExpression.FieldDirection));
            formatter.Add(")");

            directionExpression.RascalString = formatter.S;
        }

        public override void VisitConditionalExpression(ConditionalExpression conditionalExpression)
        {
            base.VisitConditionalExpression(conditionalExpression);
            //conditionalExpression(Expression condition, Expression falseExpression, Expression trueExpression)

            var formatter = new FormatHelper("conditionalExpression(");
            formatter.AddWithComma(conditionalExpression.Condition.RascalString);
            formatter.AddWithComma(ExpressionHelper.Get(conditionalExpression.FalseExpression));
            formatter.AddWithComma(ExpressionHelper.Get(conditionalExpression.TrueExpression));
            formatter.Add(")");

            conditionalExpression.RascalString = formatter.S;
        }

        public override void VisitCastExpression(CastExpression castExpression)
        {
            base.VisitCastExpression(castExpression);
            //castExpression(Expression expression, AstType \type)
            var formatter = new FormatHelper("castExpression(");
            formatter.AddWithComma(ExpressionHelper.Get(castExpression.Expression));
            formatter.Add(CommonHelper.Get(castExpression.Type));
            formatter.Add(")");

            castExpression.RascalString = formatter.S;
        }

        public override void VisitTypeOfExpression(TypeOfExpression typeOfExpression)
        {
            base.VisitTypeOfExpression(typeOfExpression);
            //typeOfExpression(AstType \type)

            typeOfExpression.RascalString = "typeOfExpression(" + CommonHelper.Get(typeOfExpression.Type) + ")";
        }

        public override void VisitDefaultValueExpression(DefaultValueExpression defaultValueExpression)
        {
            base.VisitDefaultValueExpression(defaultValueExpression);
            //defaultValueExpression(AstType \type)

            defaultValueExpression.RascalString = "defaultValueExpression(" + CommonHelper.Get(defaultValueExpression.Type) + ")";
        }

        public override void VisitSizeOfExpression(SizeOfExpression sizeOfExpression)
        {
            base.VisitSizeOfExpression(sizeOfExpression);
            sizeOfExpression.RascalString = "sizeOfExpression()";
        }

        public override void VisitIsExpression(IsExpression isExpression)
        {
            base.VisitIsExpression(isExpression);
            //isExpression(Expression expression, AstType \type)
            isExpression.RascalString = "isExpression(" + ExpressionHelper.Get(isExpression.Expression) + "," + CommonHelper.Get(isExpression.Type) + ")";
        }

        public override void VisitAsExpression(AsExpression asExpression)
        {
            base.VisitAsExpression(asExpression);
            //asExpression(Expression expression, AstType \type)
            asExpression.RascalString = "asExpression(" + ExpressionHelper.Get(asExpression.Expression) + "," + CommonHelper.Get(asExpression.Type) + ")";
        }

        public override void VisitArrayCreateExpression(ArrayCreateExpression arrayCreateExpression)
        {
            base.VisitArrayCreateExpression(arrayCreateExpression);
            //arrayCreateExpression(list[AstNode] additionalArraySpecifiers, 
            //                      list[Expression] arguments, 
            //                      Expression initializer)

            var formatter = new FormatHelper("arrayCreateExpression(");
            formatter.AddWithComma(CollectionHelper.Get(arrayCreateExpression.AdditionalArraySpecifiers));
            formatter.AddWithComma(CollectionHelper.Get(arrayCreateExpression.Arguments));
            formatter.Add(ExpressionHelper.Get(arrayCreateExpression.Initializer));
            formatter.Add(")");

            arrayCreateExpression.RascalString = formatter.S;
        }

        public override void VisitCheckedExpression(CheckedExpression checkedExpression)
        {
            base.VisitCheckedExpression(checkedExpression);
            //checkedExpression(Expression expression)
            checkedExpression.RascalString = "checkedExpression(" + ExpressionHelper.Get(checkedExpression.Expression) + ")";
        }

        public override void VisitUncheckedExpression(UncheckedExpression uncheckedExpression)
        {
            base.VisitUncheckedExpression(uncheckedExpression);
            //uncheckedExpression(Expression expression)
            uncheckedExpression.RascalString = "uncheckedExpression(" + ExpressionHelper.Get(uncheckedExpression.Expression) + ")";
        }

        public override void VisitIndexerExpression(IndexerExpression indexerExpression)
        {
            base.VisitIndexerExpression(indexerExpression);
            //indexerExpression(list[Expression] arguments, Expression target)

            var formatter = new FormatHelper("indexerExpression(");
            formatter.AddWithComma(CollectionHelper.Get(indexerExpression.Arguments));
            formatter.Add(ExpressionHelper.Get(indexerExpression.Target));
            formatter.Add(")");

            indexerExpression.RascalString = formatter.S;
        }

        public override void VisitAnonymousMethodExpression(AnonymousMethodExpression anonymousMethodExpression)
        {
            base.VisitAnonymousMethodExpression(anonymousMethodExpression);
            //anonymousMethodExpression(Statement bodyS, 
            //                          bool hasParameterList, 
            //                          list[AstNode] parameters)

            var formatter = new FormatHelper("anonymousMethodExpression(");
            formatter.AddWithComma(StatementHelper.Get(anonymousMethodExpression.Body));
            formatter.AddWithComma(anonymousMethodExpression.HasParameterList.ToString().ToLower());
            formatter.Add(CollectionHelper.Get(anonymousMethodExpression.Parameters));
            formatter.Add(")");

            anonymousMethodExpression.RascalString = formatter.S;
        }

        public override void VisitStackAllocExpression(StackAllocExpression stackAllocExpression)
        {
            base.VisitStackAllocExpression(stackAllocExpression);
            //stackAllocExpression(Expression countExpression)

            stackAllocExpression.RascalString = "stackAllocExpression(" + ExpressionHelper.Get(stackAllocExpression.CountExpression) + ")";
        }
        
        #endregion Expression

        #region Statement

        public override void VisitExpressionStatement(ExpressionStatement expressionStatement)
        {
            base.VisitExpressionStatement(expressionStatement);

            expressionStatement.RascalString = "expressionStatement(" + expressionStatement.Expression.RascalString + ")";
        }

        public override void VisitBlockStatement(BlockStatement blockStatement)
        {
            base.VisitBlockStatement(blockStatement);
            //blockStatementPlaceholder(list[Statement] statements)
            var formatter = new FormatHelper("blockStatementPlaceholder(");
            formatter.Add(CollectionHelper.Get(blockStatement.Statements));
            formatter.Add(")");

            blockStatement.RascalString = formatter.S;
        }

        public override void VisitIfElseStatement(IfElseStatement ifElseStatement)
        {
            base.VisitIfElseStatement(ifElseStatement);
            //ifElseStatement(Expression condition, Statement falseStatement, Statement trueStatement)

            var formatter = new FormatHelper("ifElseStatement(");
            formatter.AddWithComma(ifElseStatement.Condition.RascalString);
            formatter.AddWithComma(StatementHelper.Get(ifElseStatement.FalseStatement));
            formatter.AddWithComma(StatementHelper.Get(ifElseStatement.TrueStatement));
            formatter.Add(")");

            ifElseStatement.RascalString = formatter.S;
        }

        public override void VisitReturnStatement(ReturnStatement returnStatement)
        {
            base.VisitReturnStatement(returnStatement);
            //returnStatement(Expression expression)

            returnStatement.RascalString = "returnStatement(" + returnStatement.Expression.RascalString + ")";
        }

        public override void VisitVariableDeclarationStatement(VariableDeclarationStatement variableDeclarationStatement)
        {
            base.VisitVariableDeclarationStatement(variableDeclarationStatement);
            //variableDeclarationStatement(list[Modifiers] modifiers, 
            //                             list[AstNode] variables,
            //                             AstType type)

            var formatter = new FormatHelper("variableDeclarationStatement(");
            formatter.AddWithComma(EnumHelper.Translate(variableDeclarationStatement.Modifiers));
            formatter.AddWithComma(CollectionHelper.Get(variableDeclarationStatement.Variables));
            formatter.Add(CommonHelper.Get(variableDeclarationStatement.Type));
            formatter.Add(")");

            variableDeclarationStatement.RascalString = formatter.S;
        }

        public override void VisitDoWhileStatement(DoWhileStatement doWhileStatement)
        {
            base.VisitDoWhileStatement(doWhileStatement);
            //doWhileStatement(Expression condition, 
            //                 Statement embeddedStatement)
            var formatter = new FormatHelper("doWhileStatement(");
            formatter.AddWithComma(ExpressionHelper.Get(doWhileStatement.Condition));
            formatter.Add(StatementHelper.Get(doWhileStatement.EmbeddedStatement));
            formatter.Add(")");

            doWhileStatement.RascalString = formatter.S;
        }

        public override void VisitContinueStatement(ContinueStatement continueStatement)
        {
            base.VisitContinueStatement(continueStatement);

            continueStatement.RascalString = "continueStatement()";
        }

        public override void VisitForeachStatement(ForeachStatement foreachStatement)
        {
            base.VisitForeachStatement(foreachStatement);
            //foreachStatement(Statement embeddedStatement, 
            //                 Expression inExpression, 
            //                 str variableName)

            var formatter = new FormatHelper("foreachStatement(");
            formatter.AddWithComma(StatementHelper.Get(foreachStatement.EmbeddedStatement));
            formatter.AddWithComma(ExpressionHelper.Get(foreachStatement.InExpression));
            formatter.AddWithQuotes(foreachStatement.VariableName);
            formatter.Add(")");

            foreachStatement.RascalString = formatter.S;
        }

        public override void VisitForStatement(ForStatement forStatement)
        {
            base.VisitForStatement(forStatement);
            //forStatement(Expression condition, 
            //             Statement embeddedStatement, 
            //             list[Statement] initializers, 
            //             list[Statement] iterators)

            var formatter = new FormatHelper("forStatement(");
            formatter.AddWithComma(ExpressionHelper.Get(forStatement.Condition));
            formatter.AddWithComma(StatementHelper.Get(forStatement.EmbeddedStatement));
            formatter.AddWithComma(CollectionHelper.Get(forStatement.Initializers));
            formatter.Add(CollectionHelper.Get(forStatement.Iterators));
            formatter.Add(")");

            forStatement.RascalString = formatter.S;
        }

        public override void VisitThrowStatement(ThrowStatement throwStatement)
        {
            base.VisitThrowStatement(throwStatement);
            //throwStatement(Expression expression)
            var formatter = new FormatHelper("throwStatement(");
            formatter.Add(ExpressionHelper.Get(throwStatement.Expression));
            formatter.Add(")");

            throwStatement.RascalString = formatter.S;
        }

        public override void VisitLockStatement(LockStatement lockStatement)
        {
            base.VisitLockStatement(lockStatement);
            //lockStatement(Statement embeddedStatement, 
            //              Expression expression)

            var formatter = new FormatHelper("lockStatement(");
            formatter.AddWithComma(StatementHelper.Get(lockStatement.EmbeddedStatement));
            formatter.Add(ExpressionHelper.Get(lockStatement.Expression));
            formatter.Add(")");

            lockStatement.RascalString = formatter.S;
        }

        public override void VisitUsingStatement(UsingStatement usingStatement)
        {
            base.VisitUsingStatement(usingStatement);
            //usingStatement(Statement embeddedStatement, 
            //               AstNode resourceAcquisition)

            var formatter = new FormatHelper("usingStatement(");
            formatter.AddWithComma(StatementHelper.Get(usingStatement.EmbeddedStatement));
            formatter.Add(usingStatement.ResourceAcquisition is Expression
                        ? "expression(" + ExpressionHelper.Get((Expression)usingStatement.ResourceAcquisition) + ")"
                        : "statement(" + usingStatement.ResourceAcquisition.RascalString + ")"
                        );
            formatter.Add(")");

            usingStatement.RascalString = formatter.S;
        }

        public override void VisitWhileStatement(WhileStatement whileStatement)
        {
            base.VisitWhileStatement(whileStatement);
            //whileStatement(Expression condition, 
            //               Statement embeddedStatement)

            var formatter = new FormatHelper("whileStatement(");
            formatter.AddWithComma(ExpressionHelper.Get(whileStatement.Condition));
            formatter.Add(StatementHelper.Get(whileStatement.EmbeddedStatement));
            formatter.Add(")");

            whileStatement.RascalString = formatter.S;
        }

        public override void VisitFixedStatement(FixedStatement fixedStatement)
        {
            base.VisitFixedStatement(fixedStatement);
            //fixedStatement(Statement embeddedStatement, list[AstNode] variables)

            var formatter = new FormatHelper("fixedStatement(");
            formatter.AddWithComma(StatementHelper.Get(fixedStatement.EmbeddedStatement));
            formatter.Add(CollectionHelper.Get(fixedStatement.Variables));
            formatter.Add(")");

            fixedStatement.RascalString = formatter.S;
        }

        public override void VisitUnsafeStatement(UnsafeStatement unsafeStatement)
        {
            base.VisitUnsafeStatement(unsafeStatement);
            //unsafeStatement(Statement body)

            var formatter = new FormatHelper("unsafeStatement(");
            formatter.Add(StatementHelper.Get(unsafeStatement.Body));
            formatter.Add(")");

            unsafeStatement.RascalString = formatter.S;
        }

        public override void VisitCheckedStatement(CheckedStatement checkedStatement)
        {
            base.VisitCheckedStatement(checkedStatement);
            //checkedStatement(Statement body);

            var formatter = new FormatHelper("checkedStatement(");
            formatter.Add(StatementHelper.Get(checkedStatement.Body));
            formatter.Add(")");

            checkedStatement.RascalString = formatter.S;
        }

        public override void VisitUncheckedStatement(UncheckedStatement uncheckedStatement)
        {
            base.VisitUncheckedStatement(uncheckedStatement);
            //uncheckedStatement(Statement body)

            var formatter = new FormatHelper("uncheckedStatement(");
            formatter.Add(StatementHelper.Get(uncheckedStatement.Body));
            formatter.Add(")");

            uncheckedStatement.RascalString = formatter.S;
        }

        #region Yield
        public override void VisitYieldReturnStatement(YieldReturnStatement yieldReturnStatement)
        {
            base.VisitYieldReturnStatement(yieldReturnStatement);
            //yieldStatement(Expression expression)
            var formatter = new FormatHelper("yieldStatement(");
            formatter.Add(ExpressionHelper.Get(yieldReturnStatement.Expression));
            formatter.Add(")");

            yieldReturnStatement.RascalString = formatter.S;
        }

        public override void VisitYieldBreakStatement(YieldBreakStatement yieldBreakStatement)
        {
            base.VisitYieldBreakStatement(yieldBreakStatement);

            //yieldBreakStatement()

            yieldBreakStatement.RascalString = "yieldBreakStatement()";
        }

        #endregion Yield

        #region SwitchCase
        public override void VisitSwitchStatement(SwitchStatement switchStatement)
        {
            base.VisitSwitchStatement(switchStatement);
            //switchStatement(Expression expression, 
            //                list[AstNode] switchSections)

            var formatter = new FormatHelper("switchStatement(");
            formatter.AddWithComma(switchStatement.Expression.RascalString);
            formatter.Add(CollectionHelper.Get(switchStatement.SwitchSections));
            formatter.Add(")");

            switchStatement.RascalString = formatter.S;
        }

        public override void VisitSwitchSection(SwitchSection switchSection)
        {
            base.VisitSwitchSection(switchSection);
            //switchSection(list[AstNode] caseLabels, 
            //              list[Statement] statements)

            var formatter = new FormatHelper("switchSection(");
            formatter.AddWithComma(CollectionHelper.Get(switchSection.CaseLabels));
            formatter.Add(CollectionHelper.Get(switchSection.Statements));
            formatter.Add(")");
            switchSection.RascalString = formatter.S;
        }

        public override void VisitCaseLabel(CaseLabel caseLabel)
        {
            base.VisitCaseLabel(caseLabel);
            //caseLabel(Expression expression)

            caseLabel.RascalString = "caseLabel(" + ExpressionHelper.Get(caseLabel.Expression) + ")";
        }

        public override void VisitBreakStatement(BreakStatement breakStatement)
        {
            base.VisitBreakStatement(breakStatement);

            breakStatement.RascalString = "breakStatement()";
        }
        #endregion SwitchCase

        #region TryCatch

        public override void VisitTryCatchStatement(TryCatchStatement tryCatchStatement)
        {
            base.VisitTryCatchStatement(tryCatchStatement);
            //tryCatchStatement(list[AstNode] catchClauses, 
            //                  Statement finallyBlock, 
            //                  Statement tryBlock)
            var formatter = new FormatHelper("tryCatchStatement(");
            formatter.AddWithComma(CollectionHelper.Get(tryCatchStatement.CatchClauses));
            formatter.AddWithComma(StatementHelper.Get(tryCatchStatement.FinallyBlock));
            formatter.Add(tryCatchStatement.TryBlock.RascalString);
            formatter.Add(")");

            tryCatchStatement.RascalString = formatter.S;
        }

        public override void VisitCatchClause(CatchClause catchClause)
        {
            base.VisitCatchClause(catchClause);
            //catchClause(Statement body, 
            //            str variableName)

            var formatter = new FormatHelper("catchClause(");
            formatter.AddWithComma(catchClause.Body.RascalString);
            formatter.AddWithQuotes(catchClause.VariableName);
            formatter.Add(")");

            catchClause.RascalString = formatter.S;
        }

        #endregion TryCatch

        #endregion Statement

        #region QueryCause

        public override void VisitQueryContinuationClause(QueryContinuationClause queryContinuationClause)
        {
            base.VisitQueryContinuationClause(queryContinuationClause);
            //queryContinuationClause(str identifier, Expression precedingQuery)

            var formatter = new FormatHelper("queryContinuationClause(");
            formatter.AddWithQuotesAndComma(queryContinuationClause.Identifier);
            formatter.Add(ExpressionHelper.Get(queryContinuationClause.PrecedingQuery));
            formatter.Add(")");

            queryContinuationClause.RascalString = formatter.S;
        }

        public override void VisitQueryWhereClause(QueryWhereClause queryWhereClause)
        {
            base.VisitQueryWhereClause(queryWhereClause);
            //queryWhereClause(Expression condition)

            queryWhereClause.RascalString = "queryWhereClause(" + ExpressionHelper.Get(queryWhereClause.Condition) + ")";
        }

        public override void VisitQueryGroupClause(QueryGroupClause queryGroupClause)
        {
            base.VisitQueryGroupClause(queryGroupClause);
            //queryGroupClause(Expression key, 
            //                 Expression projection)

            var formatter = new FormatHelper("queryGroupClause(");
            formatter.AddWithComma(ExpressionHelper.Get(queryGroupClause.Key));
            formatter.Add(ExpressionHelper.Get(queryGroupClause.Projection));
            formatter.Add(")");

            queryGroupClause.RascalString = formatter.S;
        }

        public override void VisitQueryOrderClause(QueryOrderClause queryOrderClause)
        {
            base.VisitQueryOrderClause(queryOrderClause);
            //queryOrderClause(list[AstNode] orderings)

            var formatter = new FormatHelper("queryOrderClause(");
            formatter.Add(CollectionHelper.Get(queryOrderClause.Orderings));
            formatter.Add(")");

            queryOrderClause.RascalString = formatter.S;
        }

        public override void VisitQuerySelectClause(QuerySelectClause querySelectClause)
        {
            base.VisitQuerySelectClause(querySelectClause);
            //querySelectClause(Expression expression)

            querySelectClause.RascalString = "querySelectClause(" + ExpressionHelper.Get(querySelectClause.Expression) + ")";

        }

        public override void VisitQueryLetClause(QueryLetClause queryLetClause)
        {
            base.VisitQueryLetClause(queryLetClause);
            //queryLetClause(Expression expression, str identifier)

            var formatter = new FormatHelper("queryLetClause(");
            formatter.AddWithComma(ExpressionHelper.Get(queryLetClause.Expression));
            formatter.AddWithQuotes(queryLetClause.Identifier);
            formatter.Add(")");

            queryLetClause.RascalString = formatter.S;
        }

        public override void VisitQueryFromClause(QueryFromClause queryFromClause)
        {
            base.VisitQueryFromClause(queryFromClause);
            //queryFromClause(Expression expression, str identifier)

            var formatter = new FormatHelper("queryFromClause(");
            formatter.AddWithComma(ExpressionHelper.Get(queryFromClause.Expression));
            formatter.AddWithQuotes(queryFromClause.Identifier);
            formatter.Add(")");

            queryFromClause.RascalString = formatter.S;
        }

        public override void VisitQueryJoinClause(QueryJoinClause queryJoinClause)
        {
            base.VisitQueryJoinClause(queryJoinClause);
            //queryJoinClause(Expression equalsExpression, 
            //                Expression inExpression, 
            //                str intoIdentifier, 
            //                bool isGroupJoin, 
            //                str joinIdentifier, 
            //                Expression onExpression);

            var formatter = new FormatHelper("queryJoinClause(");
            formatter.AddWithComma(ExpressionHelper.Get(queryJoinClause.EqualsExpression));
            formatter.AddWithComma(ExpressionHelper.Get(queryJoinClause.InExpression));
            formatter.AddWithQuotesAndComma(queryJoinClause.IntoIdentifier);
            formatter.AddWithComma(queryJoinClause.IsGroupJoin.ToString().ToLower());
            formatter.AddWithQuotesAndComma(queryJoinClause.JoinIdentifier);
            formatter.Add(ExpressionHelper.Get(queryJoinClause.OnExpression));
            formatter.Add(")");

            queryJoinClause.RascalString = formatter.S;
        }

        public override void VisitQueryOrdering(QueryOrdering queryOrdering)
        {
            base.VisitQueryOrdering(queryOrdering);
            //queryOrdering(QueryOrderingDirection direction, 
            //              Expression expression)
            var formatter = new FormatHelper("queryOrdering(");
            formatter.AddWithComma(EnumHelper.Translate(queryOrdering.Direction));
            formatter.Add(ExpressionHelper.Get(queryOrdering.Expression));
            formatter.Add(")");

            queryOrdering.RascalString = formatter.S;
        }

        #endregion QueryCause

    }
}
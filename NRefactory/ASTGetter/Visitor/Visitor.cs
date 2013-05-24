using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AST_Getter.Helpers;
using ICSharpCode.NRefactory.CSharp;
using ICSharpCode.NRefactory.CSharp.Resolver;
using ICSharpCode.NRefactory.TypeSystem;

namespace AST_Getter
{
    class EmptyCollection { }
    public class Visitor : DepthFirstAstVisitor
    {
        private static readonly EmptyCollection _EmptyCollection = new EmptyCollection();
        public static CSharpAstResolver resolver;

        public Visitor(string filename, ICompilation compilation, SyntaxTree syntaxTree)
        {
            var CsharpResolver = new CSharpResolver(compilation);
            resolver = new CSharpAstResolver(CsharpResolver, syntaxTree);

            LocationHelper.CurrentFilename = filename;
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

            Output.Add("[");

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
            var str = String.Format("usingDeclaration(\"{0}\"){1},", usingDeclaration.Namespace,
                                    LocationHelper.Get(usingDeclaration));
            Output.Add(str);
        }

        public override void VisitNamespaceDeclaration(NamespaceDeclaration namespaceDeclaration)
        {
            base.VisitNamespaceDeclaration(namespaceDeclaration);

            //namespaceDeclaration(str name,
            //                     str fullName, 
            //                     list[AstNode] identifiers, 
            //                     list[AstNode] members)
            //identifier(str name)
            var attributes = new object[]
            {
                namespaceDeclaration.Name.Substring(namespaceDeclaration.Name.LastIndexOf('.') + 1),
                namespaceDeclaration.FullName,
                namespaceDeclaration.Identifiers,
                namespaceDeclaration.Members
            };

            var f = new FormatHelper("namespaceDeclaration(", attributes, ")", namespaceDeclaration);
            Output.Add(f.S + ",");
        }

        public override void VisitUsingAliasDeclaration(UsingAliasDeclaration usingAliasDeclaration)
        {
            base.VisitUsingAliasDeclaration(usingAliasDeclaration);
            //usingAliasDeclaration(str \alias, AstType \import)

            var attributes = new object[]
            {
                usingAliasDeclaration.Alias,
                usingAliasDeclaration.Import
            };

            var f = new FormatHelper("usingAliasDeclaration(", attributes, ")", usingAliasDeclaration);
            Output.Add(f.S + ",");
        }

        #endregion Output extenders

        public override void VisitParameterDeclaration(ParameterDeclaration parameterDeclaration)
        {
            base.VisitParameterDeclaration(parameterDeclaration);

            //parameterDeclaration(str name, 
            //                     list[AstNode] attributes, 
            //                     Expression defaultExpression, 
            //                     ParameterModifier parameterModifier,
            //                     AstType \type)

            var attributes = new object[]
            {
                parameterDeclaration.Name,
                parameterDeclaration.Attributes,
                parameterDeclaration.DefaultExpression,
                parameterDeclaration.ParameterModifier,
                parameterDeclaration.Type
            };

            var f = new FormatHelper("parameterDeclaration(", attributes, ")", parameterDeclaration);

            parameterDeclaration.RascalString = f.S;
        }

        public override void VisitTypeParameterDeclaration(TypeParameterDeclaration typeParameterDeclaration)
        {
            base.VisitTypeParameterDeclaration(typeParameterDeclaration);
            //typeParameterDeclaration(str name, 
            //                         VarianceModifier variance)
            var attributes = new object[]
            {
                typeParameterDeclaration.Name,
                typeParameterDeclaration.Variance
            };

            var f = new FormatHelper("typeParameterDeclaration(", attributes, ")", typeParameterDeclaration);


            typeParameterDeclaration.RascalString = f.S;
        }

        public override void VisitConstraint(Constraint constraint)
        {
            base.VisitConstraint(constraint);
            //constraint(list[AstType] baseTypes, 
            //           str typeParameter)
            var attributes = new object[]
            {
                constraint.BaseTypes,
                (AstType)constraint.TypeParameter
            };

            var f = new FormatHelper("constraint(", attributes, ")", constraint);

            constraint.RascalString = f.S;
        }

        public override void VisitAttribute(ICSharpCode.NRefactory.CSharp.Attribute attribute)
        {
            base.VisitAttribute(attribute);
            //attribute(list[Expression] arguments, AstType \type)

            var attributes = new object[]
            {
                attribute.Arguments,
                attribute.Type
            };

            var f = new FormatHelper("attribute(", attributes, ")", attribute);

            attribute.RascalString = f.S;
        }

        public override void VisitAttributeSection(AttributeSection attributeSection)
        {
            base.VisitAttributeSection(attributeSection);
            //attributeSection(str attributeTarget, list[AstNode] attributesA)
            var attributes = new object[]
            {
                attributeSection.AttributeTarget,
                attributeSection.Attributes
            };

            var f = new FormatHelper("attributeSection(", attributes, ")", attributeSection);

            attributeSection.RascalString = f.S;
        }

        public override void VisitArraySpecifier(ArraySpecifier arraySpecifier)
        {
            base.VisitArraySpecifier(arraySpecifier);
            //arraySpecifier(int dimensions)

            var attributes = new object[]
            {
                arraySpecifier.Dimensions
            };

            var f = new FormatHelper("arraySpecifier(", attributes, ")", arraySpecifier);

            arraySpecifier.RascalString = f.S;
        }

        public override void VisitVariableInitializer(VariableInitializer variableInitializer)
        {
            base.VisitVariableInitializer(variableInitializer);
            //variableInitializer(str name, 
            //                    Expression initializer)
            var attributes = new object[]
            {
                variableInitializer.Name,
                variableInitializer.Initializer
            };

            var f = new FormatHelper("variableInitializer(", attributes, ")", variableInitializer);

            variableInitializer.RascalString = f.S;
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

            var attributes = new object[]
                {
                    typeDeclaration.Name,
                    typeDeclaration.Attributes,
                    typeDeclaration.BaseTypes,
                    typeDeclaration.ClassType,
                    typeDeclaration.Constraints,
                    typeDeclaration.Members,
                    _EmptyCollection,
                    typeDeclaration.Modifiers,
                    typeDeclaration.TypeParameters
                };

            var f = new FormatHelper("typeDeclaration(", attributes, ")", typeDeclaration);

            typeDeclaration.RascalString = "attributedNode(" + f.S + ")";
        }

        public override void VisitConstructorDeclaration(ConstructorDeclaration constructorDeclaration)
        {
            base.VisitConstructorDeclaration(constructorDeclaration);
            //constructorDeclaration(str name, 
            //                      list[AstNode] attributes, 
            //                      Statement body, 
            //                      AstNode initializer, 
            //                      list[AstNode] modifierTokens, 
            //                      list[Modifiers] modifiers, 
            //                      list[AstNode] parameters)

            var attributes = new object[]
            {
                constructorDeclaration.Name,
                constructorDeclaration.Attributes,
                constructorDeclaration.Body,
                constructorDeclaration.Initializer,
                _EmptyCollection,
                constructorDeclaration.Modifiers,
                constructorDeclaration.Parameters
            };

            var f = new FormatHelper("constructorDeclaration(", attributes, ")", constructorDeclaration);

            constructorDeclaration.RascalString = f.S;
        }

        public override void VisitConstructorInitializer(ConstructorInitializer constructorInitializer)
        {
            base.VisitConstructorInitializer(constructorInitializer);
            //constructorInitializer(list[Expression] arguments, 
            //                       ConstructorInitializer constructorInitializerType)
            var attributes = new object[]
            {
                constructorInitializer.Arguments,
                constructorInitializer.ConstructorInitializerType
            };

            var f = new FormatHelper("constructorInitializer(", attributes, ")", constructorInitializer);

            constructorInitializer.RascalString = f.S;
        }

        public override void VisitAccessor(Accessor accessor)
        {
            base.VisitAccessor(accessor);
            //accessor(list[AstNode] attributes, 
            //         Statement body, 
            //         list[AstNode] modifierTokens, 
            //         list[Modifiers] modifiers)
            var attributes = new object[]
            {
                accessor.Attributes,
                accessor.Body,
                _EmptyCollection,
                accessor.Modifiers
            };

            var f = new FormatHelper("accessor(", attributes, ")", accessor);

            accessor.RascalString = f.S;
        }

        public override void VisitEnumMemberDeclaration(EnumMemberDeclaration enumMemberDeclaration)
        {
            base.VisitEnumMemberDeclaration(enumMemberDeclaration);
            //enumMemberDeclaration(str name, 
            //                      list[AstNode] attributes, 
            //                      Expression initializer, 
            //                      list[AstNode] modifierTokens, 
            //                      list[Modifiers] modifiers)
            var attributes = new object[]
            {
                enumMemberDeclaration.Name,
                enumMemberDeclaration.Attributes,
                enumMemberDeclaration.Initializer,
                _EmptyCollection,
                enumMemberDeclaration.Modifiers
            };

            var f = new FormatHelper("enumMemberDeclaration(", attributes, ")", enumMemberDeclaration);

            enumMemberDeclaration.RascalString = f.S;
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

            var attributes = new object[]
            {
                delegateDeclaration.Name,
                delegateDeclaration.Attributes,
                delegateDeclaration.Constraints,
                _EmptyCollection,
                delegateDeclaration.Modifiers,
                delegateDeclaration.Parameters,
                delegateDeclaration.TypeParameters
            };

            var f = new FormatHelper("delegateDeclaration(", attributes, ")", delegateDeclaration);
            delegateDeclaration.RascalString = f.S;
        }

        public override void VisitDestructorDeclaration(DestructorDeclaration destructorDeclaration)
        {
            base.VisitDestructorDeclaration(destructorDeclaration);
            //destructorDeclaration(str name, 
            //                      list[AstNode] attributes, 
            //                      Statement body, 
            //                      list[AstNode] modifierTokens, 
            //                      list[Modifiers] modifiers)

            var attributes = new object[]
            {
                destructorDeclaration.Name,
                destructorDeclaration.Attributes,
                destructorDeclaration.Body,
                _EmptyCollection,
                destructorDeclaration.Modifiers
            };

            var f = new FormatHelper("destructorDeclaration(", attributes, ")", destructorDeclaration);
            destructorDeclaration.RascalString = f.S;
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

            var attributes = new object[]
            {
                methodDeclaration.Name,
                methodDeclaration.Attributes,
                methodDeclaration.Body,
                methodDeclaration.Constraints,
                methodDeclaration.IsExtensionMethod,
                _EmptyCollection,
                methodDeclaration.Modifiers,
                methodDeclaration.Parameters,
                methodDeclaration.TypeParameters,
                methodDeclaration.ReturnType
            };

            var f = new FormatHelper("methodDeclaration(", attributes, ")", methodDeclaration);

            methodDeclaration.RascalString = "memberDeclaration(" + f.S + ")";
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

            var attributes = new object[]
            {
                fieldDeclaration.Variables.First().Name, //todo dit is misschien niet de goede naam..
                fieldDeclaration.Attributes,
                _EmptyCollection,
                fieldDeclaration.Modifiers,
                fieldDeclaration.Variables,
                fieldDeclaration.ReturnType
            };

            var f = new FormatHelper("fieldDeclaration(", attributes, ")", fieldDeclaration);
            fieldDeclaration.RascalString = "memberDeclaration(" + f.S + ")";
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
            var attributes = new object[]
            {
                propertyDeclaration.Name,
                propertyDeclaration.Attributes,
                propertyDeclaration.Getter,
                _EmptyCollection,
                propertyDeclaration.Modifiers,
                propertyDeclaration.Setter,
                propertyDeclaration.ReturnType
            };

            var f = new FormatHelper("propertyDeclaration(", attributes, ")", propertyDeclaration);
            propertyDeclaration.RascalString = "memberDeclaration(" + f.S + ")";
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
            var attributes = new object[]
            {
                eventDeclaration.Name,
                eventDeclaration.Attributes,
                _EmptyCollection,
                eventDeclaration.Modifiers,
                eventDeclaration.Variables,
                eventDeclaration.ReturnType
            };

            var f = new FormatHelper("eventDeclaration(", attributes, ")", eventDeclaration);
            eventDeclaration.RascalString = "memberDeclaration(" + f.S + ")"; ;
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

            var attributes = new object[]
            {
                indexerDeclaration.Name,
                indexerDeclaration.Attributes,
                indexerDeclaration.Getter,
                _EmptyCollection,
                indexerDeclaration.Modifiers,
                indexerDeclaration.Parameters,
                indexerDeclaration.Setter,
                indexerDeclaration.ReturnType
            };

            var f = new FormatHelper("indexerDeclaration(", attributes, ")", indexerDeclaration);
            indexerDeclaration.RascalString = "memberDeclaration(" + f.S + ")";
        }

        public override void VisitCustomEventDeclaration(CustomEventDeclaration customEventDeclaration)
        {
            base.VisitCustomEventDeclaration(customEventDeclaration);
            //customEventDeclaration(str name, 
            //                       AttributedNode addAccessor, 
            //                       list[AstNode] attributes, 
            //                       list[AstNode] modifierTokens, 
            //                       list[Modifiers] modifiers,
            //                       AttributedNode removeAccessor)

            var attributes = new object[]
            {
                customEventDeclaration.Name,
                customEventDeclaration.AddAccessor,
                customEventDeclaration.Attributes,
                _EmptyCollection,
                customEventDeclaration.Modifiers,
                customEventDeclaration.RemoveAccessor,
            };

            var f = new FormatHelper("customEventDeclaration(", attributes, ")", customEventDeclaration);
            customEventDeclaration.RascalString = "memberDeclaration(" + f.S + ")";
        }

        #endregion MemberDeclaration

        #region Expression

        public override void VisitAssignmentExpression(AssignmentExpression assignmentExpression)
        {
            base.VisitAssignmentExpression(assignmentExpression);
            //assignmentExpression(Expression left, 
            //                     AssignmentOperator operator, 
            //                     Expression right)


            var attributes = new object[]
            {
                assignmentExpression.Left,
                assignmentExpression.Operator,
                assignmentExpression.Right
            };

            var f = new FormatHelper("assignmentExpression(", attributes, ")", assignmentExpression);
            assignmentExpression.RascalString = f.S;
        }

        public override void VisitMemberReferenceExpression(MemberReferenceExpression memberReferenceExpression)
        {
            base.VisitMemberReferenceExpression(memberReferenceExpression);
            //memberReferenceExpression(str memberName, 
            //                          Expression target, 
            //                          list[AstType] typeArguments)
            var attributes = new object[]
            {
                memberReferenceExpression.MemberName,
                memberReferenceExpression.Target,
                memberReferenceExpression.TypeArguments
            };

            var f = new FormatHelper("memberReferenceExpression(", attributes, ")", memberReferenceExpression);
            memberReferenceExpression.RascalString = f.S;
        }

        public override void VisitThisReferenceExpression(ThisReferenceExpression thisReferenceExpression)
        {
            base.VisitThisReferenceExpression(thisReferenceExpression);
            thisReferenceExpression.RascalString = "thisReferenceExpression()" + LocationHelper.Get(thisReferenceExpression);
        }

        public override void VisitBaseReferenceExpression(BaseReferenceExpression baseReferenceExpression)
        {
            base.VisitBaseReferenceExpression(baseReferenceExpression);
            baseReferenceExpression.RascalString = "baseReferenceExpression()" + LocationHelper.Get(baseReferenceExpression);
        }

        public override void VisitNullReferenceExpression(NullReferenceExpression nullReferenceExpression)
        {
            base.VisitNullReferenceExpression(nullReferenceExpression);
            nullReferenceExpression.RascalString = "null()" + LocationHelper.Get(nullReferenceExpression);
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
            primitiveExpression.RascalString = formatter.S + LocationHelper.Get(primitiveExpression);
        }

        public override void VisitIdentifierExpression(IdentifierExpression identifierExpression)
        {
            base.VisitIdentifierExpression(identifierExpression);
            //identifierExpression(str identifier, 
            //                     list[AstType] typeArguments,
            //                     AstType \type)
            var attributes = new object[]
            {
                identifierExpression.Identifier,
                identifierExpression.TypeArguments,
            }.ToList();
            var result = resolver.Resolve(identifierExpression);
            attributes.Add(result);
            
            var f = new FormatHelper("identifierExpression(", attributes, ")", identifierExpression);
            identifierExpression.RascalString = f.S;
        }

        public override void VisitBinaryOperatorExpression(BinaryOperatorExpression binaryOperatorExpression)
        {
            base.VisitBinaryOperatorExpression(binaryOperatorExpression);
            //binaryOperatorExpression(Expression left, 
            //                         BinaryOperator operator, 
            //                         Expression right)
            var attributes = new object[]
            {
                binaryOperatorExpression.Left,
                binaryOperatorExpression.Operator,
                binaryOperatorExpression.Right
            };

            var f = new FormatHelper("binaryOperatorExpression(", attributes, ")", binaryOperatorExpression);
            binaryOperatorExpression.RascalString = f.S;
        }

        public override void VisitObjectCreateExpression(ObjectCreateExpression objectCreateExpression)
        {
            base.VisitObjectCreateExpression(objectCreateExpression);
            //objectCreateExpression(list[Expression] arguments, 
            //                       Expression initializer,
            //                       AstType type)
            var attributes = new object[]
            {
                objectCreateExpression.Arguments,
                objectCreateExpression.Initializer,
                objectCreateExpression.Type
            };
            
            var f = new FormatHelper("objectCreateExpression(", attributes, ")", objectCreateExpression);
            objectCreateExpression.RascalString = f.S;
        }

        public override void VisitArrayInitializerExpression(ArrayInitializerExpression arrayInitializerExpression)
        {
            base.VisitArrayInitializerExpression(arrayInitializerExpression);
            //arrayInitializerExpression(list[Expression] elements)
            var attributes = new object[]
            {
                arrayInitializerExpression.Elements
            };

            var f = new FormatHelper("arrayInitializerExpression(", attributes, ")", arrayInitializerExpression);
            arrayInitializerExpression.RascalString = f.S;
        }

        public override void VisitUnaryOperatorExpression(UnaryOperatorExpression unaryOperatorExpression)
        {
            base.VisitUnaryOperatorExpression(unaryOperatorExpression);

            //unaryOperatorExpression(Expression expression, 
            //                        UnaryOperator operatorU)

            var attributes = new object[]
            {
                unaryOperatorExpression.Expression,
                unaryOperatorExpression.Operator
            };

            var f = new FormatHelper("unaryOperatorExpression(", attributes, ")", unaryOperatorExpression);
            unaryOperatorExpression.RascalString = f.S;
        }

        public override void VisitQueryExpression(QueryExpression queryExpression)
        {
            base.VisitQueryExpression(queryExpression);
            //queryExpression(list[QueryClause] clauses)
            var attributes = new object[]
            {
                queryExpression.Clauses
            };

            var f = new FormatHelper("queryExpression(", attributes, ")", queryExpression);
            queryExpression.RascalString = f.S;
        }

        public override void VisitInvocationExpression(InvocationExpression invocationExpression)
        {
            base.VisitInvocationExpression(invocationExpression);
            //invocationExpression(list[Expression] arguments, 
            //                     Expression target)

            var attributes = new object[]
            {
                invocationExpression.Arguments,
                invocationExpression.Target
            };

            var f = new FormatHelper("invocationExpression(", attributes, ")", invocationExpression);
            invocationExpression.RascalString = f.S;
        }

        public override void VisitLambdaExpression(LambdaExpression lambdaExpression)
        {
            base.VisitLambdaExpression(lambdaExpression);
            //lambdaExpression(AstNode body, 
            //                 list[AstNode] parameters)
            
            var formatter = new FormatHelper("lambdaExpression(");
            formatter.AddWithComma(lambdaExpression.Body is Expression
                        ? "expression(" + ExpressionHelper.Get((Expression)lambdaExpression.Body) + ")"
                        : "statement(" + StatementHelper.Get((Statement)lambdaExpression.Body) + ")"
                        );
            formatter.Add(CollectionHelper.Get(lambdaExpression.Parameters));
            formatter.Add(")");

            lambdaExpression.RascalString = formatter.S;
        }

        public override void VisitTypeReferenceExpression(TypeReferenceExpression typeReferenceExpression)
        {
            base.VisitTypeReferenceExpression(typeReferenceExpression);
            //typeReferenceExpression(AstType \type)
            var attributes = new object[]
            {
                typeReferenceExpression.Type
            };

            var f = new FormatHelper("typeReferenceExpression(", attributes, ")", typeReferenceExpression);
            typeReferenceExpression.RascalString = f.S;
        }
   
        public override void VisitParenthesizedExpression(ParenthesizedExpression parenthesizedExpression)
        {
            base.VisitParenthesizedExpression(parenthesizedExpression);
            var attributes = new object[]
            {
                parenthesizedExpression.Expression
            };

            var f = new FormatHelper("parenthesizedExpression(", attributes, ")", parenthesizedExpression);
            parenthesizedExpression.RascalString = f.S;
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
            var attributes = new object[]
            {
                anonymousTypeCreateExpression.Initializers
            };

            var f = new FormatHelper("anonymousTypeCreateExpression(", attributes, ")", anonymousTypeCreateExpression);
            anonymousTypeCreateExpression.RascalString = f.S;
        }

        public override void VisitNamedExpression(NamedExpression namedExpression)
        {
            base.VisitNamedExpression(namedExpression);
            //namedExpression(Expression expression, 
            //                str identifier)
            var attributes = new object[]
            {
                namedExpression.Expression,
                namedExpression.Name
            };

            var f = new FormatHelper("namedExpression(", attributes, ")", namedExpression);
            namedExpression.RascalString = f.S;
        }

        public override void VisitNamedArgumentExpression(NamedArgumentExpression namedArgumentExpression)
        {
            base.VisitNamedArgumentExpression(namedArgumentExpression);
            //namedArgumentExpression(Expression expression, 
            //                        str identifier)
            var attributes = new object[]
            {
                namedArgumentExpression.Expression,
                namedArgumentExpression.Name
            };

            var f = new FormatHelper("namedArgumentExpression(", attributes, ")", namedArgumentExpression);
            namedArgumentExpression.RascalString = f.S;
        }

        public override void VisitDirectionExpression(DirectionExpression directionExpression)
        {
            base.VisitDirectionExpression(directionExpression);
            //directionExpression(Expression expression, 
            //                    FieldDirection fieldDirection)
            var attributes = new object[]
            {
                directionExpression.Expression,
                directionExpression.FieldDirection
            };

            var f = new FormatHelper("directionExpression(", attributes, ")", directionExpression);
            directionExpression.RascalString = f.S;
        }

        public override void VisitConditionalExpression(ConditionalExpression conditionalExpression)
        {
            base.VisitConditionalExpression(conditionalExpression);
            //conditionalExpression(Expression condition, Expression falseExpression, Expression trueExpression)
            var attributes = new object[]
            {
                conditionalExpression.Condition,
                conditionalExpression.FalseExpression,
                conditionalExpression.TrueExpression
            };

            var f = new FormatHelper("conditionalExpression(", attributes, ")", conditionalExpression);
            conditionalExpression.RascalString = f.S;
        }

        public override void VisitCastExpression(CastExpression castExpression)
        {
            base.VisitCastExpression(castExpression);
            //castExpression(Expression expression, AstType \type)
            var attributes = new object[]
            {
                castExpression.Expression,
                castExpression.Type
            };

            var f = new FormatHelper("castExpression(", attributes, ")", castExpression);
            castExpression.RascalString = f.S; 
        }

        public override void VisitTypeOfExpression(TypeOfExpression typeOfExpression)
        {
            base.VisitTypeOfExpression(typeOfExpression);
            //typeOfExpression(AstType \type)
            var attributes = new object[]
            {
                typeOfExpression.Type
            };

            var f = new FormatHelper("typeOfExpression(", attributes, ")", typeOfExpression);
            typeOfExpression.RascalString = f.S;
        }

        public override void VisitDefaultValueExpression(DefaultValueExpression defaultValueExpression)
        {
            base.VisitDefaultValueExpression(defaultValueExpression);
            //defaultValueExpression(AstType \type)
            var attributes = new object[]
            {
                defaultValueExpression.Type
            };

            var f = new FormatHelper("defaultValueExpression(", attributes, ")", defaultValueExpression);
            defaultValueExpression.RascalString = f.S;
        }

        public override void VisitSizeOfExpression(SizeOfExpression sizeOfExpression)
        {
            base.VisitSizeOfExpression(sizeOfExpression);
            sizeOfExpression.RascalString = "sizeOfExpression()" + LocationHelper.Get(sizeOfExpression);
        }

        public override void VisitIsExpression(IsExpression isExpression)
        {
            base.VisitIsExpression(isExpression);
            //isExpression(Expression expression, AstType \type)
            var attributes = new object[]
            {
                isExpression.Expression,
                isExpression.Type
            };

            var f = new FormatHelper("isExpression(", attributes, ")", isExpression);
            isExpression.RascalString = f.S;
        }

        public override void VisitAsExpression(AsExpression asExpression)
        {
            base.VisitAsExpression(asExpression);
            //asExpression(Expression expression, AstType \type)
            var attributes = new object[]
            {
                asExpression.Expression,
                asExpression.Type
            };

            var f = new FormatHelper("asExpression(", attributes, ")", asExpression);
            asExpression.RascalString = f.S;
        }

        public override void VisitArrayCreateExpression(ArrayCreateExpression arrayCreateExpression)
        {
            base.VisitArrayCreateExpression(arrayCreateExpression);
            //arrayCreateExpression(list[AstNode] additionalArraySpecifiers, 
            //                      list[Expression] arguments, 
            //                      Expression initializer)
            var attributes = new object[]
            {
                arrayCreateExpression.AdditionalArraySpecifiers,
                arrayCreateExpression.Arguments,
                arrayCreateExpression.Initializer
            };

            var f = new FormatHelper("arrayCreateExpression(", attributes, ")", arrayCreateExpression);
            arrayCreateExpression.RascalString = f.S;
        }

        public override void VisitCheckedExpression(CheckedExpression checkedExpression)
        {
            base.VisitCheckedExpression(checkedExpression);
            //checkedExpression(Expression expression)
            var attributes = new object[]
            {
                checkedExpression.Expression
            };

            var f = new FormatHelper("checkedExpression(", attributes, ")", checkedExpression);
            checkedExpression.RascalString = f.S;
        }

        public override void VisitUncheckedExpression(UncheckedExpression uncheckedExpression)
        {
            base.VisitUncheckedExpression(uncheckedExpression);
            //uncheckedExpression(Expression expression)
            var attributes = new object[]
            {
                uncheckedExpression.Expression
            };

            var f = new FormatHelper("uncheckedExpression(", attributes, ")", uncheckedExpression);
            uncheckedExpression.RascalString = f.S;
        }

        public override void VisitIndexerExpression(IndexerExpression indexerExpression)
        {
            base.VisitIndexerExpression(indexerExpression);
            //indexerExpression(list[Expression] arguments, Expression target)
            var attributes = new object[]
            {
                indexerExpression.Arguments,
                indexerExpression.Target
            };

            var f = new FormatHelper("indexerExpression(", attributes, ")", indexerExpression);
            indexerExpression.RascalString = f.S;
        }

        public override void VisitAnonymousMethodExpression(AnonymousMethodExpression anonymousMethodExpression)
        {
            base.VisitAnonymousMethodExpression(anonymousMethodExpression);
            //anonymousMethodExpression(Statement bodyS, 
            //                          bool hasParameterList, 
            //                          list[AstNode] parameters)
            var attributes = new object[]
            {
                anonymousMethodExpression.Body,
                anonymousMethodExpression.HasParameterList,
                anonymousMethodExpression.Parameters
            };

            var f = new FormatHelper("anonymousMethodExpression(", attributes, ")", anonymousMethodExpression);
            anonymousMethodExpression.RascalString = f.S;
        }

        public override void VisitStackAllocExpression(StackAllocExpression stackAllocExpression)
        {
            base.VisitStackAllocExpression(stackAllocExpression);
            //stackAllocExpression(Expression countExpression)
            var attributes = new object[]
            {
                stackAllocExpression.CountExpression
            };

            var f = new FormatHelper("stackAllocExpression(", attributes, ")", stackAllocExpression);
            stackAllocExpression.RascalString = f.S;
        }

        #endregion Expression

        #region Statement

        public override void VisitExpressionStatement(ExpressionStatement expressionStatement)
        {
            base.VisitExpressionStatement(expressionStatement);
            var attributes = new object[]
            {
                expressionStatement.Expression
            };

            var f = new FormatHelper("expressionStatement(", attributes, ")", expressionStatement);
            expressionStatement.RascalString = f.S;
        }

        public override void VisitBlockStatement(BlockStatement blockStatementPlaceholder)
        {
            base.VisitBlockStatement(blockStatementPlaceholder);
            //blockStatement(list[Statement] statements)
            var attributes = new object[]
            {
                blockStatementPlaceholder.Statements
            };

            var f = new FormatHelper("blockStatement(", attributes, ")", blockStatementPlaceholder);
            blockStatementPlaceholder.RascalString = f.S;
        }

        public override void VisitIfElseStatement(IfElseStatement ifElseStatement)
        {
            base.VisitIfElseStatement(ifElseStatement);
            //ifElseStatement(Expression condition, Statement falseStatement, Statement trueStatement)
            var attributes = new object[]
            {
                ifElseStatement.Condition,
                ifElseStatement.FalseStatement,
                ifElseStatement.TrueStatement
            };

            var f = new FormatHelper("ifElseStatement(", attributes, ")", ifElseStatement);
            ifElseStatement.RascalString = f.S;
        }

        public override void VisitReturnStatement(ReturnStatement returnStatement)
        {
            base.VisitReturnStatement(returnStatement);
            //returnStatement(Expression expression)
            var attributes = new object[]
            {
                returnStatement.Expression
            };

            var f = new FormatHelper("returnStatement(", attributes, ")", returnStatement);
            returnStatement.RascalString = f.S;
        }

        public override void VisitVariableDeclarationStatement(VariableDeclarationStatement variableDeclarationStatement)
        {
            base.VisitVariableDeclarationStatement(variableDeclarationStatement);
            //variableDeclarationStatement(list[Modifiers] modifiers, 
            //                             list[AstNode] variables,
            //                             AstType type)
            var attributes = new object[]
            {
                variableDeclarationStatement.Modifiers,
                variableDeclarationStatement.Variables,
                variableDeclarationStatement.Type
            };

            var f = new FormatHelper("variableDeclarationStatement(", attributes, ")", variableDeclarationStatement);
            variableDeclarationStatement.RascalString = f.S;
        }

        public override void VisitDoWhileStatement(DoWhileStatement doWhileStatement)
        {
            base.VisitDoWhileStatement(doWhileStatement);
            //doWhileStatement(Expression condition, 
            //                 Statement embeddedStatement)
            var attributes = new object[]
            {
                doWhileStatement.Condition,
                doWhileStatement.EmbeddedStatement
            };

            var f = new FormatHelper("doWhileStatement(", attributes, ")", doWhileStatement);
            doWhileStatement.RascalString = f.S;
        }

        public override void VisitContinueStatement(ContinueStatement continueStatement)
        {
            base.VisitContinueStatement(continueStatement);
            continueStatement.RascalString = "continueStatement()" + LocationHelper.Get(continueStatement);
        }

        public override void VisitForeachStatement(ForeachStatement foreachStatement)
        {
            base.VisitForeachStatement(foreachStatement);
            //foreachStatement(Statement embeddedStatement, 
            //                 Expression inExpression, 
            //                 str variableName)
            var attributes = new object[]
            {
                foreachStatement.EmbeddedStatement,
                foreachStatement.InExpression,
                foreachStatement.VariableName
            };

            var f = new FormatHelper("foreachStatement(", attributes, ")", foreachStatement);
            foreachStatement.RascalString = f.S;
        }

        public override void VisitForStatement(ForStatement forStatement)
        {
            base.VisitForStatement(forStatement);
            //forStatement(Expression condition, 
            //             Statement embeddedStatement, 
            //             list[Statement] initializers, 
            //             list[Statement] iterators)
            var attributes = new object[]
            {
                forStatement.Condition,
                forStatement.EmbeddedStatement,
                forStatement.Initializers,
                forStatement.Iterators
            };

            var f = new FormatHelper("forStatement(", attributes, ")", forStatement);
            forStatement.RascalString = f.S;
        }

        public override void VisitThrowStatement(ThrowStatement throwStatement)
        {
            base.VisitThrowStatement(throwStatement);
            //throwStatement(Expression expression)
            var attributes = new object[]
            {
                throwStatement.Expression
            };

            var f = new FormatHelper("throwStatement(", attributes, ")", throwStatement);
            throwStatement.RascalString = f.S;
        }

        public override void VisitLockStatement(LockStatement lockStatement)
        {
            base.VisitLockStatement(lockStatement);
            //lockStatement(Statement embeddedStatement, 
            //              Expression expression)
            var attributes = new object[]
            {
                lockStatement.EmbeddedStatement,
                lockStatement.Expression
            };

            var f = new FormatHelper("lockStatement(", attributes, ")", lockStatement);
            lockStatement.RascalString = f.S;
        }

        public override void VisitUsingStatement(UsingStatement usingStatement)
        {
            base.VisitUsingStatement(usingStatement);
            //usingStatement(AstNode resourceAcquisition,
            //               Statement embeddedStatement)
          
            var formatter = new FormatHelper("usingStatement(");
            formatter.AddWithComma(usingStatement.ResourceAcquisition is Expression
                        ? "expression(" + ExpressionHelper.Get((Expression)usingStatement.ResourceAcquisition) + ")"
                        : "statement(" + StatementHelper.Get((Statement)usingStatement.ResourceAcquisition) + ")"
                        );
            formatter.Add(StatementHelper.Get(usingStatement.EmbeddedStatement));
            formatter.Add(")");

            usingStatement.RascalString = formatter.S;
        }

        public override void VisitWhileStatement(WhileStatement whileStatement)
        {
            base.VisitWhileStatement(whileStatement);
            //whileStatement(Expression condition, 
            //               Statement embeddedStatement)
            var attributes = new object[]
            {
                whileStatement.Condition,
                whileStatement.EmbeddedStatement
            };

            var f = new FormatHelper("whileStatement(", attributes, ")", whileStatement);
            whileStatement.RascalString = f.S;
        }

        public override void VisitFixedStatement(FixedStatement fixedStatement)
        {
            base.VisitFixedStatement(fixedStatement);
            //fixedStatement(Statement embeddedStatement, list[AstNode] variables)
            var attributes = new object[]
                {
                    fixedStatement.EmbeddedStatement,
                    fixedStatement.Variables
                };

            var f = new FormatHelper("fixedStatement(", attributes, ")", fixedStatement);
            fixedStatement.RascalString = f.S;
        }

        public override void VisitUnsafeStatement(UnsafeStatement unsafeStatement)
        {
            base.VisitUnsafeStatement(unsafeStatement);
            //unsafeStatement(Statement body)
            var attributes = new object[]
            {
                unsafeStatement.Body
            };

            var f = new FormatHelper("unsafeStatement(", attributes, ")", unsafeStatement);
            unsafeStatement.RascalString = f.S;
        }

        public override void VisitCheckedStatement(CheckedStatement checkedStatement)
        {
            base.VisitCheckedStatement(checkedStatement);
            //checkedStatement(Statement body);
            var attributes = new object[]
            {
                checkedStatement.Body
            };

            var f = new FormatHelper("checkedStatement(", attributes, ")", checkedStatement);
            checkedStatement.RascalString = f.S;
        }

        public override void VisitUncheckedStatement(UncheckedStatement uncheckedStatement)
        {
            base.VisitUncheckedStatement(uncheckedStatement);
            //uncheckedStatement(Statement body)
            var attributes = new object[]
            {
                uncheckedStatement.Body
            };

            var f = new FormatHelper("uncheckedStatement(", attributes, ")", uncheckedStatement);
            uncheckedStatement.RascalString = f.S;
        }

        #region Yield
        public override void VisitYieldReturnStatement(YieldReturnStatement yieldStatement)
        {
            base.VisitYieldReturnStatement(yieldStatement);
            //yieldStatement(Expression expression)
            var attributes = new object[]
            {
                yieldStatement.Expression
            };

            var f = new FormatHelper("yieldStatement(", attributes, ")", yieldStatement);
            yieldStatement.RascalString = f.S;
        }

        public override void VisitYieldBreakStatement(YieldBreakStatement yieldBreakStatement)
        {
            base.VisitYieldBreakStatement(yieldBreakStatement);

            //yieldBreakStatement()

            yieldBreakStatement.RascalString = "yieldBreakStatement()" + LocationHelper.Get(yieldBreakStatement);
        }

        #endregion Yield

        #region SwitchCase
        public override void VisitSwitchStatement(SwitchStatement switchStatement)
        {
            base.VisitSwitchStatement(switchStatement);
            //switchStatement(Expression expression, 
            //                list[AstNode] switchSections)
            var attributes = new object[]
            {
                switchStatement.Expression,
                switchStatement.SwitchSections
            };

            var f = new FormatHelper("switchStatement(", attributes, ")", switchStatement);
            switchStatement.RascalString = f.S;
        }

        public override void VisitSwitchSection(SwitchSection switchSection)
        {
            base.VisitSwitchSection(switchSection);
            //switchSection(list[AstNode] caseLabels, 
            //              list[Statement] statements)
            var attributes = new object[]
            {
                switchSection.CaseLabels,
                switchSection.Statements
            };

            var f = new FormatHelper("switchSection(", attributes, ")", switchSection);
            switchSection.RascalString = f.S;
        }

        public override void VisitCaseLabel(CaseLabel caseLabel)
        {
            base.VisitCaseLabel(caseLabel);
            //caseLabel(Expression expression)
            var attributes = new object[]
            {
                caseLabel.Expression
            };

            var f = new FormatHelper("caseLabel(", attributes, ")", caseLabel);
            caseLabel.RascalString = f.S;
        }

        public override void VisitBreakStatement(BreakStatement breakStatement)
        {
            base.VisitBreakStatement(breakStatement);

            breakStatement.RascalString = "breakStatement()" + LocationHelper.Get(breakStatement);
        }
        #endregion SwitchCase

        #region TryCatch

        public override void VisitTryCatchStatement(TryCatchStatement tryCatchStatement)
        {
            base.VisitTryCatchStatement(tryCatchStatement);
            //tryCatchStatement(list[AstNode] catchClauses, 
            //                  Statement finallyBlock, 
            //                  Statement tryBlock)
            var attributes = new object[]
            {
                tryCatchStatement.TryBlock,
                tryCatchStatement.CatchClauses,
                tryCatchStatement.FinallyBlock,
            };

            var f = new FormatHelper("tryCatchStatement(", attributes, ")", tryCatchStatement);
            tryCatchStatement.RascalString = f.S;
        }

        public override void VisitCatchClause(CatchClause catchClause)
        {
            base.VisitCatchClause(catchClause);
            //catchClause(Statement body, 
            //            str variableName,
            //            AstType \type)
            var attributes = new List<object>()
            {
                catchClause.Body,
                catchClause.VariableName,
                catchClause.Type                
            };

            var f = new FormatHelper("catchClause(", attributes, ")", catchClause);
            catchClause.RascalString = f.S;
        }

        #endregion TryCatch

        #endregion Statement

        #region QueryCause

        public override void VisitQueryContinuationClause(QueryContinuationClause queryContinuationClause)
        {
            base.VisitQueryContinuationClause(queryContinuationClause);
            //queryContinuationClause(str identifier, Expression precedingQuery)
            var attributes = new object[]
            {
                queryContinuationClause.Identifier,
                queryContinuationClause.PrecedingQuery
            };

            var f = new FormatHelper("queryContinuationClause(", attributes, ")", queryContinuationClause);
            queryContinuationClause.RascalString = f.S;
        }

        public override void VisitQueryWhereClause(QueryWhereClause queryWhereClause)
        {
            base.VisitQueryWhereClause(queryWhereClause);
            //queryWhereClause(Expression condition)
            var attributes = new object[]
            {
                queryWhereClause.Condition
            };

            var f = new FormatHelper("queryWhereClause(", attributes, ")", queryWhereClause);
            queryWhereClause.RascalString = f.S;
        }

        public override void VisitQueryGroupClause(QueryGroupClause queryGroupClause)
        {
            base.VisitQueryGroupClause(queryGroupClause);
            //queryGroupClause(Expression key, 
            //                 Expression projection)
            var attributes = new object[]
            {
                queryGroupClause.Key,
                queryGroupClause.Projection
            };

            var f = new FormatHelper("queryGroupClause(", attributes, ")", queryGroupClause);
            queryGroupClause.RascalString = f.S;
        }

        public override void VisitQueryOrderClause(QueryOrderClause queryOrderClause)
        {
            base.VisitQueryOrderClause(queryOrderClause);
            //queryOrderClause(list[AstNode] orderings)
            var attributes = new object[]
            {
                queryOrderClause.Orderings
            };

            var f = new FormatHelper("queryOrderClause(", attributes, ")", queryOrderClause);
            queryOrderClause.RascalString = f.S;
        }

        public override void VisitQuerySelectClause(QuerySelectClause querySelectClause)
        {
            base.VisitQuerySelectClause(querySelectClause);
            //querySelectClause(Expression expression)
            var attributes = new object[]
            {
                querySelectClause.Expression
            };

            var f = new FormatHelper("querySelectClause(", attributes, ")", querySelectClause);
            querySelectClause.RascalString = f.S;
        }

        public override void VisitQueryLetClause(QueryLetClause queryLetClause)
        {
            base.VisitQueryLetClause(queryLetClause);
            //queryLetClause(Expression expression, str identifier)
            var attributes = new object[]
            {
                queryLetClause.Expression,
                queryLetClause.Identifier
            };

            var f = new FormatHelper("queryLetClause(", attributes, ")", queryLetClause);
            queryLetClause.RascalString = f.S;
        }

        public override void VisitQueryFromClause(QueryFromClause queryFromClause)
        {
            base.VisitQueryFromClause(queryFromClause);
            //queryFromClause(Expression expression, str identifier)
            var attributes = new object[]
                {
                    queryFromClause.Expression,
                    queryFromClause.Identifier
                };

            var f = new FormatHelper("queryFromClause(", attributes, ")", queryFromClause);
            queryFromClause.RascalString = f.S;
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
            var attributes = new object[]
            {
                queryJoinClause.EqualsExpression,
                queryJoinClause.InExpression,
                queryJoinClause.IntoIdentifier,
                queryJoinClause.IsGroupJoin,
                queryJoinClause.JoinIdentifier,
                queryJoinClause.OnExpression
            };

            var f = new FormatHelper("queryJoinClause(", attributes, ")", queryJoinClause);
            queryJoinClause.RascalString = f.S;
        }

        public override void VisitQueryOrdering(QueryOrdering queryOrdering)
        {
            base.VisitQueryOrdering(queryOrdering);
            //queryOrdering(QueryOrderingDirection direction, 
            //              Expression expression)
            var attributes = new object[]
            {
                queryOrdering.Direction,
                queryOrdering.Expression
            };

            var f = new FormatHelper("queryOrdering(", attributes, ")", queryOrdering);
            queryOrdering.RascalString = f.S;
        }

        #endregion QueryCause

    }
}
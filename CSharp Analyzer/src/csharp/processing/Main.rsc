module csharp::processing::Main

import Type;
import IO;

import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import lang::java::jdt::Java;

import csharp::processing::Globals;
import csharp::processing::astnode::AttributedNode;
import csharp::syntax::CSharpSyntax;
import csharp::reader::FileInput;

public void Start()
{
	InitGlobals();
	
	CSharpProject project = readCSharpProject();
	
	for(file <- project)
	{
		for(astnode <- file.contents)
		{
			if(astnode is usingDeclaration)
			{
				relFileUsing += <file,astnode>;
			}
			else if(astnode is namespaceDeclaration)
			{
				namespace = astnode;
				relFileNamespace += <file,namespace>;
								
				for(member <- namespace.members)
				{
					relNamespaceAttributedNode += <namespace,member>;
					if(member is attributedNode)
					{
						HandleAttributedNode(astNodePlaceholder(), member);
					}
				}
				
			}
		}
	}
	//ReadRelations();
}
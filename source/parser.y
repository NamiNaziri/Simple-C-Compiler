%code requires {
	typedef struct tnode {
		const char * reg;
	} ExpNode;

	#include "Env.hpp"
}


%{
	#include <stdio.h>
	#include <stdlib.h>

	#include <string>
	#include <cstring>
	#include <math.h>
	#include <fstream>
	#include <vector>
	#include <stack>
	#include <set>
	#include "mips.hpp"
	#include "registerManager.hpp"
	#include "stackManager.hpp"

	
	using std::vector;
	using std::stack;
	using std::string;
	using std::ofstream;
	using std::set;

	


	extern FILE* yyin;
	extern int lineNumber;
	extern int preCharNumber;
	extern int currentCharNumber;

	int yylex();
	void yyerror(char const *s);
	void SemanticError(string massage);

	stack<string> endIfStack;
	stack<string> loopStack;
	int argsNum = 0;
	vector<Symbol*> argsVector;
	vector<ExpNode> callArgsVector;
	map<string ,FunctionMetaData> functionsMap;
	stack<FunctionMetaData*> functionStack;
	vector<int> casesValue;


	bool functionHasReturn = false;
	

	MIPSCodeGenerator cg;
	RegisterManager rm;
	StackManager sm(&cg);
	Env * globalEnv;
	Env * currentEnv;

	

	string currentBlock = "global"; // todo delete
	string nextBlockName = "";
	int blockCounter = 0;
	int rememberElseIfLineNumber;
	int frameOffset = 0;
	
%}

%union {
	int intType;
	char charType;
	char* strType;
	ExpNode expNode;
}

%type <intType> Start
%type <expNode> Exp
%type <expNode> ForCondition
%type <expNode> FunctionCall
%type <strType> Declaration
%type <intType> Type
%type <expNode>FunctionCallInput
%type <intType> Value 

%token <intType> TOKEN_INT
%token <intType> TOKEN_CHAR
%token <intType> TOKEN_CHAR_CONST
%token <intType> TOKEN_IF
%token <intType> TOKEN_ELSE
%token <intType> TOKEN_ELSE_IF
%token <intType> TOKEN_WHILE
%token <intType> TOKEN_CONTINUE
%token <intType> TOKEN_BREAK
%token <intType> TOKEN_FOR
%token <intType> TOKEN_RETURN
%token <intType> TOKEN_VOID
%token <strType> TOKEN_MAIN
%token <intType> TOKEN_SWITCH
%token <intType> TOKEN_CASE
%token <intType> TOKEN_DEFAULT
%token <intType> TOKEN_COLON
%token <strType> TOKEN_IDENTIFIER
%token <intType> TOKEN_INT_CONST

%token <intType> TOKEN_SHARP
%token <intType> TOKEN_LESS
%token <intType> TOKEN_MORE
%token <intType> TOKEN_LESS_EQU
%token <intType> TOKEN_MORE_EQU
%token <intType> TOKEN_EQUALS
%token <intType> TOKEN_NOT_EQUALS
%token <intType> TOKEN_BIT_OR
%token <intType> TOKEN_BIT_AND
%token <intType> TOKEN_OR
%token <intType> TOKEN_AND
%token <intType> TOKEN_XOR
%token <intType> TOKEN_NOT
%token <intType> TOKEN_PLUS
%token <intType> TOKEN_MINUS
%token <intType> TOKEN_MULTIPLY
%token <intType> TOKEN_DIV
%token <intType> TOKEN_ASSIGN

%token <intType> TOKEN_LEFT_PAREN
%token <intType> TOKEN_RIGHT_PAREN
%token <intType> TOKEN_LEFT_BRAK
%token <intType> TOKEN_RIGHT_BRAK
%token <intType> TOKEN_COMMA
%token <intType> TOKEN_DOT
%token <intType> ERROR


%nterm <strType> FuncName




%start Start
%left TOKEN_COMMA
%left TOKEN_ASSIGN
%left TOKEN_AND TOKEN_OR
%left TOKEN_BIT_AND TOKEN_BIT_OR TOKEN_XOR
%left TOKEN_EQUALS TOKEN_NOT_EQUALS 
%nonassoc TOKEN_LESS TOKEN_LESS_EQU
%nonassoc TOKEN_MORE TOKEN_MORE_EQU
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_MULTIPLY TOKEN_DIV
%right TOKEN_NOT
%left TOKEN_LEFT_BRAK TOKEN_RIGHT_BRAK
%left TOKEN_LEFT_PAREN TOKEN_RIGHT_PAREN



%%
Start : %empty {globalEnv = new Env(); currentEnv=globalEnv;}
		| Start Function {;}
		| Start  Global {;}
		;

Global : GlobalAssignmentDeclaration TOKEN_DOT	{;}
		| Declaration TOKEN_DOT				{;}
		;

GlobalAssignmentDeclaration : Type TOKEN_IDENTIFIER TOKEN_ASSIGN Value 

		{

			Symbol s;
				s.id = string($2);
				s.dType = static_cast<DataType>($1);
			if(!currentEnv->addSymbol(s)){
				SemanticError(string("Variable")+" \'"+string($2)+"\' variable redefinition");
			}
			auto sym = currentEnv->getSymbol($2);
			sym->isGlobal = true;
			cg.allocateGlobalVriable(string($2), $4);

		;}
Value: 	TOKEN_INT_CONST{ $$ = $1;}
		| TOKEN_CHAR_CONST { $$ = $1;}

Function : 	Type
			FuncName
			{

				argsNum = 0;
				if((functionNameSet.find(string($2)) != functionNameSet.end()) || (identifierNameSet.find(string($2)) != identifierNameSet.end()))	
				{
					
					SemanticError( string($2) +" Conflicts with another function or identifier");
				}
				else
				{
					functionNameSet.insert(string($2));
				}

				
				functionHasReturn = false;
				currentBlock = $2;
				cg.add_label(currentBlock);
				sm.initCallee();
				currentEnv = new Env(currentEnv);
			}
			TOKEN_LEFT_PAREN
			FuncParamsList
			TOKEN_RIGHT_PAREN
			{

				FunctionMetaData* meta = new FunctionMetaData();
				meta->name = string($2);
				meta->args = argsVector;
				argsVector.clear();
				meta->argsNum = argsNum;
				argsNum = 0;
				meta->output = static_cast<DataType>($1);
				functionsMap[meta->name] = (*meta);

				functionStack.push(meta);

				if(meta->argsNum > 3)
				{
					SemanticError("Maximum number of arguments is 3.");
				}

				
				for(int i = 0 ; i < meta->argsNum ; i++)
				{
					
					cg.sw("fp",("$a" + std::to_string(i)).c_str(),meta->args[i]->address);
				}
				
			}
			TOKEN_LESS
			
			Statements
			
			TOKEN_MORE
			{
				

				auto funcType = static_cast<DataType>($1);
				if(funcType!= DataType::VOID && functionHasReturn == false)
				{
					SemanticError("Non-void functions must have return value");
				}
				functionStack.pop();
				
				functionHasReturn = false;
				sm.endCallee();
				currentEnv = currentEnv->base;
				
			}
			;
Type : TOKEN_INT					{$$ = DataType::INT;}
				| TOKEN_CHAR		{$$ = DataType::CHAR;}
				| TOKEN_VOID		{$$ = DataType::VOID;}
				;
FuncName :    TOKEN_IDENTIFIER 	{$$ = $1;}
			| TOKEN_MAIN 		{$$ = $1;}
FuncParamsList : %empty					{;}
				| FunctionParams		{;}
				;
FunctionParams :  Declaration
				{
					argsVector.insert(argsVector.begin(), 1, currentEnv->getSymbol(string($1)));
					argsNum++;
					
				}
				| Declaration TOKEN_COMMA FunctionParams 
				{
					argsVector.insert(argsVector.begin(), 1, currentEnv->getSymbol(string($1)));
					argsNum++;
				}
				;

Block : TOKEN_LESS {

										/* It is not necessary to label items here : no other usage*/
										if(nextBlockName != "")
										{
											currentBlock = nextBlockName;
											nextBlockName = "";
										}
										else
										{
											currentBlock = "_Block" + std::to_string(++blockCounter);;
										}
										
										cg.add_label(currentBlock);
										/**/
										currentEnv = new Env(currentEnv);
									}
									Statements TOKEN_MORE 
									{currentEnv = currentEnv->base;}
									
Statements : %empty							{;}
			| Statements Statement			{;}
			;
Statement : TOKEN_DOT   					{;}
			| FunctionCall TOKEN_DOT 		{;}
			| Conditional					{;}
			| Declaration TOKEN_DOT			{;}
			| AssignmentDeclaration TOKEN_DOT  {;}
			| ReturnStatement TOKEN_DOT		  {;}
			| Block							  	
			| TOKEN_BREAK TOKEN_DOT {cg.j(loopStack.top() + "_END");}
			| TOKEN_CONTINUE TOKEN_DOT{
				
				
				stack<string> tempLoopStack = loopStack;
				while(tempLoopStack.size() > 0 && tempLoopStack.top()[0] == 'S')
				{
					tempLoopStack.pop();
				}
				if(tempLoopStack.size() == 0)
				{
					SemanticError("Continue statement without outer loop");
				}


				cg.j( tempLoopStack.top() + "_START");}
			| Assignment TOKEN_DOT
			;

ReturnStatement : TOKEN_RETURN Exp 			{ 

						
						if(functionStack.top()->output != DataType::VOID )
						{
							functionHasReturn = true;
							cg.move("$v0",$2.reg);
							rm.freeRegister($2.reg);
							sm.endCallee();
						}
						else
						{
							SemanticError("Cannot return value from void function.");
						}
	
					;}
		|TOKEN_RETURN{
					
					if(functionStack.top()->output != DataType::VOID )
					{
						
						SemanticError("Cannot return without value from non-void function.");
					}
					else
					{
						functionHasReturn = true;
						sm.endCallee();
					}
			
			;}
		;

FunctionCall:
		FuncName
		TOKEN_LEFT_PAREN
		FunctionCallList
		TOKEN_RIGHT_PAREN
		{
			FunctionMetaData fMetaData = functionsMap[string($1)];

			if(fMetaData.argsNum != callArgsVector.size())
			{
				SemanticError("Function call has wrong number of parameteres.");
			}

			for(int i = 0 ; i < callArgsVector.size() ; i++)
			{
				cg.move(("$a" + std::to_string(i)).c_str(), callArgsVector[i].reg);
				rm.freeRegister(callArgsVector[i].reg);
			}
			callArgsVector.clear();

			sm.initCaller(string($1));
			sm.endCaller();
		}
		;
FunctionCallList :  %empty					{;}
					| FunctionCallInputs 	{;}
		;
FunctionCallInputs : FunctionCallInput { callArgsVector.insert(callArgsVector.begin(), 1, $1);}
					|FunctionCallInput TOKEN_COMMA FunctionCallInputs{ callArgsVector.insert(callArgsVector.begin(), 1, $1);}
		;
FunctionCallInput : Exp {$$ = $1;}
		;

Exp :  TOKEN_INT_CONST						{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.li(node.reg,$1);}
		| TOKEN_CHAR_CONST					{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.li(node.reg,$1);}
		| TOKEN_IDENTIFIER					{
												auto sym = currentEnv->getSymbol($1);
												if(sym == NULL)
												{
													SemanticError(string("Variable \'") + $1 +"\' is not defined");
												}

												ExpNode node;
												node.reg = rm.findFreeTempRegister();
												$$=node;
												// Address -> register
												if(sym->isGlobal)
												{
													cg.lw(node.reg,sym->id);
												}
												else
												{
													cg.lw("$fp" , node.reg,sym->address);
												}
												
											}
		| TOKEN_IDENTIFIER TOKEN_LEFT_BRAK Exp TOKEN_RIGHT_BRAK
											{
												
												auto sym = currentEnv->getSymbol($1);
												if(sym == NULL)
												{
													SemanticError(string("Variable \'") + $1 +"\' is not defined");
												}
												if(sym->length == 0)
												{
													SemanticError("variable " + string($1)+ " is not array but it is used as an array.");
												}

												ExpNode node;
												node.reg = rm.findFreeTempRegister();
												
												// Address -> register
												if(sym->isGlobal)
												{
													const char* tempReg = rm.findFreeTempRegister();
													cg.li(tempReg, 4);
													cg.mul($3.reg,$3.reg,tempReg);
													cg.la(tempReg,sym->id);
													cg.add(tempReg,$3.reg,tempReg);
													
													
													cg.lw(tempReg,node.reg,0);
													rm.freeRegister($3.reg);
													rm.freeRegister(tempReg);
												}
												else
												{
													const char* tempReg = rm.findFreeTempRegister();
													cg.li(tempReg, -4);
													cg.mul($3.reg,$3.reg,tempReg);
													cg.addi($3.reg,$3.reg,sym->address);
													cg.add($3.reg,$3.reg,"$fp");
													cg.lw($3.reg,node.reg,0);

													rm.freeRegister($3.reg);
													rm.freeRegister(tempReg);
												}
												$$=node;
											}
		| TOKEN_PLUS TOKEN_INT_CONST 		{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.li(node.reg,$2);}
		| TOKEN_MINUS TOKEN_INT_CONST 		{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.li(node.reg,-$2);}
		| Exp TOKEN_PLUS Exp				{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.add(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_MINUS Exp				{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.sub(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_MULTIPLY Exp			{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.mul(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_DIV Exp					{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.div($1.reg,$3.reg);cg.divQ(node.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_LESS Exp				{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.slt(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_LESS_EQU Exp			{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.sle(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_MORE Exp				{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.sgt(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_MORE_EQU Exp			{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.sge(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_EQUALS Exp				{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.seq(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_NOT_EQUALS Exp			{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.sne(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_OR Exp					{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; const char * b1 = rm.findFreeTempRegister();  const char * b3 = rm.findFreeTempRegister();  cg.slt(b1 , "$zero" , $1.reg); cg.slt(b3 , "$zero" , $3.reg);  rm.freeRegister($1.reg);rm.freeRegister($3.reg); cg._or(node.reg,b1,b3); rm.freeRegister(b1);rm.freeRegister(b3);}
		| Exp TOKEN_AND Exp					{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; const char * b1 = rm.findFreeTempRegister();  const char * b3 = rm.findFreeTempRegister();  cg.slt(b1 , "$zero" , $1.reg); cg.slt(b3 , "$zero" , $3.reg);  rm.freeRegister($1.reg);rm.freeRegister($3.reg); cg._and(node.reg,b1,b3); rm.freeRegister(b1);rm.freeRegister(b3);}
		| Exp TOKEN_XOR Exp					{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg._xor(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_BIT_OR Exp				{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg._or(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| Exp TOKEN_BIT_AND Exp				{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg._and(node.reg,$1.reg,$3.reg);rm.freeRegister($1.reg);rm.freeRegister($3.reg);}
		| TOKEN_NOT Exp 					{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.sub(node.reg,"$zero",$2.reg);rm.freeRegister($2.reg);}
		| TOKEN_LEFT_PAREN Exp TOKEN_RIGHT_PAREN {$$ = $2;}
		| TOKEN_MINUS TOKEN_LEFT_PAREN Exp TOKEN_RIGHT_PAREN {ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node; cg.sub(node.reg,"$zero",$3.reg);rm.freeRegister($3.reg);}
		| TOKEN_PLUS TOKEN_LEFT_PAREN Exp TOKEN_RIGHT_PAREN {$$ = $3;}
		| FunctionCall						{ExpNode node; node.reg = rm.findFreeTempRegister();$$=node;cg.move(node.reg,"$v0");}
		;

Conditional : {endIfStack.push("IF_" + to_string(lineNumber+1));} ConditionalIf {cg.add_label(endIfStack.top() + "_END"); endIfStack.pop();}
			| {loopStack.push("WHILE_" + to_string(lineNumber+1));} ConditionalWhile {cg.add_label(loopStack.top()+"_END" ); loopStack.pop();}
			| {currentEnv = new Env(currentEnv);} ConditionalFor {currentEnv = currentEnv->base;}
			| ConditionalSwitch
			;

ConditionalIf : TOKEN_IF  TOKEN_LEFT_PAREN Exp {cg.beq($3.reg,"$zero" , endIfStack.top() + "_NEXT"); rm.freeRegister($3.reg);} TOKEN_RIGHT_PAREN Block {cg.j(endIfStack.top()+"_END");} {cg.add_label(endIfStack.top() + "_NEXT");} ElseIfs Else
			;
ElseIfs : 	%empty			{;}
			| TOKEN_ELSE_IF TOKEN_LEFT_PAREN Exp {rememberElseIfLineNumber = lineNumber;cg.beq($3.reg,"$zero" , endIfStack.top() + "_NEXT_" + to_string(lineNumber));rm.freeRegister($3.reg);} TOKEN_RIGHT_PAREN Block {cg.j(endIfStack.top()+"_END");cg.add_label(endIfStack.top() + "_NEXT_" + to_string(rememberElseIfLineNumber));} ElseIfs 
			;
Else : 	%empty					{;}
		| TOKEN_ELSE Block		{;}
		;
ConditionalWhile : TOKEN_WHILE TOKEN_LEFT_PAREN {cg.add_label(loopStack.top() + "_START"  );} Exp {cg.beq($4.reg , "$zero" , ( loopStack.top() + "_END"  ).c_str() ); rm.freeRegister($4.reg); } TOKEN_RIGHT_PAREN Block {cg.j( loopStack.top()+"_START"  ); }
		;

ConditionalFor : TOKEN_FOR TOKEN_LEFT_PAREN ForDeclaration TOKEN_SHARP {loopStack.push("FOR_" + to_string(lineNumber+1)); cg.add_label(loopStack.top()+"_INIT"); } ForCondition {cg.j(loopStack.top()+"_CONDITION");}TOKEN_SHARP {cg.add_label(loopStack.top()+"_START");}ForStep{cg.j(loopStack.top()+"_INIT");} {cg.add_label(loopStack.top()+"_CONDITION");cg.beq($6.reg , "$zero" , loopStack.top()+"_END"); rm.freeRegister($6.reg);} TOKEN_RIGHT_PAREN TOKEN_LESS Statements TOKEN_MORE {cg.j(loopStack.top()+"_STAR");cg.add_label(loopStack.top()+"_END");loopStack.pop();}
		;
ForDeclaration :	%empty			{;}
 					| AssignmentDeclaration 	{;}
					| Assignment	{;}
		;
ForCondition : 	%empty				{ExpNode node; node.reg = rm.findFreeTempRegister(); $$=node;cg.li(node.reg , 1);}
				| Exp 				{$$ = $1;}
		;
ForStep : 	%empty					{;}
			 | Assignment			{;}
		;

ConditionalSwitch : TOKEN_SWITCH {loopStack.push("SWITCH_" + to_string(lineNumber+1));} TOKEN_LEFT_PAREN Exp {cg.j(loopStack.top() + "_CHECK");} TOKEN_RIGHT_PAREN TOKEN_LESS SwitchCases TOKEN_MORE {
	
	cg.add_label(loopStack.top() + "_CHECK");
	
	for(int i = 0 ; i < casesValue.size() ; i++)
	{
		const char* reg = rm.findFreeTempRegister(); 
		cg.li(reg,casesValue[i]);
		cg.beq($4.reg,reg,loopStack.top()+"_"+to_string(i));
		rm.freeRegister(reg);
	}
	rm.freeRegister($4.reg);
	cg.j(loopStack.top() + "_DEF");
	cg.add_label(loopStack.top() + "_END");
	loopStack.pop();
	}
		;

SwitchCases : NormalCases {cg.add_label(loopStack.top()+"_DEF");}DefaultCase {cg.j(loopStack.top() + "_END");}
		;

NormalCases : %empty 
			| NormalCases TOKEN_CASE TOKEN_INT_CONST{casesValue.push_back($3);} TOKEN_COLON{cg.add_label(loopStack.top()+"_" + to_string(casesValue.size() - 1));} Statements CaseBREAK
			;
DefaultCase : %empty
			| TOKEN_DEFAULT TOKEN_COLON Statements CaseBREAK
			;

CaseBREAK : %empty
			| TOKEN_BREAK TOKEN_SHARP {cg.j(loopStack.top() + "_END");}



Declaration : Type TOKEN_IDENTIFIER
					{	
						if($1 == DataType::VOID)
						{
							SemanticError(string("Variable")+" \'"+string($2)+"\' "+"with void type is not valid");
						}

						Symbol s;
						s.id = $2;
						s.dType = static_cast<DataType>($1);
						s.length = 0;
						if(currentEnv->base == NULL) // This is a global variable
						{
							s.isGlobal = true;
							
							cg.allocateGlobalVriable(string($2),0);
						}
						else
						{
							s.isGlobal = false;
							s.address = sm.push("$zero");
						}
						
						if(!currentEnv->addSymbol(s))
						{
							SemanticError(string("Variable")+" \'"+string($2)+"\' variable redefinition");
						}
						$$ = $2;
					}
		| Type TOKEN_IDENTIFIER TOKEN_LEFT_BRAK TOKEN_INT_CONST TOKEN_RIGHT_BRAK

				{
					if($1 == DataType::VOID)
						{
							SemanticError(string("Variable")+" \'"+string($2)+"\' "+"with void type is not valid");
						}
					if($4 <= 0)
					{
						SemanticError("the length of an array must be greater than zero");
					}

					Symbol s;
					s.id = $2;
					s.dType = static_cast<DataType>($1);
					s.length = $4;
					if(currentEnv->base == NULL) // This is a global variable
					{
						s.isGlobal = true;
						cg.allocateGlobalArray(string($2),$4);
					}
					else
					{
						s.isGlobal = false;
						s.address = sm.allocateWords($4);
					}
					
					if(!currentEnv->addSymbol(s))
					{
						SemanticError(string("Variable")+" \'"+string($2)+"\' variable redefinition");
					}
					$$ = $2;

				}
		;
AssignmentDeclaration : Type TOKEN_IDENTIFIER TOKEN_ASSIGN Exp	
				 	{
						 if($1 == DataType::VOID)
						{
							SemanticError(string("Variable")+" \'"+string($2)+"\' "+"with void type is not valid");
						}
						Symbol s;
						s.id = string($2);
						s.dType = static_cast<DataType>($1);
						if(!currentEnv->addSymbol(s)){
							SemanticError(string("Variable")+" \'"+string($2)+"\' variable redefinition");
						}
						auto sym = currentEnv->getSymbol($2);

						s.isGlobal = false;
						sym->address = sm.push($4.reg);
						
						
						rm.freeRegister($4.reg);
					}
					


		;

Assignment :  TOKEN_IDENTIFIER TOKEN_ASSIGN Exp	
					{
						auto sym = currentEnv->getSymbol(string($1));
						if(sym == NULL){
							SemanticError("Symbol \'"+ string($1)+"\' not found.");
						}

						if(sym->isGlobal)
						{

							const char * reg = rm.findFreeTempRegister();
							cg.la(reg,sym->id);
							cg.sw(reg,$3.reg,0);
							rm.freeRegister(reg);
						}
						else
						{
							cg.sw("$fp",$3.reg,sym->address);
						}

						rm.freeRegister($3.reg);

					}
				|

				TOKEN_IDENTIFIER TOKEN_LEFT_BRAK Exp TOKEN_RIGHT_BRAK TOKEN_ASSIGN Exp	
					{	
						auto sym = currentEnv->getSymbol(string($1));
						if(sym == NULL){
							SemanticError("Symbol \'"+ string($1)+"\' not found.");
						}

						if(sym->isGlobal)
						{
							//find array global address
							const char* tempReg = rm.findFreeTempRegister();
							cg.li(tempReg, 4);
							cg.mul($3.reg,$3.reg,tempReg);
							cg.la(tempReg,sym->id);
							cg.add(tempReg,$3.reg,tempReg);
							
							//save to the found address
							cg.sw(tempReg,$6.reg,0);
							rm.freeRegister($3.reg);
							rm.freeRegister(tempReg);
						}
						else
						{
							//findg array address
							const char* tempReg = rm.findFreeTempRegister();
							cg.li(tempReg, -4);
							cg.mul($3.reg,$3.reg,tempReg);
							cg.addi($3.reg,$3.reg,sym->address);
							cg.add($3.reg,$3.reg,"$fp");


							cg.sw($3.reg,$6.reg,0);

							rm.freeRegister($3.reg);
							rm.freeRegister(tempReg);
						}


					
					}
				;

%%

ofstream compiledProgram;
char * compiledProgramName;

void forceExit(){
	compiledProgram.close();
	remove(compiledProgramName);
	exit(1);
}

void SemanticError(string massage)
{
	std::cout << "Line ("<<(lineNumber+1)<<") "<< massage << std::endl;
	forceExit();
}

void yyerror(char const *s){
	printf ("Error while parsing the text in line (%d) : character (%d)\n%s\n",lineNumber+1,preCharNumber+1,s);
	forceExit();
}
int yywrap(){
	return 1;
}

int main(int argc ,char ** argv){
	compiledProgramName = argv[2];
	yyin = fopen(argv[1] , "r");
  	compiledProgram.open (argv[2]);
	cg.init(&compiledProgram);
	yyparse();
	fclose(yyin);
}





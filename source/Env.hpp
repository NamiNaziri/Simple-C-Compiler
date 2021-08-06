#ifndef ENV_HPP
#define ENV_HPP

#include <string>
#include <map>
#include <iostream>
#include <vector>
#include <set>

using std::map;
using std::string;
using std::vector;
using std::set;

extern set<string> functionNameSet;
extern set<string>	identifierNameSet;



enum DataType
{
    VOID,
    INT,
    CHAR
};

class Symbol
{
public:
    string id;
    DataType dType;
    int address;
    bool isGlobal;
    int length;

    Symbol(string id, DataType dType, int address,bool isGlobal);
    Symbol(string id, DataType dType, int address,bool isGlobal,int length);
    Symbol();
    void print()
	{
		std::cout << "Identifier's Name:	 " << id
			 << "\nAddress:			 " << address
			 << "\n------------------------------" << std::endl;
	}

};

typedef struct FunctionMetaData{
		string name;
        vector<Symbol*> args;
		int argsNum;
		DataType output;
	} FunctionMetaData;



class Env
{
public:
    Env *base = nullptr;
    map<string,Symbol> table;

    //set<string>* functionNameSet = nullptr;
   // set<string>* functionNameSet = nullptr;
public:
    Env(/*set<string>* functionNameSet*/);
    Env(Env* base);
    bool addSymbol(Symbol);
    Symbol* getSymbol(string id);
};

#endif
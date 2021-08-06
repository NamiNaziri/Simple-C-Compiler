#include "Env.hpp"



set<string> functionNameSet;
set<string>	identifierNameSet;

Symbol::Symbol(string id, DataType dType, int address,bool isGlobal)
    : id(id), dType(dType), address(address),isGlobal(isGlobal)
{
    length = 0;
}
Symbol::Symbol()
{
    length = 0;
}

Symbol::Symbol(string id, DataType dType, int address,bool isGlobal,int length)
            : id(id), dType(dType), address(address),isGlobal(isGlobal),length(length)
{
}

Env::Env(/*set<string>* functionNameSet*/)
    : base(NULL)
{
}

Env::Env(Env *base)
    : base(base)
{
}

bool Env::addSymbol(Symbol symbol)
{

    
    if(functionNameSet.find(symbol.id) != functionNameSet.end())
    {
        return false;
    }
    

    auto location = this->table.find(symbol.id);
    if (location == this->table.end())
    {
        this->table[symbol.id] = symbol;
        
        identifierNameSet.insert(symbol.id);

        return true;
    }
    return false;
}
Symbol *Env::getSymbol(string id)
{
    for (auto i = this; i != NULL; i = i->base)
    {
        auto symbol = i->table.find(id);
        if (symbol != i->table.end())
        {
            return &(i->table[id]);
        }
    }
    return NULL;
}
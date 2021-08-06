#ifndef STACK_MANAGER_HPP
#define STACK_MANAGER_HPP

#include <string>
#include "mips.hpp"

using std::string;

class StackManager
{
private:
    int framePointerOffset;
    MIPSCodeGenerator *generator;

public:
    StackManager(MIPSCodeGenerator *codeGenerator);

    void clearOffset();
    int allocateWords(int wordCount);
    void deallocateWords(int wordCount);
    int push(string srcReg);
    void pop(string destReg);

    void initCaller(string functionName);
    void initCallee();
    void endCaller();
    void endCallee();

};


#endif
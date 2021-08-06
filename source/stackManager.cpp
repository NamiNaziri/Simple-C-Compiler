#include "stackManager.hpp"
StackManager::StackManager(MIPSCodeGenerator *codeGenerator)
    : generator(codeGenerator)
{
    framePointerOffset = 0;
}

void StackManager::clearOffset()
{
    generator->move("$fp", "$sp");
    framePointerOffset = 0;
}

int StackManager::allocateWords(int wordCount)
{
    this->generator->addiu("$sp", "$sp", -wordCount * 4);
    framePointerOffset -= wordCount * 4;
    return framePointerOffset;
}

void StackManager::deallocateWords(int wordCount)
{
    this->generator->addiu("$sp", "$sp", wordCount * 4);
    framePointerOffset += 4 * wordCount;
}

int StackManager::push(string srcReg)
{
    allocateWords(1);
    this->generator->sw("$sp", srcReg.c_str(), 0);
    return framePointerOffset;
}

void StackManager::pop(string destReg)
{
    this->generator->sw("$sp", destReg.c_str(), 0);
    deallocateWords(1);
}

void StackManager::initCaller(string calleeName)
{
    generator->jal(calleeName);
}

void StackManager::initCallee()
{
    allocateWords(3);
    generator->sw("$sp", "$ra", 8);
    generator->sw("$sp", "$sp", 4);
    generator->sw("$sp", "$fp", 0);
    clearOffset();
}

void StackManager::endCallee()
{
    generator->lw("$fp", "$ra", 8);
    generator->lw("$fp", "$sp", 4);
    generator->lw("$fp", "$fp", 0);
    deallocateWords(3);
    generator->jr("$ra");
}

void StackManager::endCaller()
{
}
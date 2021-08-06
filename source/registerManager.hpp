#ifndef REGISTER_MANAGER_H
#define REGISTER_MANAGER_H

#include <iostream>
#include <bits/stdc++.h>
#include <fstream>
#include <typeinfo>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <string.h>
#include <iostream>

#include "parser.tab.h"

#define TEMP_COUNT 10
#define SAVE_COUNT 8
#define ARGS_COUNT 4

using namespace std;

class RegisterManager
{
private:
    int temporalRegisters[TEMP_COUNT] = {};
    int savedRegsiters[SAVE_COUNT] = {};
    int argsRegisters[ARGS_COUNT] = {};

public:
    const char *findFreeTempRegister()
    {
        return findRegisterInternal(temporalRegisters, TEMP_COUNT, "$t");
    }

    const char *findSavedRegister()
    {
        return findRegisterInternal(savedRegsiters, SAVE_COUNT, "$s");
    }

    const char *findFreeArgRegister()
    {
        return findRegisterInternal(argsRegisters, ARGS_COUNT, "$a");
    }

    void clearTempRegisters()
    {
        clearRegistersInternal(temporalRegisters, TEMP_COUNT);
    }

    void clearSavedRegisters()
    {
        clearRegistersInternal(savedRegsiters, SAVE_COUNT);
    }
    void clearArgsRegisters()
    {
        clearRegistersInternal(argsRegisters, ARGS_COUNT);
    }

    void freeRegister(const char * regName)
    {
        string str(regName);
        switch (str[1])
        {
        case 't':
            temporalRegisters[stoi(str.substr(2))] = 0;
            break;
        case 'a':
            argsRegisters[stoi(str.substr(2))] = 0;
            break;
        }
    }

private:
    const char *findRegisterInternal(int *state, int count, const char *prefix)
    {
        for (int i = 0; i < count; i++)
        {
            if (state[i] == 0)
            {
                state[i] = 1;
                return strdup((prefix + to_string(i)).c_str());
            }
        }
        
        return "";
    }

    void clearRegistersInternal(int *array, int size)
    {
        for (int i = 0; i < size; i++)
        {
            array[i] = 0;
        }
    }

    void clearRegistersInternal()
    {

    }
};

void showstack(stack<int> s);
int calculate(int token, int leftVal, int rightVal);

#endif

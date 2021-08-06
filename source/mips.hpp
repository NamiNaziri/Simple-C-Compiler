#ifndef MIPS_H
#define MIPS_H

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

class MIPSCodeGenerator
{

public:

    ofstream *fp;

    MIPSCodeGenerator()
    {
        fp = NULL;
    }
	MIPSCodeGenerator(ofstream *fp)
	{
        this->fp = fp;
	}

    //* initialize
    void init(ofstream *fp)
    {
        this->fp = fp;
        *(this->fp) << ".data" << endl << "backn: .asciiz \"\\n\"" << endl << ".text" << endl << ".globl main\n" << endl;
    }


    //* arithmetics
    void add(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void sub(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void addi(const char* dst_reg , const char* left_src_reg , int immediate);
    void addiu(const char* dst_reg , const char* left_src_reg , int immediate);
    void mul(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void div(const char* left_src_reg , const char* right_src_reg);
    void divQ(const char* dst_reg);
    void divR(const char* dst_reg);

    //* logical
    void _and(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void _or(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void _xor(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void andi(const char* dst_reg , const char* left_src_reg , int immediate);
    void ori(const char* dst_reg , const char* left_src_reg , int immediate);

    void neg(const char* dst_reg , const char* src_reg);

    //* data transfer
    void lw(const char* src_base_reg ,const char * dst_reg, int address);
    void sw(const char* src_base_reg , const char* dst_reg , int offset);
    void lw(const char* dst_reg ,string label);
    void la(const char* dst_reg , string label);
    void li(const char* dst_reg , int immediate);
    void move(const char* dst_reg , const char* src_reg);
    void allocateGlobalVriable(string Identifier, int value);
    void allocateGlobalArray(string Identifier, int length);

    //* branch
    void beq(const char* left_reg , const char* right_reg , string label);
    void bne(const char* left_reg , const char* right_reg , string label);
    void bgt(const char* left_reg , const char* right_reg , string label);
    void bge(const char* left_reg , const char* right_reg , string label);
    void blt(const char* left_reg , const char* right_reg , string label);
    void ble(const char* left_reg , const char* right_reg , string label);

    //* comparison
    void slt(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void slti(const char* dst_reg , const char* left_src_reg , int immediate);

    void sle(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void seq(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void sne(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void sgt(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);
    void sge(const char* dst_reg , const char* left_src_reg , const char* right_src_reg);

    //* unconditional jump
    void j(int address);
    void j(string label);

    void jr(const char* reg);

    void jal(int address);
    void jal(string label);

    //* utility
    void add_label(string label);



};


#endif
#include "mips.hpp"

    void MIPSCodeGenerator::add(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    add " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::sub(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    sub " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::addi(const char* dst_reg , const char* left_src_reg , int immediate)
    {
        *(this->fp) << "    addi " << dst_reg << "," << left_src_reg << "," << immediate << endl;
    }
    void MIPSCodeGenerator::addiu(const char* dst_reg , const char* left_src_reg , int immediate)
    {
        *(this->fp) << "    addiu " << dst_reg << "," << left_src_reg << "," << immediate << endl;
    }
    void MIPSCodeGenerator::mul(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    mul " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::div(const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    div " << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::divQ(const char* dst_reg)
    {
        *(this->fp) << "    move " << dst_reg << "," << "$lo" << endl;}
    void MIPSCodeGenerator::divR(const char* dst_reg)
    {
        *(this->fp) << "    move " << dst_reg << "," << "$hi" << endl;
    }
    void MIPSCodeGenerator::_and(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    and " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::_or(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    or " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::_xor(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    xor " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::andi(const char* dst_reg , const char* left_src_reg , int immediate)
    {
        *(this->fp) << "    andi " << dst_reg << "," << left_src_reg << "," << immediate << endl;
    }
    void MIPSCodeGenerator::ori(const char* dst_reg , const char* left_src_reg , int immediate)
    {
        *(this->fp) << "    ori " << dst_reg << "," << left_src_reg << "," << immediate << endl;
    }
    void MIPSCodeGenerator::neg(const char* dst_reg , const char* src_reg)
    {
        *(this->fp) << "    neg " << dst_reg << "," << src_reg << endl;
    }


    void MIPSCodeGenerator::lw(const char* src_base_reg ,const char * dst_reg, int address)
    {
        *(this->fp) << "    lw " << dst_reg << "," << address<< "(" << src_base_reg << ")" << endl;
    }
    void MIPSCodeGenerator::sw(const char* src_base_reg , const char* dst_reg , int offset)
    {
        *(this->fp) << "    sw " << dst_reg << "," << offset << "(" << src_base_reg << ")" << endl;
    }
    void MIPSCodeGenerator::lw(const char* dst_reg ,string label)
    {
        *(this->fp) << "    lw " << dst_reg << ", " << label << endl;
    }
    void MIPSCodeGenerator::la(const char* dst_reg , string label)
    {
        *(this->fp) << "    la " << dst_reg << "," << label << endl;
    }
    void MIPSCodeGenerator::li(const char* dst_reg , int immediate)
    {
        *(this->fp) << "    li " << dst_reg << "," << immediate << endl;
    }
    void MIPSCodeGenerator::move(const char* dst_reg , const char* src_reg)
    {
        *(this->fp) << "    move " << dst_reg << "," << src_reg << endl;
    }
    void MIPSCodeGenerator::beq(const char* left_reg , const char* right_reg , string label)
    {
        *(this->fp) << "    beq " << left_reg << "," << right_reg << "," << label << endl;
    }
    void MIPSCodeGenerator::bne(const char* left_reg , const char* right_reg , string label)
    {
        *(this->fp) << "    bne " << left_reg << "," << right_reg << "," << label << endl;
    }
    void MIPSCodeGenerator::bgt(const char* left_reg , const char* right_reg , string label)
    {
        *(this->fp) << "    bgt " << left_reg << "," << right_reg << "," << label << endl;
    }
    void MIPSCodeGenerator::bge(const char* left_reg , const char* right_reg , string label)
    {
        *(this->fp) << "    bge " << left_reg << "," << right_reg << "," << label << endl;
    }
    void MIPSCodeGenerator::blt(const char* left_reg , const char* right_reg , string label)
    {
        *(this->fp) << "    blt " << left_reg << "," << right_reg << "," << label << endl;
    }
    void MIPSCodeGenerator::ble(const char* left_reg , const char* right_reg , string label)
    {
        *(this->fp) << "    ble " << left_reg << "," << right_reg << "," << label << endl;
    }
    void MIPSCodeGenerator::slt(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    slt " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::sle(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    sle " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::seq(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    seq " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::sne(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    sne " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::sgt(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    sgt " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::sge(const char* dst_reg , const char* left_src_reg , const char* right_src_reg)
    {
        *(this->fp) << "    sge " << dst_reg << "," << left_src_reg << "," << right_src_reg << endl;
    }
    void MIPSCodeGenerator::slti(const char* dst_reg , const char* left_src_reg , int immediate)
    {
        *(this->fp) << "    slti " << dst_reg << "," << left_src_reg << "," << immediate << endl;
    }
    void MIPSCodeGenerator::j(int address)
    {
        *(this->fp) << "    j " << address << endl;
    }
    void MIPSCodeGenerator::j(string label)
    {
        *(this->fp) << "    j " << label << endl;
    }
    void MIPSCodeGenerator::jr(const char* reg)
    {
        *(this->fp) << "    jr " << reg << endl;
    }
    void MIPSCodeGenerator::jal(int address)
    {
        *(this->fp) << "    jal " << address << endl;
    }
    void MIPSCodeGenerator::jal(string label)
    {
        *(this->fp) << "    jal " << label << endl;
    }
    void MIPSCodeGenerator::add_label(string label)
    {
        *(this->fp) << "\n"<<label << ":" << endl;
    }

    void MIPSCodeGenerator::allocateGlobalVriable(string Identifier, int value)
    {
        *(this->fp) <<".data" << "\n"<<Identifier <<":" << "\t.word" << "\t"<< to_string(value)<<endl<<".text"<<endl;
    }

     void MIPSCodeGenerator::allocateGlobalArray(string Identifier, int length)
     {
         *(this->fp) <<".data" << "\n"<<Identifier <<":" << "\t.space" << "\t"<< to_string(length * 4)<<endl<<".text"<<endl;
     }
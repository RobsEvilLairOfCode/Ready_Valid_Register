#include "Vtb_ready_valid_register.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    Vtb_ready_valid_register* tb = new Vtb_ready_valid_register;

    while(!Verilated::gotFinish()){
        tb->eval();
        Verilated::timeInc(1);
    }

    delete tb;
    return 0;
}
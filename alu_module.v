`include "modules/mux4.v"
`include "modules/register.v"
`include "modules/alu.v"

`timescale 1s/1ms

module alu_module;

// ---- Aux signals ----


// ---- Control signals ----
reg clk = 0;

// ---- Intermediate signals ----



// ---- Modules ----
register #() RA (

);

mux4 #() SELDAT (

);

alu #() ALU (

);

register #() RZ (
    
);
 
always # 0.5 clk = ~clk; 
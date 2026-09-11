# 32-Bit Single-Cycle RISC-V Processor

A 32-bit single-cycle RISC-V processor (RV32I base, plus extensions) implemented in Verilog HDL, with a modular RTL design, a compiled C Fibonacci program as an end-to-end workload, and a self-checking testbench.

**Author:** Gehad Ali — B.Sc. Electronics and Communication Engineering, Mansoura University

## Project Objectives

- Design and implement a 32-bit single-cycle RISC-V processor using Verilog HDL.
- Apply a modular RTL design methodology, with each processor component as an independent module.
- Integrate all modules into a complete, functional top-level design.
- Execute a RISC-V assembly program by converting it to machine code and loading it into instruction memory.
- Verify functionality through simulation with a dedicated testbench.
- Demonstrate execution of the supported RISC-V instructions and validate output correctness.

## Processor Specifications

| Feature | Description |
|---|---|
| **Architecture Base** | 32-bit RISC-V (RV32I base integer instruction set subset) |
| **Execution Model** | Single-cycle datapath, one instruction per clock cycle (CPI = 1) |
| **Data Path & Word Size** | 32 bits for data routing, address buses, and instructions |
| **Register File** | 32 general-purpose 32-bit registers, dual asynchronous read ports, single synchronous write port; `x0` hardwired to zero |
| **ALU Capabilities** | Addition, subtraction, bitwise AND/OR, arithmetic/logical shifts, set-less-than (SLT) |
| **Memory Architecture** | Harvard-style split: byte-addressable, read-only Instruction Memory and read/write Data Memory; 32-bit aligned word access |
| **Control Logic** | Purely combinational decoding of the 7-bit opcode, 3-bit funct3, and 7-bit funct7 fields |

## Supported RISC-V Instruction Set

| Type | Instructions | Opcode |
|---|---|---|
| R-Type | ADD, SUB, AND, OR, SLT, SLL, SRL, SRA | `0110011` |
| I-Type (ALU) | ADDI, ANDI, ORI, SLTI, SLLI, SRLI, SRAI | `0010011` |
| I-Type (Load) | LW | `0000011` |
| I-Type (Jump) | JALR | `1100111` |
| S-Type | SW | `0100011` |
| B-Type | BEQ, BNE, BLT, BGE | `1100011` |
| J-Type | JAL | `1101111` |
| U-Type | AUIPC | `0010111` |

The datapath extends beyond the standard Harris & Harris reference design to add JAL, JALR, AUIPC, the extended branch conditions (BNE, BLT, BGE), and the shift family (SLL/SRL/SRA and their immediate variants).

## Module Hierarchy

| File | Description |
|---|---|
| `ALU.v` | Arithmetic/logic unit: add, subtract, AND, OR, SLT, shifts |
| `adder.v` | Generic 32-bit adder, used for PC+4 and branch/jump target calculation |
| `ControlUnit.v` | Top-level control logic; combines the main and ALU decoders and resolves branch/jump PC-source selection |
| `MainDecoder.v` | Decodes the 7-bit opcode into control signals |
| `ALUDecoder.v` | Decodes ALUOp/funct3/funct7 into the ALU's operation code |
| `RegFile.v` | 32x32-bit register file with async read, sync write, `x0` hardwired to zero |
| `Instr_Mem.v` | 64-word instruction memory, loaded from `fibonacci.mem` |
| `Data_MEM.v` | 64-word data memory, synchronous write / asynchronous read |
| `rff.v` | Generic resettable register (used for the PC) |
| `Datapath.v` | Wires together the PC logic, register file, extender, ALU, and muxes |
| `Extender.v` | Sign-extends immediates per instruction type (I/S/B/J/U) |
| `Mux2_1.v` / `Mux3_1.v` | Generic 2-to-1 and 3-to-1 multiplexers |
| `SingleCycle.v` | Combines `Datapath` and `ControlUnit` into the core |
| `Top_Module.v` | Top-level integration: core + instruction memory + data memory |

## Verification

The processor is verified against a compiled C program rather than hand-written test instructions, giving broader, more realistic instruction coverage in a single run.

- **Workload:** `fibonacci.c` computes the 10th Fibonacci number, compiled to RV32I machine code (`fibonacci.mem`) via a standard RISC-V toolchain. The disassembly exercises arithmetic, stack-relative memory access, and loop branch logic together.
- **Testbench (`Top_Module_tb.v`):** Runs the core in an Icarus/ModelSim-style simulation, automatically detects the halt condition (PC no longer changing, from a `jal x0,0` trap), then self-checks the result read directly from data memory against the expected value (`fibonacci(10) = 55`) and prints `PASS`/`FAIL`.
- **Waveform:** A VCD dump confirms `MemWrite` pulses through the Fibonacci loop and the final `WriteData` (`0x00000037` / 55) lands at the expected address.

## Known Limitations / Notes

- **No synthesized timing numbers yet.** The processor's critical path has not been measured through synthesis (Vivado/Quartus/OpenLane+OpenSTA); `Tc_single` and max frequency are still open questions rather than reported figures.
- **Single test program.** Verification currently relies on one Fibonacci workload; there's no instruction-by-instruction coverage matrix confirming every supported opcode has been exercised at runtime.

## Changelog

- Fixed an addressing inconsistency: `Instr_Mem.v` now indexes with `Address[7:2]` (previously `Address[31:2]`), matching `Data_MEM.v`'s addressing and correctly bounding both to the 64-word memory size.

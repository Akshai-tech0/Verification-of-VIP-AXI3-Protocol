
# AXI3 Protocol Verification using UVM

## Overview

This project implements a complete UVM-based verification environment for the AXI3 protocol. The objective is to verify the functionality of an AXI3-compliant design by generating constrained-random transactions, checking protocol compliance, collecting functional coverage, and validating the DUT using assertions.

---

## Features

- UVM-based reusable testbench architecture
- Master and Slave Agents
- Driver, Monitor, Sequencer, Scoreboard, and Environment
- Constrained Random Verification
- Functional Coverage
- SystemVerilog Assertions (SVA)
- Protocol Compliance Checking
- Directed and Random Testcases
- Error Detection and Reporting

---

## Protocol Features Verified

- Independent Read and Write Channels
- Burst Transactions
- Fixed, Incrementing, and Wrapping Bursts
- Multiple Outstanding Transactions
- VALID/READY Handshake
- Address Phase Verification
- Data Phase Verification
- Response Channel Verification

---

## Verification Components

- Interface
- Transaction Class
- Sequences
- Sequencer
- Driver
- Monitor
- Agent
- Scoreboard
- Environment
- Test
- Functional Coverage
- Assertions

---

## Tools Used

- Verilog
- SystemVerilog
- UVM (Universal Verification Methodology)
- Synopsys VCS
- Verdi / DVE (Waveform Debug)

---

## Verification Methodology

The verification environment follows the standard UVM architecture.

1. Sequences generate randomized AXI transactions.
2. Driver converts transactions into pin-level activity.
3. Monitor captures DUT activity.
4. Scoreboard compares expected and actual transactions.
5. Functional coverage measures protocol coverage.
6. Assertions verify protocol timing and handshake requirements.

---

## Functional Coverage

- Write Transactions
- Read Transactions
- Burst Types
- Burst Lengths
- Address Alignment
- VALID/READY Handshake
- Response Types

**Overall Functional Coverage:** **96%**

---

## Assertions

Implemented SystemVerilog Assertions for:

- VALID/READY Handshake
- Write Address Channel
- Write Data Channel
- Read Address Channel
- Read Data Channel
- Response Channel
- Reset Behavior

All assertions passed successfully.

---

## Repository Structure

```
AXI3-Protocol-Verification
│
├── RTL
├── Interface
├── Testbench
├── UVM
│   ├── Driver
│   ├── Monitor
│   ├── Sequencer
│   ├── Agent
│   ├── Scoreboard
│   ├── Environment
│   └── Test
├── Assertions
├── Coverage
├── Simulation
├── Documents
└── README.md
```

---

## Skills Demonstrated

- Verilog RTL
- SystemVerilog
- UVM
- Assertions (SVA)
- Functional Coverage
- Constrained Random Verification
- AXI3 Protocol
- Debugging
- Scoreboard Design

---

## Future Enhancements

- AXI4 Support
- AXI-Lite Verification
- Coverage-Driven Verification
- Regression Automation
- UVM Register Layer (RAL)
- Formal Protocol Verification

---

## Author

**Akshai Britto A**

Electronics and Communication Engineering Graduate

Advanced VLSI Design & Verification Trainee – Maven Silicon

Specialization: RTL Design | Design Verification | UVM | SystemVerilog

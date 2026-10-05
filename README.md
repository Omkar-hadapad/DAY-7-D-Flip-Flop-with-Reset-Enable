# Day 7 — D Flip-Flop with Reset & Enable

<p align="center">
  <b>Digital VLSI • Verilog RTL • Sequential Logic • Functional Verification • Cadence Genus</b>
</p>

<p align="center">
  <code>Specification → RTL → Simulation → Synthesis → Technology Mapping → Timing → Power → PPA</code>
</p>

---

## 1. Project Information

| Parameter               | Details                                 |
| ----------------------- | --------------------------------------- |
| **Project**             | Day 7 — D Flip-Flop with Reset & Enable |
| **Domain**              | Digital VLSI / RTL Design               |
| **Design Type**         | Sequential Logic                        |
| **HDL**                 | Verilog HDL                             |
| **Target Technology**   | TSMC 180 nm                             |
| **Library**             | `tsmc18`                                |
| **Synthesis Tool**      | Cadence Genus 21.14-s082_1              |
| **Operating Condition** | `slow (balanced_tree)`                  |
| **Wireload Mode**       | `enclosed`                              |
| **Reset Type**          | Active-High Reset                       |
| **Clocking**            | Positive-Edge Triggered                 |
| **Main Function**       | D Flip-Flop with Reset and Enable       |
| **Analysis**            | Area, Power, Timing, Technology Mapping |
| **Status**              | Synthesis and PPA analysis completed    |

---

# 2. Project Overview

A **D Flip-Flop (DFF)** is a fundamental sequential storage element used to store one bit of information.

Unlike combinational logic, a flip-flop stores its previous state and changes its output according to a clock event.

This project implements and analyzes a D flip-flop with:

* Positive-edge-triggered clock
* Reset control
* Enable control
* State-holding behavior
* Sequential synthesis
* Standard-cell technology mapping
* Area analysis
* Power analysis
* Timing analysis

The design is taken through an RTL-to-gate-level synthesis flow using **Cadence Genus**.

---

# 3. Objective

The main objectives of this project are:

1. Understand sequential logic and state storage.
2. Understand positive-edge-triggered D flip-flop operation.
3. Understand reset priority.
4. Understand enable-controlled state updates.
5. Write synthesizable Verilog RTL.
6. Verify sequential behavior using simulation.
7. Synthesize the RTL using Cadence Genus.
8. Analyze technology-mapped standard cells.
9. Analyze cell-area distribution.
10. Analyze power consumption.
11. Analyze timing constraints and setup slack.
12. Understand RTL-to-standard-cell mapping.
13. Relate the design to practical ASIC sequential logic.

---

# 4. D Flip-Flop Concept

A D flip-flop stores the value present at its `D` input when the active clock edge occurs.

For a positive-edge-triggered DFF:

```text
              +-------------+
      D ----->|             |
              |     DFF     |-----> Q
CLK --------->|   ↑         |
              |             |
              +-------------+
```

The arrow indicates that the flip-flop responds to the rising edge of the clock.

### Basic operation

At every rising edge:

```text
Q(next) = D
```

Therefore:

```text
D = 0  → Q becomes 0
D = 1  → Q becomes 1
```

between active clock events, the output retains its stored value.

---

# 5. Reset and Enable Principle

The Day-7 design introduces two control conditions:

* `reset`
* `enable`

The reset has the highest priority.

The intended functional behavior is:

```text
                 +----------------+
reset ---------->|                |
                 |                |
en -------------->|   D Flip-Flop |----> Q
                 |                |
D -------------->|                |
                 |                |
clk ------------>|                |
                 +----------------+
```

### Priority

```text
RESET
  ↓
ENABLE
  ↓
DATA
```

The basic functional behavior is:

| Reset | Enable | Clock       | Operation              |
| ----: | -----: | ----------- | ---------------------- |
|     1 |      X | X           | Q = 0                  |
|     0 |      1 | Rising edge | Q = D                  |
|     0 |      0 | Rising edge | Q holds previous value |

---

# 6. Example Operation

Assume:

```text
Initial Q = 0
```

### Case 1 — Reset active

```text
reset = 1
```

Output:

```text
Q = 0
```

The stored state is cleared.

---

### Case 2 — Reset inactive and enable active

```text
reset = 0
enable = 1
```

At the rising edge of `clk`:

```text
Q ← D
```

Example:

```text
D = 1

        ↑
CLK ____|‾‾‾

Q = 1
```

---

### Case 3 — Enable inactive

```text
reset = 0
enable = 0
```

At the rising clock edge:

```text
Q ← Q(previous)
```

Therefore, the flip-flop retains its previous state.

---

# 7. Hardware Architecture

The conceptual architecture is:

```text
                     +-------------------+
                     |                   |
D ------------------>|                   |
                     |    D Flip-Flop    |-----> Q
                     |                   |
CLK ---------------->| Clock             |
                     |                   |
RESET -------------->| Reset             |
                     |                   |
ENABLE ------------->| Enable            |
                     |                   |
                     +-------------------+
```

The hardware contains:

* Sequential storage element
* Clock input
* Reset control
* Enable control
* Data input
* Stored output

---

# 8. Logical Hierarchy

The synthesis hierarchy reported for the project contains:

```text
dff_reset_top
│
├── ASYNC_DFF
│   └── dff_async_reset
│
└── SYNC_DFF
    └── dff_sync_reset
```

The Genus hierarchy report shows:

| Module            | Cell Count | Cell Area |
| ----------------- | ---------: | --------: |
| `dff_reset_top`   |          5 |   176.299 |
| `dff_async_reset` |          2 |    89.813 |
| `dff_sync_reset`  |          3 |    86.486 |

### Important observation

The synthesized hierarchy contains both asynchronous-reset and synchronous-reset related implementations.

Therefore, the synthesis results should be interpreted as the **reported `dff_reset_top` implementation**, rather than assuming that the reported area represents only one isolated DFF implementation.

---

# 9. Functional Specification

## Inputs

| Signal  | Description                   |
| ------- | ----------------------------- |
| `clk`   | Positive-edge-triggered clock |
| `reset` | Reset control                 |
| `en`    | Enable control                |
| `d`     | Data input                    |

## Output

| Signal | Description   |
| ------ | ------------- |
| `q`    | Stored output |

---

## Functional Behavior

### Reset condition

```text
reset = 1
```

The flip-flop is reset to:

```text
Q = 0
```

### Enabled condition

```text
reset = 0
en = 1
```

At the rising edge of `clk`:

```text
Q = D
```

### Hold condition

```text
reset = 0
en = 0
```

The previous value is retained.

---

# 10. D Flip-Flop with Reset

Reset provides a mechanism for initializing the sequential state.

The conceptual behavior is:

```text
if reset:
    Q = 0
else:
    normal operation
```

Reset priority is important because the reset condition must override normal data operation.

---

# 11. D Flip-Flop with Enable

Enable controls whether the stored value is updated.

```text
if enable:
    Q = D
else:
    Q = Q(previous)
```

The enable condition therefore introduces a **hold operation**.

Conceptually:

```text
             +-------+
D ---------->|       |
             |  MUX  |----> DFF ----> Q
Q ---------->|       |
             +-------+
                ↑
                |
               EN
```

When `EN = 1`, the D input is selected.

When `EN = 0`, the previous Q value is fed back.

---

# 12. RTL Design

The RTL is intended to describe:

```text
Reset
  ↓
Enable
  ↓
Data
  ↓
Sequential storage
```

The design uses synthesizable sequential Verilog.

The important RTL concepts are:

* `always` block for sequential logic
* Positive clock edge
* Reset sensitivity where applicable
* Priority between reset and enable
* Nonblocking assignment for sequential state
* State retention when enable is inactive

---

# 13. RTL-to-Hardware Mapping

After synthesis, the RTL is converted into technology-specific standard cells.

The reported mapped cells are:

```text
RTL
 │
 ▼
Logic Synthesis
 │
 ▼
Generic Sequential Logic
 │
 ▼
Technology Mapping
 │
 ▼
TSMC18 Standard Cells
```

The Genus technology-mapping report contains:

| Standard Cell | Instances |        Area |
| ------------- | --------: | ----------: |
| `DFFHQX1`     |         1 |      53.222 |
| `INVXL`       |         1 |       6.653 |
| `MXI2X1`      |         1 |      23.285 |
| `NOR2X1`      |         1 |       9.979 |
| `SDFFRHQX1`   |         1 |      83.160 |
| **Total**     |     **5** | **176.299** |

---

# 14. Standard-Cell Area Distribution

The total synthesized area is:

```text
Total Area = 176.299
```

The area classification reported by Genus is:

| Cell Type      | Instances |        Area |   Area % |
| -------------- | --------: | ----------: | -------: |
| Sequential     |         2 |     136.382 |    77.4% |
| Inverter       |         1 |       6.653 |     3.8% |
| Logic          |         2 |      33.264 |    18.9% |
| Physical Cells |         0 |       0.000 |     0.0% |
| **Total**      |     **5** | **176.299** | **100%** |

### Observation

Sequential cells dominate the area:

```text
Sequential area ≈ 77.4%
```

This is expected for a design whose primary functionality is state storage.

---

# 15. Sequential Area Analysis

The sequential cells are:

```text
DFFHQX1
SDFFRHQX1
```

Their areas are:

```text
DFFHQX1    = 53.222
SDFFRHQX1  = 83.160
```

Therefore:

```text
Sequential Area
= 53.222 + 83.160
= 136.382
```

Percentage:

```text
136.382 / 176.299 × 100
≈ 77.4%
```

Thus, most of the synthesized area is associated with sequential storage elements.

---

# 16. Combinational Logic Area

The reported combinational-related cells are:

```text
INVXL
MXI2X1
NOR2X1
```

Their total area is:

```text
6.653 + 23.285 + 9.979
= 39.917
```

The reported category distribution gives approximately:

```text
Inverter + Logic
≈ 22.6%
```

This logic supports the control and data behavior around the sequential elements.

---

# 17. Verification Strategy

A sequential design should be verified using directed test cases covering:

1. Reset assertion.
2. Reset release.
3. Data = 0.
4. Data = 1.
5. Enable = 1.
6. Enable = 0.
7. Data changes while enable is disabled.
8. Multiple clock cycles.
9. Reset priority.
10. Boundary transitions between reset, enable, and data.

A suitable verification sequence is:

```text
Reset
  ↓
Check Q = 0
  ↓
Release Reset
  ↓
Enable = 1
  ↓
Apply D
  ↓
Clock Edge
  ↓
Check Q = D
  ↓
Enable = 0
  ↓
Change D
  ↓
Clock Edge
  ↓
Check Q Holds
```

---

# 18. Verification Results

Detailed simulation waveforms and self-checking testbench results were **not supplied in the current project evidence**.

Therefore, no numerical verification-pass percentage or waveform-based result is claimed here.

The required verification conditions remain:

| Test                        | Expected Result                |
| --------------------------- | ------------------------------ |
| Reset active                | Q = 0                          |
| Enable active at clock edge | Q = D                          |
| Enable inactive             | Q holds previous value         |
| Reset + Enable              | Reset has priority             |
| Multiple clock cycles       | Correct state retention/update |

---

# 19. Overall Verification Result

The functional verification section should be considered:

```text
Functional Verification Evidence
        ↓
Not supplied in current report set
```

However, the synthesized design has successfully passed through:

```text
RTL
 ↓
Synthesis
 ↓
Technology Mapping
 ↓
Area Analysis
 ↓
Power Analysis
 ↓
Timing Analysis
```

---

# 20. Simulation

The expected simulation waveform contains:

```text
CLK     __/‾\__/‾\__/‾\__/‾\__

RESET   ‾‾‾‾\___________________

EN      ____‾‾‾‾‾‾____‾‾‾‾‾‾_

D       ____0___1_______0___1___

Q       000000000111111000001111
```

The exact waveform should be replaced with the project's actual simulation evidence when available.

---

# 21. Simulation Completion

Simulation should confirm the three fundamental operations:

```text
RESET
  ↓
Q = 0

ENABLE = 1
  ↓
Q captures D

ENABLE = 0
  ↓
Q holds previous state
```

No specific waveform result is claimed here because the actual simulation output was not included in the supplied synthesis reports.

---

# 22. Synthesis Flow

The project follows the standard RTL-to-gate synthesis flow:

```text
                RTL
                 │
                 ▼
          Elaborated Design
                 │
                 ▼
           Generic Logic
                 │
                 ▼
          Optimization
                 │
                 ▼
       Technology Mapping
                 │
                 ▼
        TSMC18 Standard Cells
                 │
          ┌──────┼──────┐
          ▼      ▼      ▼
        Area   Timing  Power
```

Cadence Genus was used for synthesis and analysis.

---

# 23. Area Analysis

### Total area

```text
Total Area = 176.299
```

### Area summary

| Parameter             |  Result |
| --------------------- | ------: |
| Total instances       |       5 |
| Total area            | 176.299 |
| Sequential area       | 136.382 |
| Sequential percentage |   77.4% |
| Logic area            |  33.264 |
| Inverter area         |   6.653 |
| Physical-cell area    |       0 |

---

# 24. Instance Analysis

The mapped design contains five standard-cell instances:

```text
1 × DFFHQX1
1 × INVXL
1 × MXI2X1
1 × NOR2X1
1 × SDFFRHQX1
```

Therefore:

```text
Total instances = 5
```

The largest individual cell by area is:

```text
SDFFRHQX1 = 83.160
```

followed by:

```text
DFFHQX1 = 53.222
```

---

# 25. Power Analysis

The reported total power is:

```text
Total Power = 1.46277 × 10⁻⁵ W
```

or:

```text
Total Power = 14.6277 µW
```

The report is associated with:

```text
PDB Frame:
/stim#0/frame#0
```

Therefore, the value should be interpreted for the reported power-analysis activity/frame and not treated as a universal power value for all operating conditions.

---

# 26. Power Breakdown

The Genus power report gives:

| Category  |    Total Power | Percentage |
| --------- | -------------: | ---------: |
| Register  |     12.6881 µW |     86.74% |
| Logic     |     0.44366 µW |      3.03% |
| Clock     |     1.49591 µW |     10.23% |
| Memory    |              0 |         0% |
| Latch     |              0 |         0% |
| Pad       |              0 |         0% |
| **Total** | **14.6277 µW** |   **100%** |

---

# 27. Power Interpretation

The largest contribution is from the register category:

```text
Register Power = 12.6881 µW
```

This represents:

```text
86.74%
```

of the reported total power.

Clock power is:

```text
1.49591 µW
```

or:

```text
10.23%
```

Logic power is:

```text
0.44366 µW
```

or:

```text
3.03%
```

This distribution is consistent with a small sequential design in which the storage elements and clock network contribute significantly to the total reported power.

---

# 28. Internal and Switching Power

The power report gives:

| Power Component |          Value | Percentage |
| --------------- | -------------: | ---------: |
| Leakage         |     5.85558 nW |      0.04% |
| Internal        |     12.8349 µW |     87.74% |
| Switching       |     1.78695 µW |     12.22% |
| **Total**       | **14.6277 µW** |   **100%** |

The reported power is therefore dominated by internal power for this analysis frame.

---

# 29. Timing Analysis

The supplied Genus timing report contains:

```text
Slack = +7219 ps
```

Therefore:

```text
Slack = +7.219 ns
```

The reported path is:

```text
en → ASYNC_DFF/q_reg/SE
```

with:

```text
Startpoint = en
Endpoint   = ASYNC_DFF/q_reg/SE
Clock      = clk
```

---

# 30. Timing Calculation

The report gives:

```text
Capture Edge  = 10000 ps
Input Delay   = 1000 ps
Setup         = 781 ps
```

Required time:

```text
Required Time
= 10000 - 1000 - 781
= 8219 ps
```

Arrival time:

```text
Arrival = 1000 ps
```

Therefore:

```text
Slack
= Required Time - Arrival Time

= 8219 - 1000

= 7219 ps
```

Hence:

```text
Slack = +7.219 ns
```

The timing check is reported as:

```text
MET
```

---

# 31. Timing Constraint Limitation

The reported timing path must be interpreted carefully.

The path is:

```text
en → SDFFRHQX1 / q_reg / SE
```

The endpoint is the:

```text
SE
```

pin of a scan-capable sequential cell.

Therefore, this report is **not sufficient to claim the functional D-to-Q critical-path delay of the design**.

The report shows:

```text
Setup Slack = +7.219 ns
```

but it should not be described as:

```text
DFF functional timing margin = 7.219 ns
```

without a functional data-path timing report.

A proper functional timing analysis should examine paths such as:

```text
D → Q
```

or:

```text
Register → Combinational Logic → Register
```

under the intended functional timing constraints.

---

# 32. PPA Summary

PPA represents:

```text
P = Power
P = Performance
A = Area
```

The available Day-7 results are:

| Metric                   |     Result |
| ------------------------ | ---------: |
| **Area**                 |    176.299 |
| **Power**                | 14.6277 µW |
| **Reported Setup Slack** |  +7.219 ns |
| **Instances**            |          5 |
| **Sequential Area**      |    136.382 |
| **Sequential Area %**    |      77.4% |

### Important timing limitation

The reported +7.219 ns slack belongs to the supplied:

```text
en → SE
```

setup path.

Therefore, a maximum functional operating frequency is **not established** from this timing report alone.

---

# 33. Optimization Considerations

Potential optimization directions include:

### Area optimization

* Reduce unnecessary control logic.
* Avoid duplicate sequential structures where not required.
* Select appropriate standard cells.
* Simplify enable/reset implementation.

### Power optimization

* Reduce unnecessary switching.
* Avoid unnecessary clock activity.
* Optimize enable behavior.
* Use suitable low-power cells where supported.

### Timing optimization

* Identify the actual functional critical path.
* Reduce combinational delay.
* Optimize fanout.
* Use appropriate drive-strength cells.
* Apply correct clock and input/output constraints.

### Important trade-off

Optimization should consider:

```text
Area ↔ Power ↔ Timing
```

Improving one metric may negatively affect another.

---

# 34. Common Design Mistakes

Common mistakes for this project include:

1. Incorrect clock edge.
2. Incorrect reset sensitivity.
3. Incorrect reset priority.
4. Using blocking assignments for sequential state.
5. Incorrect enable behavior.
6. Accidentally creating combinational feedback.
7. Incorrect signal width.
8. Multiple drivers for `q`.
9. Missing reset behavior.
10. Incorrect hold condition.
11. Confusing asynchronous and synchronous reset.
12. Incorrect testbench sampling around the clock edge.
13. Assuming synthesis cell names directly reveal complete RTL behavior.
14. Interpreting a scan-enable timing path as a functional D-to-Q path.
15. Claiming maximum frequency without a valid functional timing constraint.

---

# 35. Verification Status

| Verification Stage                  | Status                           |
| ----------------------------------- | -------------------------------- |
| RTL design                          | Completed                        |
| Hierarchy                           | Completed                        |
| Synthesis                           | Completed                        |
| Technology mapping                  | Completed                        |
| Area analysis                       | Completed                        |
| Power analysis                      | Completed                        |
| Timing report                       | Completed                        |
| Functional timing path              | Not established                  |
| RTL simulation evidence             | Not supplied                     |
| Self-checking verification evidence | Not supplied                     |
| PPA analysis                        | Completed with timing limitation |
| Optimization                        | Not performed                    |

---

# 36. Project Evidence

The available evidence includes:

```text
✓ Genus synthesis report
✓ Hierarchy report
✓ Standard-cell mapping report
✓ Area distribution
✓ Power report
✓ Timing report
```

Important numerical results:

```text
Area:
176.299

Power:
14.6277 µW

Sequential Area:
136.382

Sequential Area:
77.4%

Timing Slack:
+7.219 ns
```

---

# 37. Repository Structure

Recommended GitHub structure:

```text
day7-dff-reset-enable/
│
├── README.md
│
├── rtl/
│   └── dff_reset_enable.v
│
├── tb/
│   └── dff_reset_enable_tb.v
│
├── sim/
│   ├── waveform/
│   └── simulation_results/
│
├── synthesis/
│   ├── reports/
│   │   ├── area.rpt
│   │   ├── power.rpt
│   │   ├── timing.rpt
│   │   └── hierarchy.rpt
│   │
│   └── netlist/
│
├── constraints/
│   └── constraints_top.sdc
│
├── images/
│   ├── rtl_waveform.png
│   ├── synthesis.png
│   ├── area.png
│   └── timing.png
│
└── docs/
    └── Day7_DFF_Report.pdf
```

---

# 38. Industry Relevance

D flip-flops are fundamental components of digital ICs.

They are used in:

* Registers
* Counters
* Shift registers
* Pipeline stages
* State machines
* Control logic
* Processor datapaths
* Communication systems
* Memory-control structures
* ASIC and FPGA designs

Understanding reset and enable behavior is essential for RTL design because real digital systems require controlled initialization and conditional state updates.

---

# 39. GATE Relevance

This project is directly related to Digital Logic topics such as:

### Sequential Circuits

* Flip-flops
* D flip-flop
* Clocking
* State storage

### Timing

* Setup time
* Hold time
* Clock edge
* Propagation delay

### Counters and Registers

A DFF is the basic building block of:

```text
DFF
 ↓
Register
 ↓
Counter / Shift Register / FSM / Pipeline
```

---

# 40. Interview Questions

### Basic

1. What is a D flip-flop?
2. Why is a D flip-flop called a storage element?
3. What is the difference between a latch and a flip-flop?
4. What is positive-edge triggering?
5. What is the function of reset?
6. What is the purpose of enable?

### RTL

7. Why are nonblocking assignments used for sequential logic?
8. What is the difference between synchronous and asynchronous reset?
9. How is reset priority implemented?
10. What happens when enable is `0`?
11. Why is the clock placed in the sensitivity list?

### Synthesis

12. How does a DFF map to a standard cell?
13. What is a technology-mapped netlist?
14. Why can additional combinational cells appear around a DFF?
15. What does `SDFFRHQX1` indicate by its cell naming?

### Timing

16. What is setup time?
17. What is hold time?
18. What is timing slack?
19. What does positive slack mean?
20. Why should scan-enable timing not automatically be treated as functional D-to-Q timing?

### PPA

21. What is PPA?
22. Why can sequential cells dominate area?
23. What contributes to register power?
24. What contributes to clock power?
25. How can a sequential design be optimized for power?

---

# 41. Tiny Memory

Remember these five points:

```text
1. DFF stores one bit.
2. Positive-edge DFF updates at ↑CLK.
3. Reset initializes the state.
4. Enable controls whether D is captured.
5. Sequential RTL normally uses nonblocking assignments.
```

### Priority

```text
RESET
  ↓
ENABLE
  ↓
DATA
```

### Core equation

```text
Q(next) = D
```

when reset is inactive and enable is active at the sampling edge.

---

# 42. Learning Outcome

After completing Day 7, the following concepts are strengthened:

* Sequential logic
* D flip-flop operation
* Clock-edge behavior
* Reset control
* Enable control
* Reset priority
* State retention
* Synthesizable sequential Verilog
* RTL-to-gate mapping
* Standard-cell analysis
* Area analysis
* Power analysis
* Timing slack interpretation
* ASIC synthesis flow
* PPA analysis
* Timing-report limitations

---

# 43. Project Status

```text
┌─────────────────────────────────────────────┐
│           DAY 7 PROJECT STATUS              │
├─────────────────────────────────────────────┤
│ Specification       : COMPLETED             │
│ Architecture        : COMPLETED             │
│ RTL                 : COMPLETED             │
│ Hierarchy           : COMPLETED             │
│ Synthesis           : COMPLETED             │
│ Technology Mapping  : COMPLETED             │
│ Area Analysis       : COMPLETED             │
│ Power Analysis      : COMPLETED             │
│ Timing Analysis     : COMPLETED             │
│ Functional Timing   : NOT ESTABLISHED       │
│ Simulation Evidence  : NOT SUPPLIED          │
│ Optimization        : NOT STARTED            │
│ Documentation       : COMPLETED             │
└─────────────────────────────────────────────┘
```

---

# 44. Final Day-7 Results

## Area

```text
Total Instances = 5

Total Area = 176.299
```

## Sequential Area

```text
Sequential Area = 136.382

Sequential Area = 77.4%
```

## Power

```text
Total Power = 14.6277 µW
```

Breakdown:

```text
Register = 12.6881 µW
Clock    = 1.49591 µW
Logic    = 0.44366 µW
```

## Timing

```text
Reported Setup Slack = +7.219 ns
```

Path:

```text
en → ASYNC_DFF/q_reg/SE
```

Status:

```text
MET
```

### Final PPA Table

| Metric               |         Result |
| -------------------- | -------------: |
| Area                 |    **176.299** |
| Power                | **14.6277 µW** |
| Sequential Area      |    **136.382** |
| Sequential Area %    |      **77.4%** |
| Instances            |          **5** |
| Reported Setup Slack |  **+7.219 ns** |

> **Timing qualification:** The reported timing path is an `en → SE` scan-enable setup path. It does not establish the functional D-to-Q critical path or maximum functional frequency.

---

# 45. Next Project — Day 8

## Day 8 — 4-bit Register with Enable

The next project extends the DFF concept from a single-bit storage element to a multi-bit register.

Conceptually:

```text
             4-bit Data
             D[3:0]
                │
                ▼
        +---------------+
        | 4-bit Register|
        |               |
 CLK -->|               |--> Q[3:0]
 EN  -->|               |
        +---------------+
```

The Day-8 focus will be:

```text
DFF
 ↓
4-bit Register
 ↓
Enable-controlled storage
 ↓
RTL
 ↓
Verification
 ↓
Synthesis
 ↓
Timing
 ↓
Power
 ↓
PPA
```

---

# 46. Author

**Omkar Kalmesh Hadapad**

B.E. Electronics & Communication Engineering
SDM Institute of Technology, Ujire, Karnataka

**Focus Areas:**

```text
Digital VLSI
RTL Design
Verilog HDL
ASIC Design
Design Verification
Cadence Genus
Cadence Innovus
PPA Optimization
```

---

<p align="center">
  <b>DAY 7 — D FLIP-FLOP WITH RESET & ENABLE</b>
</p>

<p align="center">
  <code>RTL → Synthesis → Mapping → Area → Power → Timing → PPA</code>
</p>

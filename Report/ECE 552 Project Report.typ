#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "ECE 552 Project Report",
  authors: (
    (name: "Daniel Zhao", email: "daniel.zhao@wisc.edu"),
    (name: "Yilun Kang", email: "ykang232@wisc.edu"),
    (name: "Rui Feng", email: "rfeng34@wisc.edu"),
  ),
  date: "December 18, 2023",
)

= Overview

The project contains a CPU that supports 5-level pipelining using the given ISA. The CPU could perform sequential tasks quite well, though there were unsolved issues during loops that were pending to be fixed. The CPU has been configured to be working with a multicycle memory. A brief diagram of the internal components of the CPU is shown below: 

#figure(
  image(
    "Block Diagram.svg",
    alt: "Block Diagram",
  ),
  caption: "CPU Diagram",
)

= Responsibility Breakdown

A brief breakdown of the responsibilities of each team member is shown in the below table: 

#figure(
  tablex(
    columns: 4,
    [Project Phase], [Name], [Estimate Percentage Responsibility], [Details], 
    rowspanx(3)[Phase 1], [Daniel Zhao], [$80%$], [
      - Write out detailed implementation of Register File with forwarding support that could be triggered. 
      - Write out the implementation of individual ALU units and the overall ALU structure with flag registers
      - Write out the implementation of the single-cycle CPU with the given ISA. 
    ], 
    (), [Yilun Kang], [$20%^*$], [
      - Helped create the decode logic for an individual instruction. 
    ], 
    (), [Rui Feng], [$0%^dagger$], [
      - None
    ],
    rowspanx(3)[Phase 2], [Daniel Zhao], [$90%$], [
      - Implemented the pipeline registers and the forwarding logic.
      - Implemented the branch prediction logic.
      - Implemented the hazard detection logic.
      - Implemented the stall logic.
      - Implemented the flush logic.
      - Completed the implementation of the pipeline CPU with the given ISA.
    ], 
    (), [Yilun Kang], [$10%^*$], [
      - Helped create the logic for the forwarding unit. 
    ], 
    (), [Rui Feng], [$0%^dagger$], [
      - None
    ],
    rowspanx(3)[Phase 3], [Daniel Zhao], [$80%$], [
      - Implemented a generalized cache with the given requirements that would send requests automatically. 
      - Implemented a bus logic that would handle the requests from the cache and the memory.
      - Updated the CPU to support the multicycle memory with cache. 
    ], 
    (), [Yilun Kang], [$20%^*$], [
      - Helped write out a (non-working) prototype of the cache.  
    ], 
    (), [Rui Feng], [$0%^dagger$], [
      - None
    ],
  ),
  caption: "Responsibility Breakdown Table",
)

#footnote([Yilun was perfectly good at understanding the underlying concepts of the project and could produce a decent prototype using Verilog. This genuinely does come as a surprise as he is a first-time learner of the language. However, due to not being familiar enough with English, though understandable as he is a VISP and English is his second language, most of the time his designs failed to comply with the requirement and would require additional time for fixing the issues and making them working towards the project. He also have the tendency to give up on optimizing his own design when a better solution is being purposed. This is why he is given a lower responsibility percentage.])
#footnote([Rui claimed to be ill and was not able to contribute towards the group project. Strangely enough, that is his reason for all three phases of the project, though his work was covered by Daniel. ])

= Special Features

The CPU designed has mainly followed the requirements of the design. While some ideas were purposed to optimize the CPU to allow it to perform better, they were not implemented due to the lack of time. When implementing the CPU, some of the difficulties that were encountered were the implementation of the stall and flush logic. Though the current prototype CPU could perform these tasks occasionally, it was not able to perform them consistently, and there were often times where the CPU repeat the execution of the same instruction twice. This is a problem that is still pending to be fixed.

= Completeness

== Phase 1

All of the requirements were met in Phase 1. The CPU was able to perform the given instructions correctly. 

== Phase 2

The CPU in Phase 2 was having some trouble performing loops on the case of flushes and stalls. This problem was not found during the demonstration of Phase 2, though this problem was eventually found during the testing of Phase 3. The CPU was able to perform the given instructions correctly. 

== Phase 3

The CPU in Phase 3 was able to perform the given instructions correctly. However, the CPU was not able to perform loops correctly. This is due to the fact that the CPU was not able to perform flushes and stalls correctly. This have lead to one of the tests being failed, while the other tests were passed.

= Testing

The designs were tested at their basic units at first, and then were tested as a whole. For sequential logical blocks, a random/complete set of inputs were given to the block to test if the block was working correctly. For combinational logical blocks, the blocks were being tested for their functionality as a small simulation for the basics of the block were being performed. 

= Results

== Cache test

The caches was tested by checking whether they could perform a read or a write correctly, the waveform result from the test is shown below:

#figure(
  image(
    "cache_read_test.png",
    alt: "Cache Test",
  ),
  caption: "Cache Read Test Waveform",
)

#figure(
  image(
    "cache_write_test.png",
    alt: "Cache Test",
  ),
  caption: "Cache Write Test Waveform",
)

There are no errors detected in the cache test.

== CPU test program 1

The CPU was tested by running the given test program 1. The waveform result from the test is shown below:

#figure(
  image(
    "test1_wave.png",
    alt: "CPU Test 1",
  ),
  caption: "CPU Test 1 Waveform",
)

The results of the test program 1 could be found in the log file and the trace files, both of which were attached in the project submission and in the Appendix. A brief summary of the results is shown below:

#figure(
  table(
    columns: 6,
    [Cycles], [Instructions], [Data Cache Hits], [Instruction Cache Hits], [Data Cache Requests], [Instruction Cache Requests],
    [55], [49], [0], [13], [0], [15]
  ),
  caption: "CPU Test 1 Results",
)

== CPU test program 2

The CPU was tested by running the given test program 2. The waveform result from the test is shown below:

#figure(
  image(
    "test2_wave.png",
    alt: "CPU Test 2",
  ),
  caption: "CPU Test 2 Waveform",
)

The results of the test program 2 could be found in the log file and the trace files, both of which were attached in the project submission and in the Appendix. A brief summary of the results is shown below:

#figure(
  table(
    columns: 6,
    [Cycles], [Instructions], [Data Cache Hits], [Instruction Cache Hits], [Data Cache Requests], [Instruction Cache Requests],
    [72], [65], [2], [14], [3], [16]
  ),
  caption: "CPU Test 2 Results",
)

== CPU test program 3

The CPU was tested by running the given test program 3. The waveform result from the test is shown below:

#figure(
  image(
    "test3_wave.png",
    alt: "CPU Test 3",
  ),
  caption: "CPU Test 3 Waveform",
)

The results of the test program 3 could be found in the log file and the trace files, both of which were attached in the project submission and in the Appendix. A brief summary of the results is shown below:

#figure(
  table(
    columns: 6,
    [Cycles], [Instructions], [Data Cache Hits], [Instruction Cache Hits], [Data Cache Requests], [Instruction Cache Requests],
    [71], [62], [0], [21], [0], [23]
  ),
  caption: "CPU Test 3 Results",
)

== CPU test program 4

The CPU was tested by running the given test program 4. The waveform result from the test is shown below:

#figure(
  image(
    "test4_wave.png",
    alt: "CPU Test 4",
  ),
  caption: "CPU Test 4 Waveform",
)

The results of the test program 4 could be found in the log file and the trace files, both of which were attached in the project submission and in the Appendix. A brief summary of the results is shown below:

#figure(
  table(
    columns: 6,
    [Cycles], [Instructions], [Data Cache Hits], [Instruction Cache Hits], [Data Cache Requests], [Instruction Cache Requests],
    [338], [294], [28], [135], [31], [140]
  ),
  caption: "CPU Test 4 Results",
)

I believe that this test was not passed due to the fact that the CPU enters the fail section of the code, which indicates that our CPU was unable to perform the given instructions correctly. A brief loop at the code and the waveform shows that the problems were caused by the CPU not being able to perform the flushes and stalls correctly.

= Extra Credit Synthesis

No Extra Credit Synthesis was performed due to the lack of time.

= Extra Credit Features

No Extra Credit Features were implemented due to the lack of time.

= Verilog Files

The Verilog files are attached in the project submission. It contains all of the files that were used in the project in Phase 3. The files being used in Phase 1 and Phase 2 are also included in previous submissions.

= Acknowledgements

I would like to thank the following people for their help in the project:
- Professor Joshua San Miguel for his guidance in the project.
- The TA Zhewen for her help in the project.
- The authors of the textbook for their help in the project.
- My friend (Paridhi) for her help in our project. 
- Myself (Daniel) for completing most of the project under the name of my teammates.

#pagebreak()

= Appendix

== Test Program 1 Log File

```text
SIMLOG:: Cycle           4 PC: 00000000 I: 00000000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           5 PC: 00000000 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           6 PC: 00000000 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           7 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           8 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           9 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          10 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          11 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          12 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          13 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          14 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          15 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          16 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          17 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          18 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          19 PC: 00000002 I: 0000a151 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          20 PC: 00000002 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          21 PC: 00000004 I: 0000b151 R: 1   0 00000000 M: 0 0 00000051 00000000 00000000
SIMLOG:: Cycle          22 PC: 00000004 I: 00007000 R: 1   1 00000051 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          23 PC: 00000006 I: 0000a2b0 R: 1   0 00000000 M: 0 0 00005151 00000000 00000000
SIMLOG:: Cycle          24 PC: 00000006 I: 00007000 R: 1   1 00005151 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          25 PC: 00000008 I: 0000b2a0 R: 1   0 00000000 M: 0 0 000000b0 00000000 00000000
SIMLOG:: Cycle          26 PC: 00000008 I: 00007000 R: 1   2 000000b0 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          27 PC: 0000000a I: 00000321 R: 1   0 00000000 M: 0 0 0000a0b0 00000000 00000000
SIMLOG:: Cycle          28 PC: 0000000a I: 00007000 R: 1   2 0000a0b0 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          29 PC: 0000000c I: 00001412 R: 1   0 00000000 M: 0 0 0000f201 00005151 00000000
SIMLOG:: Cycle          30 PC: 0000000c I: 00007000 R: 1   3 0000f201 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          31 PC: 0000000e I: 00002634 R: 1   0 00000000 M: 0 0 00007fff 0000a0b0 00000000
SIMLOG:: Cycle          32 PC: 0000000e I: 00007000 R: 1   4 00007fff M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          33 PC: 00000010 I: 00004756 R: 1   0 00000000 M: 0 0 00008dfe 00000000 00000000
SIMLOG:: Cycle          34 PC: 00000010 I: 00007000 R: 1   6 00008dfe M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          35 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          36 PC: 00000010 I: 00007000 R: 1   7 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          37 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          38 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          39 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          40 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          41 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          42 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          43 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          44 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          45 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          46 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          47 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          48 PC: 00000012 I: 00005862 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          49 PC: 00000012 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          50 PC: 00000014 I: 0000698a R: 1   0 00000000 M: 0 0 0000e37f 0000a0b0 00000000
SIMLOG:: Cycle          51 PC: 00000014 I: 00007000 R: 1   8 0000e37f M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          52 PC: 00000014 I: 0000f000 R: 1   0 00000000 M: 0 0 0000dff8 00000000 00000000
SIMLOG:: Cycle          53 PC: 00000014 I: 00007000 R: 1   9 0000dff8 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          54 PC: 00000014 I: 0000f000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          55 PC: 00000014 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Processor halted

SIMLOG:: sim_cycles          55

SIMLOG:: inst_count          49

SIMLOG:: dcachehit_count           0

SIMLOG:: icachehit_count          13

SIMLOG:: dcachereq_count           0

SIMLOG:: icachereq_count          15


```

== Test Program 1 Trace File

```text
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0051
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x5151
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x00b0
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0xa0b0
REG:  0 VALUE: 0x0000
REG:  3 VALUE: 0xf201
REG:  0 VALUE: 0x0000
REG:  4 VALUE: 0x7fff
REG:  0 VALUE: 0x0000
REG:  6 VALUE: 0x8dfe
REG:  0 VALUE: 0x0000
REG:  7 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  8 VALUE: 0xe37f
REG:  0 VALUE: 0x0000
REG:  9 VALUE: 0xdff8
REG:  0 VALUE: 0x0000
```

== Test Program 2 Log File

```text
SIMLOG:: Cycle           4 PC: 00000000 I: 00000000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           5 PC: 00000000 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           6 PC: 00000000 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           7 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           8 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           9 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          10 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          11 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          12 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          13 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          14 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          15 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          16 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          17 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          18 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          19 PC: 00000002 I: 0000a151 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          20 PC: 00000002 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          21 PC: 00000004 I: 0000b151 R: 1   0 00000000 M: 0 0 00000051 00000000 00000000
SIMLOG:: Cycle          22 PC: 00000004 I: 00007000 R: 1   1 00000051 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          23 PC: 00000006 I: 0000a2b0 R: 1   0 00000000 M: 0 0 00005151 00000000 00000000
SIMLOG:: Cycle          24 PC: 00000006 I: 00007000 R: 1   1 00005151 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          25 PC: 00000008 I: 0000b200 R: 1   0 00000000 M: 0 0 000000b0 00000000 00000000
SIMLOG:: Cycle          26 PC: 00000008 I: 00007000 R: 1   2 000000b0 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          27 PC: 0000000a I: 0000a304 R: 1   0 00000000 M: 0 0 000000b0 00000000 00000000
SIMLOG:: Cycle          28 PC: 0000000a I: 00007000 R: 1   2 000000b0 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          29 PC: 0000000c I: 0000b300 R: 1   0 00000000 M: 0 0 00000004 00000000 00000000
SIMLOG:: Cycle          30 PC: 0000000c I: 00007000 R: 1   3 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          31 PC: 0000000e I: 00009122 R: 1   0 00000000 M: 0 0 00000004 00000000 00000000
SIMLOG:: Cycle          32 PC: 0000000e I: 00007000 R: 1   3 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          33 PC: 00000010 I: 00000523 R: 1   0 00000000 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          34 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          35 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          36 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          37 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          38 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          39 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          40 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          41 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          42 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          43 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          44 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          45 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          46 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          47 PC: 00000010 I: 00000523 R: 0   1 000000b4 M: 0 1 000000b4 00005151 00000000
SIMLOG:: Cycle          48 PC: 00000010 I: 00007000 R: 0   1 000000b4 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          49 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 000000b4 00000004 00000000
SIMLOG:: Cycle          50 PC: 00000010 I: 00007000 R: 1   5 000000b4 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          51 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          52 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          53 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          54 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          55 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          56 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          57 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          58 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          59 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          60 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          61 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          62 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          63 PC: 00000012 I: 00008450 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          64 PC: 00000012 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          65 PC: 00000014 I: 00007542 R: 1   0 00000000 M: 1 0 000000b4 00000000 00000000
SIMLOG:: Cycle          66 PC: 00000014 I: 00007542 R: 1   4 00000000 M: 1 0 000000b4 00000000 00005151
SIMLOG:: Cycle          67 PC: 00000016 I: 00003555 R: 1   4 00005151 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          68 PC: 00000016 I: 00007000 R: 1   0 00000000 M: 0 0 00005101 000000b0 00000000
SIMLOG:: Cycle          69 PC: 00000016 I: 0000f000 R: 1   5 00005101 M: 0 0 000000a4 00005101 00000000
SIMLOG:: Cycle          70 PC: 00000016 I: 00007000 R: 1   5 000000a4 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          71 PC: 00000016 I: 0000f000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          72 PC: 00000016 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Processor halted

SIMLOG:: sim_cycles          72

SIMLOG:: inst_count          65

SIMLOG:: dcachehit_count           2

SIMLOG:: icachehit_count          14

SIMLOG:: dcachereq_count           3

SIMLOG:: icachereq_count          16

```

== Test Program 2 Trace File

```text
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0051
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x5151
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x00b0
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x00b0
REG:  0 VALUE: 0x0000
REG:  3 VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  3 VALUE: 0x0004
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
STORE: ADDR: 0x00b4 VALUE: 0x5151
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x00b4
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x00b4 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x00b4 VALUE: 0x5151
REG:  4 VALUE: 0x5151
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x5101
REG:  5 VALUE: 0x00a4
REG:  0 VALUE: 0x0000
```

== Test Program 3 Log File

```text
SIMLOG:: Cycle           4 PC: 00000000 I: 00000000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           5 PC: 00000000 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           6 PC: 00000000 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           7 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           8 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           9 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          10 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          11 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          12 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          13 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          14 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          15 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          16 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          17 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          18 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          19 PC: 00000002 I: 0000a102 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          20 PC: 00000002 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          21 PC: 00000004 I: 0000b100 R: 1   0 00000000 M: 0 0 00000002 00000000 00000000
SIMLOG:: Cycle          22 PC: 00000004 I: 00007000 R: 1   1 00000002 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          23 PC: 00000006 I: 0000a201 R: 1   0 00000000 M: 0 0 00000002 00000000 00000000
SIMLOG:: Cycle          24 PC: 00000006 I: 00007000 R: 1   1 00000002 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          25 PC: 00000008 I: 0000b200 R: 1   0 00000000 M: 0 0 00000001 00000002 00000000
SIMLOG:: Cycle          26 PC: 00000008 I: 00007000 R: 1   2 00000001 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          27 PC: 0000000a I: 0000a604 R: 1   0 00000000 M: 0 0 00000001 00000000 00000000
SIMLOG:: Cycle          28 PC: 0000000a I: 00007000 R: 1   2 00000001 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          29 PC: 0000000c I: 0000b600 R: 1   0 00000000 M: 0 0 00000004 00000000 00000000
SIMLOG:: Cycle          30 PC: 0000000c I: 00007000 R: 1   6 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          31 PC: 0000000e I: 00001112 R: 1   0 00000000 M: 0 0 00000004 00000000 00000000
SIMLOG:: Cycle          32 PC: 0000000e I: 00007000 R: 1   6 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          33 PC: 00000010 I: 0000e500 R: 1   0 00000000 M: 0 0 00000001 00000001 00000000
SIMLOG:: Cycle          34 PC: 00000010 I: 00007000 R: 1   1 00000001 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          35 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          36 PC: 00000010 I: 00007000 R: 1   5 00000010 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          37 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          38 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          39 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          40 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          41 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          42 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          43 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          44 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          45 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          46 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          47 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          48 PC: 00000012 I: 0000c202 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          49 PC: 00000012 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          50 PC: 00000014 I: 0000de60 R: 1   0 00000000 M: 0 0 00000000 00000001 00000000
SIMLOG:: Cycle          51 PC: 00000004 I: 00007000 R: 0   2 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          52 PC: 00000006 I: 0000a201 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          53 PC: 00000006 I: 00007000 R: 0  14 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          54 PC: 00000008 I: 0000b200 R: 1   0 00000000 M: 0 0 00000001 00000001 00000000
SIMLOG:: Cycle          55 PC: 00000008 I: 00007000 R: 1   2 00000001 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          56 PC: 0000000a I: 0000a604 R: 1   0 00000000 M: 0 0 00000001 00000000 00000000
SIMLOG:: Cycle          57 PC: 0000000a I: 00007000 R: 1   2 00000001 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          58 PC: 0000000c I: 0000b600 R: 1   0 00000000 M: 0 0 00000004 00000000 00000000
SIMLOG:: Cycle          59 PC: 0000000c I: 00007000 R: 1   6 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          60 PC: 0000000e I: 00001112 R: 1   0 00000000 M: 0 0 00000004 00000000 00000000
SIMLOG:: Cycle          61 PC: 0000000e I: 00007000 R: 1   6 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          62 PC: 00000010 I: 0000e500 R: 1   0 00000000 M: 0 0 00000000 00000001 00000000
SIMLOG:: Cycle          63 PC: 00000010 I: 00007000 R: 1   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          64 PC: 00000012 I: 0000c202 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          65 PC: 00000016 I: 00007000 R: 1   5 00000010 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          66 PC: 00000018 I: 00000462 R: 1   0 00000000 M: 0 0 00000000 00000001 00000000
SIMLOG:: Cycle          67 PC: 00000018 I: 00007000 R: 0   2 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          68 PC: 00000018 I: 0000f000 R: 1   0 00000000 M: 0 0 00000005 00000001 00000000
SIMLOG:: Cycle          69 PC: 00000018 I: 00007000 R: 1   4 00000005 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          70 PC: 00000018 I: 0000f000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          71 PC: 00000018 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Processor halted

SIMLOG:: sim_cycles          71

SIMLOG:: inst_count          62

SIMLOG:: dcachehit_count           0

SIMLOG:: icachehit_count          21

SIMLOG:: dcachereq_count           0

SIMLOG:: icachereq_count          23

```

== Test Program 3 Trace File

```text
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0002
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0002
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0001
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0001
REG:  0 VALUE: 0x0000
REG:  6 VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  6 VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0001
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0001
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0001
REG:  0 VALUE: 0x0000
REG:  6 VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  6 VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  4 VALUE: 0x0005
REG:  0 VALUE: 0x0000
```

== Test Program 4 Log File

```text
SIMLOG:: Cycle           4 PC: 00000000 I: 00000000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           5 PC: 00000000 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           6 PC: 00000000 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           7 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           8 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle           9 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          10 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          11 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          12 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          13 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          14 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          15 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          16 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          17 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          18 PC: 00000000 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          19 PC: 00000002 I: 0000a18a R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          20 PC: 00000002 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          21 PC: 00000004 I: 0000a680 R: 1   0 00000000 M: 0 0 0000008a 00000000 00000000
SIMLOG:: Cycle          22 PC: 00000004 I: 00007000 R: 1   1 0000008a M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          23 PC: 00000006 I: 0000b601 R: 1   0 00000000 M: 0 0 00000080 00000000 00000000
SIMLOG:: Cycle          24 PC: 00000006 I: 00007000 R: 1   6 00000080 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          25 PC: 00000008 I: 00009160 R: 1   0 00000000 M: 0 0 00000180 0000008a 00000000
SIMLOG:: Cycle          26 PC: 00000008 I: 00007000 R: 1   6 00000180 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          27 PC: 0000000a I: 0000a110 R: 1   0 00000000 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          28 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          29 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          30 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          31 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          32 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          33 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          34 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          35 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          36 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          37 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          38 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          39 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          40 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          41 PC: 0000000a I: 0000a110 R: 0   1 00000180 M: 0 1 00000180 0000008a 00000000
SIMLOG:: Cycle          42 PC: 0000000a I: 00007000 R: 0   1 00000180 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          43 PC: 0000000c I: 0000a270 R: 1   0 00000000 M: 0 0 00000010 00000000 00000000
SIMLOG:: Cycle          44 PC: 0000000c I: 00007000 R: 1   1 00000010 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          45 PC: 0000000e I: 0000a302 R: 1   0 00000000 M: 0 0 00000070 00000000 00000000
SIMLOG:: Cycle          46 PC: 0000000e I: 00007000 R: 1   2 00000070 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          47 PC: 00000010 I: 00009120 R: 1   0 00000000 M: 0 0 00000002 00000000 00000000
SIMLOG:: Cycle          48 PC: 00000010 I: 00007000 R: 1   3 00000002 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          49 PC: 00000010 I: 00007000 R: 1   0 00000000 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          50 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          51 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          52 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          53 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          54 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          55 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          56 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          57 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          58 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          59 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          60 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          61 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          62 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          63 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          64 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          65 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          66 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          67 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          68 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          69 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          70 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          71 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          72 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          73 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          74 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          75 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          76 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 1 00000070 00000010 00000000
SIMLOG:: Cycle          77 PC: 00000010 I: 00007000 R: 0   1 00000070 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          78 PC: 00000012 I: 00000223 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          79 PC: 00000012 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          80 PC: 00000014 I: 00001113 R: 1   0 00000000 M: 0 0 00000072 00000002 00000000
SIMLOG:: Cycle          81 PC: 00000014 I: 00007000 R: 1   2 00000072 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          82 PC: 00000016 I: 0000c1fc R: 1   0 00000000 M: 0 0 0000000e 00000002 00000000
SIMLOG:: Cycle          83 PC: 0000000e I: 00007000 R: 1   1 0000000e M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          84 PC: 00000010 I: 00009120 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          85 PC: 00000010 I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          86 PC: 00000012 I: 00000223 R: 1   0 00000000 M: 0 1 00000072 0000000e 00000000
SIMLOG:: Cycle          87 PC: 00000012 I: 00000223 R: 0   1 00000072 M: 0 1 00000072 0000000e 00000000
SIMLOG:: Cycle          88 PC: 00000014 I: 00001113 R: 0   1 00000072 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          89 PC: 00000014 I: 00007000 R: 1   0 00000000 M: 0 0 00000074 00000002 00000000
SIMLOG:: Cycle          90 PC: 00000016 I: 0000c1fc R: 1   2 00000074 M: 0 0 0000000c 00000002 00000000
SIMLOG:: Cycle          91 PC: 0000000e I: 00007000 R: 1   1 0000000c M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          92 PC: 00000010 I: 00009120 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          93 PC: 00000010 I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          94 PC: 00000012 I: 00000223 R: 1   0 00000000 M: 0 1 00000074 0000000c 00000000
SIMLOG:: Cycle          95 PC: 00000012 I: 00000223 R: 0   1 00000074 M: 0 1 00000074 0000000c 00000000
SIMLOG:: Cycle          96 PC: 00000014 I: 00001113 R: 0   1 00000074 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle          97 PC: 00000014 I: 00007000 R: 1   0 00000000 M: 0 0 00000076 00000002 00000000
SIMLOG:: Cycle          98 PC: 00000016 I: 0000c1fc R: 1   2 00000076 M: 0 0 0000000a 00000002 00000000
SIMLOG:: Cycle          99 PC: 0000000e I: 00007000 R: 1   1 0000000a M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         100 PC: 00000010 I: 00009120 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         101 PC: 00000010 I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         102 PC: 00000012 I: 00000223 R: 1   0 00000000 M: 0 1 00000076 0000000a 00000000
SIMLOG:: Cycle         103 PC: 00000012 I: 00000223 R: 0   1 00000076 M: 0 1 00000076 0000000a 00000000
SIMLOG:: Cycle         104 PC: 00000014 I: 00001113 R: 0   1 00000076 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         105 PC: 00000014 I: 00007000 R: 1   0 00000000 M: 0 0 00000078 00000002 00000000
SIMLOG:: Cycle         106 PC: 00000016 I: 0000c1fc R: 1   2 00000078 M: 0 0 00000008 00000002 00000000
SIMLOG:: Cycle         107 PC: 0000000e I: 00007000 R: 1   1 00000008 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         108 PC: 00000010 I: 00009120 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         109 PC: 00000010 I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         110 PC: 00000012 I: 00000223 R: 1   0 00000000 M: 0 1 00000078 00000008 00000000
SIMLOG:: Cycle         111 PC: 00000012 I: 00000223 R: 0   1 00000078 M: 0 1 00000078 00000008 00000000
SIMLOG:: Cycle         112 PC: 00000014 I: 00001113 R: 0   1 00000078 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         113 PC: 00000014 I: 00007000 R: 1   0 00000000 M: 0 0 0000007a 00000002 00000000
SIMLOG:: Cycle         114 PC: 00000016 I: 0000c1fc R: 1   2 0000007a M: 0 0 00000006 00000002 00000000
SIMLOG:: Cycle         115 PC: 0000000e I: 00007000 R: 1   1 00000006 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         116 PC: 00000010 I: 00009120 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         117 PC: 00000010 I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         118 PC: 00000012 I: 00000223 R: 1   0 00000000 M: 0 1 0000007a 00000006 00000000
SIMLOG:: Cycle         119 PC: 00000012 I: 00000223 R: 0   1 0000007a M: 0 1 0000007a 00000006 00000000
SIMLOG:: Cycle         120 PC: 00000014 I: 00001113 R: 0   1 0000007a M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         121 PC: 00000014 I: 00007000 R: 1   0 00000000 M: 0 0 0000007c 00000002 00000000
SIMLOG:: Cycle         122 PC: 00000016 I: 0000c1fc R: 1   2 0000007c M: 0 0 00000004 00000002 00000000
SIMLOG:: Cycle         123 PC: 0000000e I: 00007000 R: 1   1 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         124 PC: 00000010 I: 00009120 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         125 PC: 00000010 I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         126 PC: 00000012 I: 00000223 R: 1   0 00000000 M: 0 1 0000007c 00000004 00000000
SIMLOG:: Cycle         127 PC: 00000012 I: 00000223 R: 0   1 0000007c M: 0 1 0000007c 00000004 00000000
SIMLOG:: Cycle         128 PC: 00000014 I: 00001113 R: 0   1 0000007c M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         129 PC: 00000014 I: 00007000 R: 1   0 00000000 M: 0 0 0000007e 00000002 00000000
SIMLOG:: Cycle         130 PC: 00000016 I: 0000c1fc R: 1   2 0000007e M: 0 0 00000002 00000002 00000000
SIMLOG:: Cycle         131 PC: 0000000e I: 00007000 R: 1   1 00000002 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         132 PC: 00000010 I: 00009120 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         133 PC: 00000010 I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         134 PC: 00000012 I: 00000223 R: 1   0 00000000 M: 0 1 0000007e 00000002 00000000
SIMLOG:: Cycle         135 PC: 00000012 I: 00000223 R: 0   1 0000007e M: 0 1 0000007e 00000002 00000000
SIMLOG:: Cycle         136 PC: 00000014 I: 00001113 R: 0   1 0000007e M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         137 PC: 00000014 I: 00007000 R: 1   0 00000000 M: 0 0 00000080 00000002 00000000
SIMLOG:: Cycle         138 PC: 00000016 I: 0000c1fc R: 1   2 00000080 M: 0 0 00000000 00000002 00000000
SIMLOG:: Cycle         139 PC: 00000016 I: 00007000 R: 1   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         140 PC: 00000018 I: 0000a110 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         141 PC: 00000018 I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         142 PC: 0000001a I: 0000a270 R: 1   0 00000000 M: 0 0 00000010 00000000 00000000
SIMLOG:: Cycle         143 PC: 0000001a I: 00007000 R: 1   1 00000010 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         144 PC: 0000001c I: 0000a580 R: 1   0 00000000 M: 0 0 00000070 00000000 00000000
SIMLOG:: Cycle         145 PC: 0000001c I: 00007000 R: 1   2 00000070 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         146 PC: 0000001e I: 00008420 R: 1   0 00000000 M: 0 0 00000080 00000000 00000000
SIMLOG:: Cycle         147 PC: 0000001e I: 00007000 R: 1   5 00000080 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         148 PC: 00000020 I: 00000223 R: 1   0 00000000 M: 1 0 00000070 00000000 00000000
SIMLOG:: Cycle         149 PC: 00000020 I: 00000223 R: 1   4 00000000 M: 1 0 00000070 00000000 00000010
SIMLOG:: Cycle         150 PC: 00000020 I: 00007000 R: 1   4 00000010 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         151 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000072 00000002 00000000
SIMLOG:: Cycle         152 PC: 00000020 I: 00007000 R: 1   2 00000072 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         153 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         154 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         155 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         156 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         157 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         158 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         159 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         160 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         161 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         162 PC: 00000020 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         163 PC: 00000022 I: 00009450 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         164 PC: 00000022 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         165 PC: 00000024 I: 00000553 R: 1   0 00000000 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         166 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         167 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         168 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         169 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         170 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         171 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         172 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         173 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         174 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         175 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         176 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         177 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         178 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         179 PC: 00000024 I: 00000553 R: 0   4 00000080 M: 0 1 00000080 00000010 00000000
SIMLOG:: Cycle         180 PC: 00000024 I: 00007000 R: 0   4 00000080 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         181 PC: 00000026 I: 00001113 R: 1   0 00000000 M: 0 0 00000082 00000002 00000000
SIMLOG:: Cycle         182 PC: 00000026 I: 00007000 R: 1   5 00000082 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         183 PC: 00000028 I: 0000c1fa R: 1   0 00000000 M: 0 0 0000000e 00000002 00000000
SIMLOG:: Cycle         184 PC: 0000001c I: 00007000 R: 1   1 0000000e M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         185 PC: 0000001e I: 00008420 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         186 PC: 0000001e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         187 PC: 00000020 I: 00000223 R: 1   0 00000000 M: 1 0 00000072 00000000 00000000
SIMLOG:: Cycle         188 PC: 00000020 I: 00000223 R: 1   4 00000000 M: 1 0 00000072 00000000 0000000e
SIMLOG:: Cycle         189 PC: 00000022 I: 00009450 R: 1   4 0000000e M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         190 PC: 00000022 I: 00007000 R: 1   0 00000000 M: 0 0 00000074 00000002 00000000
SIMLOG:: Cycle         191 PC: 00000024 I: 00000553 R: 1   2 00000074 M: 0 1 00000082 0000000e 00000000
SIMLOG:: Cycle         192 PC: 00000024 I: 00000553 R: 0   4 00000082 M: 0 1 00000082 0000000e 00000000
SIMLOG:: Cycle         193 PC: 00000026 I: 00001113 R: 0   4 00000082 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         194 PC: 00000026 I: 00007000 R: 1   0 00000000 M: 0 0 00000084 00000002 00000000
SIMLOG:: Cycle         195 PC: 00000028 I: 0000c1fa R: 1   5 00000084 M: 0 0 0000000c 00000002 00000000
SIMLOG:: Cycle         196 PC: 0000001c I: 00007000 R: 1   1 0000000c M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         197 PC: 0000001e I: 00008420 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         198 PC: 0000001e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         199 PC: 00000020 I: 00000223 R: 1   0 00000000 M: 1 0 00000074 00000000 00000000
SIMLOG:: Cycle         200 PC: 00000020 I: 00000223 R: 1   4 00000000 M: 1 0 00000074 00000000 0000000c
SIMLOG:: Cycle         201 PC: 00000022 I: 00009450 R: 1   4 0000000c M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         202 PC: 00000022 I: 00007000 R: 1   0 00000000 M: 0 0 00000076 00000002 00000000
SIMLOG:: Cycle         203 PC: 00000024 I: 00000553 R: 1   2 00000076 M: 0 1 00000084 0000000c 00000000
SIMLOG:: Cycle         204 PC: 00000024 I: 00000553 R: 0   4 00000084 M: 0 1 00000084 0000000c 00000000
SIMLOG:: Cycle         205 PC: 00000026 I: 00001113 R: 0   4 00000084 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         206 PC: 00000026 I: 00007000 R: 1   0 00000000 M: 0 0 00000086 00000002 00000000
SIMLOG:: Cycle         207 PC: 00000028 I: 0000c1fa R: 1   5 00000086 M: 0 0 0000000a 00000002 00000000
SIMLOG:: Cycle         208 PC: 0000001c I: 00007000 R: 1   1 0000000a M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         209 PC: 0000001e I: 00008420 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         210 PC: 0000001e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         211 PC: 00000020 I: 00000223 R: 1   0 00000000 M: 1 0 00000076 00000000 00000000
SIMLOG:: Cycle         212 PC: 00000020 I: 00000223 R: 1   4 00000000 M: 1 0 00000076 00000000 0000000a
SIMLOG:: Cycle         213 PC: 00000022 I: 00009450 R: 1   4 0000000a M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         214 PC: 00000022 I: 00007000 R: 1   0 00000000 M: 0 0 00000078 00000002 00000000
SIMLOG:: Cycle         215 PC: 00000024 I: 00000553 R: 1   2 00000078 M: 0 1 00000086 0000000a 00000000
SIMLOG:: Cycle         216 PC: 00000024 I: 00000553 R: 0   4 00000086 M: 0 1 00000086 0000000a 00000000
SIMLOG:: Cycle         217 PC: 00000026 I: 00001113 R: 0   4 00000086 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         218 PC: 00000026 I: 00007000 R: 1   0 00000000 M: 0 0 00000088 00000002 00000000
SIMLOG:: Cycle         219 PC: 00000028 I: 0000c1fa R: 1   5 00000088 M: 0 0 00000008 00000002 00000000
SIMLOG:: Cycle         220 PC: 0000001c I: 00007000 R: 1   1 00000008 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         221 PC: 0000001e I: 00008420 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         222 PC: 0000001e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         223 PC: 00000020 I: 00000223 R: 1   0 00000000 M: 1 0 00000078 00000000 00000000
SIMLOG:: Cycle         224 PC: 00000020 I: 00000223 R: 1   4 00000000 M: 1 0 00000078 00000000 00000008
SIMLOG:: Cycle         225 PC: 00000022 I: 00009450 R: 1   4 00000008 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         226 PC: 00000022 I: 00007000 R: 1   0 00000000 M: 0 0 0000007a 00000002 00000000
SIMLOG:: Cycle         227 PC: 00000024 I: 00000553 R: 1   2 0000007a M: 0 1 00000088 00000008 00000000
SIMLOG:: Cycle         228 PC: 00000024 I: 00000553 R: 0   4 00000088 M: 0 1 00000088 00000008 00000000
SIMLOG:: Cycle         229 PC: 00000026 I: 00001113 R: 0   4 00000088 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         230 PC: 00000026 I: 00007000 R: 1   0 00000000 M: 0 0 0000008a 00000002 00000000
SIMLOG:: Cycle         231 PC: 00000028 I: 0000c1fa R: 1   5 0000008a M: 0 0 00000006 00000002 00000000
SIMLOG:: Cycle         232 PC: 0000001c I: 00007000 R: 1   1 00000006 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         233 PC: 0000001e I: 00008420 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         234 PC: 0000001e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         235 PC: 00000020 I: 00000223 R: 1   0 00000000 M: 1 0 0000007a 00000000 00000000
SIMLOG:: Cycle         236 PC: 00000020 I: 00000223 R: 1   4 00000000 M: 1 0 0000007a 00000000 00000006
SIMLOG:: Cycle         237 PC: 00000022 I: 00009450 R: 1   4 00000006 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         238 PC: 00000022 I: 00007000 R: 1   0 00000000 M: 0 0 0000007c 00000002 00000000
SIMLOG:: Cycle         239 PC: 00000024 I: 00000553 R: 1   2 0000007c M: 0 1 0000008a 00000006 00000000
SIMLOG:: Cycle         240 PC: 00000024 I: 00000553 R: 0   4 0000008a M: 0 1 0000008a 00000006 00000000
SIMLOG:: Cycle         241 PC: 00000026 I: 00001113 R: 0   4 0000008a M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         242 PC: 00000026 I: 00007000 R: 1   0 00000000 M: 0 0 0000008c 00000002 00000000
SIMLOG:: Cycle         243 PC: 00000028 I: 0000c1fa R: 1   5 0000008c M: 0 0 00000004 00000002 00000000
SIMLOG:: Cycle         244 PC: 0000001c I: 00007000 R: 1   1 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         245 PC: 0000001e I: 00008420 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         246 PC: 0000001e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         247 PC: 00000020 I: 00000223 R: 1   0 00000000 M: 1 0 0000007c 00000000 00000000
SIMLOG:: Cycle         248 PC: 00000020 I: 00000223 R: 1   4 00000000 M: 1 0 0000007c 00000000 00000004
SIMLOG:: Cycle         249 PC: 00000022 I: 00009450 R: 1   4 00000004 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         250 PC: 00000022 I: 00007000 R: 1   0 00000000 M: 0 0 0000007e 00000002 00000000
SIMLOG:: Cycle         251 PC: 00000024 I: 00000553 R: 1   2 0000007e M: 0 1 0000008c 00000004 00000000
SIMLOG:: Cycle         252 PC: 00000024 I: 00000553 R: 0   4 0000008c M: 0 1 0000008c 00000004 00000000
SIMLOG:: Cycle         253 PC: 00000026 I: 00001113 R: 0   4 0000008c M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         254 PC: 00000026 I: 00007000 R: 1   0 00000000 M: 0 0 0000008e 00000002 00000000
SIMLOG:: Cycle         255 PC: 00000028 I: 0000c1fa R: 1   5 0000008e M: 0 0 00000002 00000002 00000000
SIMLOG:: Cycle         256 PC: 0000001c I: 00007000 R: 1   1 00000002 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         257 PC: 0000001e I: 00008420 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         258 PC: 0000001e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         259 PC: 00000020 I: 00000223 R: 1   0 00000000 M: 1 0 0000007e 00000000 00000000
SIMLOG:: Cycle         260 PC: 00000020 I: 00000223 R: 1   4 00000000 M: 1 0 0000007e 00000000 00000002
SIMLOG:: Cycle         261 PC: 00000022 I: 00009450 R: 1   4 00000002 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         262 PC: 00000022 I: 00007000 R: 1   0 00000000 M: 0 0 00000080 00000002 00000000
SIMLOG:: Cycle         263 PC: 00000024 I: 00000553 R: 1   2 00000080 M: 0 1 0000008e 00000002 00000000
SIMLOG:: Cycle         264 PC: 00000024 I: 00000553 R: 0   4 0000008e M: 0 1 0000008e 00000002 00000000
SIMLOG:: Cycle         265 PC: 00000026 I: 00001113 R: 0   4 0000008e M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         266 PC: 00000026 I: 00007000 R: 1   0 00000000 M: 0 0 00000090 00000002 00000000
SIMLOG:: Cycle         267 PC: 00000028 I: 0000c1fa R: 1   5 00000090 M: 0 0 00000000 00000002 00000000
SIMLOG:: Cycle         268 PC: 00000028 I: 00007000 R: 1   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         269 PC: 0000002a I: 0000a110 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         270 PC: 0000002a I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         271 PC: 0000002c I: 0000a580 R: 1   0 00000000 M: 0 0 00000010 00000000 00000000
SIMLOG:: Cycle         272 PC: 0000002c I: 00007000 R: 1   1 00000010 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         273 PC: 0000002e I: 00008450 R: 1   0 00000000 M: 0 0 00000080 00000000 00000000
SIMLOG:: Cycle         274 PC: 0000002e I: 00007000 R: 1   5 00000080 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         275 PC: 00000030 I: 00001041 R: 1   0 00000000 M: 1 0 00000080 00000000 00000000
SIMLOG:: Cycle         276 PC: 00000030 I: 00001041 R: 1   4 00000000 M: 1 0 00000080 00000000 00000010
SIMLOG:: Cycle         277 PC: 00000030 I: 00007000 R: 1   4 00000010 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         278 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000010 00000000
SIMLOG:: Cycle         279 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         280 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         281 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         282 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         283 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         284 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         285 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         286 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         287 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         288 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         289 PC: 00000030 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         290 PC: 00000032 I: 0000c00d R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         291 PC: 00000032 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         292 PC: 00000034 I: 00000553 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         293 PC: 00000034 I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         294 PC: 00000036 I: 00001113 R: 1   0 00000000 M: 0 0 00000082 00000002 00000000
SIMLOG:: Cycle         295 PC: 00000036 I: 00007000 R: 1   5 00000082 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         296 PC: 00000038 I: 0000c1fa R: 1   0 00000000 M: 0 0 0000000e 00000002 00000000
SIMLOG:: Cycle         297 PC: 0000002c I: 00007000 R: 1   1 0000000e M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         298 PC: 0000002e I: 00008450 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         299 PC: 0000002e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         300 PC: 00000030 I: 00001041 R: 1   0 00000000 M: 1 0 00000082 00000000 00000000
SIMLOG:: Cycle         301 PC: 00000030 I: 00001041 R: 1   4 00000000 M: 1 0 00000082 00000000 0000000e
SIMLOG:: Cycle         302 PC: 00000032 I: 00007000 R: 1   4 0000000e M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         303 PC: 00000032 I: 0000c00d R: 1   0 00000000 M: 0 0 00000000 0000000e 00000000
SIMLOG:: Cycle         304 PC: 00000032 I: 00000553 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         305 PC: 00000032 I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         306 PC: 00000034 I: 00000553 R: 0   0 00000000 M: 0 0 00000084 00000002 00000000
SIMLOG:: Cycle         307 PC: 00000034 I: 00007000 R: 1   5 00000084 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         308 PC: 00000036 I: 00001113 R: 1   0 00000000 M: 0 0 00000086 00000002 00000000
SIMLOG:: Cycle         309 PC: 00000036 I: 00007000 R: 1   5 00000086 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         310 PC: 00000038 I: 0000c1fa R: 1   0 00000000 M: 0 0 0000000c 00000002 00000000
SIMLOG:: Cycle         311 PC: 0000002c I: 00007000 R: 1   1 0000000c M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         312 PC: 0000002e I: 00008450 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         313 PC: 0000002e I: 00007000 R: 0   1 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         314 PC: 00000030 I: 00001041 R: 1   0 00000000 M: 1 0 00000086 00000000 00000000
SIMLOG:: Cycle         315 PC: 00000030 I: 00001041 R: 1   4 00000000 M: 1 0 00000086 00000000 0000000a
SIMLOG:: Cycle         316 PC: 00000032 I: 00007000 R: 1   4 0000000a M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         317 PC: 00000032 I: 0000c00d R: 1   0 00000000 M: 0 0 0000fffe 0000000c 00000000
SIMLOG:: Cycle         318 PC: 0000004c I: 00007000 R: 1   0 0000fffe M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         319 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         320 PC: 0000004c I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         321 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         322 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         323 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         324 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         325 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         326 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         327 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         328 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         329 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         330 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         331 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         332 PC: 0000004c I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         333 PC: 0000004e I: 0000a1ff R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         334 PC: 0000004e I: 00007000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         335 PC: 0000004e I: 0000f000 R: 1   0 00000000 M: 0 0 000000ff 00000000 00000000
SIMLOG:: Cycle         336 PC: 0000004e I: 00007000 R: 1   1 000000ff M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         337 PC: 0000004e I: 0000f000 R: 1   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Cycle         338 PC: 0000004e I: 00007000 R: 0   0 00000000 M: 0 0 00000000 00000000 00000000
SIMLOG:: Processor halted

SIMLOG:: sim_cycles         338

SIMLOG:: inst_count         294

SIMLOG:: dcachehit_count          28

SIMLOG:: icachehit_count         135

SIMLOG:: dcachereq_count          31

SIMLOG:: icachereq_count         140

```

== Test Program 4 Trace File

```text
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x008a
REG:  0 VALUE: 0x0000
REG:  6 VALUE: 0x0080
REG:  0 VALUE: 0x0000
REG:  6 VALUE: 0x0180
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
STORE: ADDR: 0x0180 VALUE: 0x008a
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0070
REG:  0 VALUE: 0x0000
REG:  3 VALUE: 0x0002
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
STORE: ADDR: 0x0070 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0072
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x000e
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x0072 VALUE: 0x000e
STORE: ADDR: 0x0072 VALUE: 0x000e
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0074
REG:  1 VALUE: 0x000c
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x0074 VALUE: 0x000c
STORE: ADDR: 0x0074 VALUE: 0x000c
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0076
REG:  1 VALUE: 0x000a
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x0076 VALUE: 0x000a
STORE: ADDR: 0x0076 VALUE: 0x000a
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0078
REG:  1 VALUE: 0x0008
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x0078 VALUE: 0x0008
STORE: ADDR: 0x0078 VALUE: 0x0008
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x007a
REG:  1 VALUE: 0x0006
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x007a VALUE: 0x0006
STORE: ADDR: 0x007a VALUE: 0x0006
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x007c
REG:  1 VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x007c VALUE: 0x0004
STORE: ADDR: 0x007c VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x007e
REG:  1 VALUE: 0x0002
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x007e VALUE: 0x0002
STORE: ADDR: 0x007e VALUE: 0x0002
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0080
REG:  1 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0070
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0080
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x0070 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x0070 VALUE: 0x0010
REG:  4 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0072
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
STORE: ADDR: 0x0080 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0082
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x000e
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x0072 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x0072 VALUE: 0x000e
REG:  4 VALUE: 0x000e
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0074
STORE: ADDR: 0x0082 VALUE: 0x000e
STORE: ADDR: 0x0082 VALUE: 0x000e
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0084
REG:  1 VALUE: 0x000c
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x0074 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x0074 VALUE: 0x000c
REG:  4 VALUE: 0x000c
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0076
STORE: ADDR: 0x0084 VALUE: 0x000c
STORE: ADDR: 0x0084 VALUE: 0x000c
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0086
REG:  1 VALUE: 0x000a
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x0076 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x0076 VALUE: 0x000a
REG:  4 VALUE: 0x000a
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0078
STORE: ADDR: 0x0086 VALUE: 0x000a
STORE: ADDR: 0x0086 VALUE: 0x000a
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0088
REG:  1 VALUE: 0x0008
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x0078 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x0078 VALUE: 0x0008
REG:  4 VALUE: 0x0008
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x007a
STORE: ADDR: 0x0088 VALUE: 0x0008
STORE: ADDR: 0x0088 VALUE: 0x0008
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x008a
REG:  1 VALUE: 0x0006
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x007a VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x007a VALUE: 0x0006
REG:  4 VALUE: 0x0006
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x007c
STORE: ADDR: 0x008a VALUE: 0x0006
STORE: ADDR: 0x008a VALUE: 0x0006
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x008c
REG:  1 VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x007c VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x007c VALUE: 0x0004
REG:  4 VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x007e
STORE: ADDR: 0x008c VALUE: 0x0004
STORE: ADDR: 0x008c VALUE: 0x0004
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x008e
REG:  1 VALUE: 0x0002
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x007e VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x007e VALUE: 0x0002
REG:  4 VALUE: 0x0002
REG:  0 VALUE: 0x0000
REG:  2 VALUE: 0x0080
STORE: ADDR: 0x008e VALUE: 0x0002
STORE: ADDR: 0x008e VALUE: 0x0002
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0090
REG:  1 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0080
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x0080 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x0080 VALUE: 0x0010
REG:  4 VALUE: 0x0010
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0082
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x000e
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x0082 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x0082 VALUE: 0x000e
REG:  4 VALUE: 0x000e
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0084
REG:  0 VALUE: 0x0000
REG:  5 VALUE: 0x0086
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x000c
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
LOAD: ADDR: 0x0086 VALUE: 0x0000
REG:  4 VALUE: 0x0000
LOAD: ADDR: 0x0086 VALUE: 0x000a
REG:  4 VALUE: 0x000a
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0xfffe
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  0 VALUE: 0x0000
REG:  1 VALUE: 0x00ff
REG:  0 VALUE: 0x0000
```
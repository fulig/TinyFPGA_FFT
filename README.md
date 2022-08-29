# FFT in Verilog for TinyFPGA-BX

## Description

Implementation of an FFT into verrilog. Written for my bachelor thesis. 

- the folder `8FFT` contains a implementation of the full signalflow-chart of an 8 point FFT.

- Because the iE40 chip on the TinyFPGA Borad is low on resources, an alternative implementation of the FFT was developed. Thereby only one stage of butterflys was implemented. The code for this can be found in the folder `FFT_stage`.
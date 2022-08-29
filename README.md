# FFT in Verilog for TinyFPGA-BX

## Description

Implementation of a FFT in Verrilog. Written for my bachelor thesis. The FFT is built from scratch, so first the arithmetic functions like add/sub and mult were implemented. Based on that, a twiddle multiplier and a butterfly processor has been realised.

- the folder `8FFT` contains a implementation of the full signalflow-chart of an 8 point FFT.

- Because the iE40 chip on the TinyFPGA Borad is low on resources, an alternative implementation of the FFT was developed. Thereby only one stage of butterflys was implemented. The code for this can be found in the folder `FFT_stage`.

## Usage

The Code has been build for the TinyFPGA-BX. Too load this on the board the tool `apio`is needed. 
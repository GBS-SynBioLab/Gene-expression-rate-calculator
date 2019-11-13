# Gene-expression-rate-calculator
Author: Nicolas Kylilis PhD 

Intended purpose:
-----------------
Automated data analysis workflow for the calculation of gene expression rate

Suitable for time-course fluorescence assays on microplate-reader for bacterial cells

Experimental design (microplate layout):
----------------------------------------
Data analysis will only take place correctly if the following microplate layout is applied. 

Column 1: Media blank

Column 2: Control cells for growth rate and autofluorescence

Column 3-12: Sample experimental conditions

Rows A-H: Replicates

Methodology
-----------

- Growth rate calculation:

Based on formula:
λ=[ln(OD_t2)- ln(OD_t1)]/dt

Where t = data collection time-point


Data processing steps for growth rate:

--Subtraction of media absorbance value from [OD data]

--ln [OD data]

--dy = mean(ln[ODt0], ln[ODt1], ln[ODt2]) - mean(ln[ODt-1], ln[ODt0], ln[ODt1])

--dt = t2-t1

--lambda = dy/dt

---

- Gene expression rate calculation:

Based on formula:

Protein production rate=number of cells*(Gene expression rate-[Protein]*dilution rate)


Assumptions:
	Max growth rate timepoint represents steady state of balance growth where FP production rate per cell = 0 (gene expression and diluation cancel each other out)



Data processing steps for Fluorescence/cell:
	
  --Subtraction of media autofluorescence from [fluorescence data]
	
  --Subtraction of media absorbance from [Absorbance data]
	
  --Fluorescence per cell = [corrected Fluorescence data] / [corrected Absorbance data]


Data processing steps for Gene expression rate:
	
  --CorrectedFI/cell = FI/cellmax_gr – FI/cellautfluorescence_max_gr
  
  --Gene expression rate = CorrectedFI/cell * max growth rate 


Data processing steps for Steady state assumption check by calculating FP production rate per cell (should be = 0 at macx growth rate):

--dP = mean(FI/cellt0, FI/cellt-1, FI/cellt1) - mean(FI/cellt-1, FI/cellt0, FI/cellt-2)

--dt = t2-t1

--FP production rate = dP/dt


Data analysis instructions:
--------------
Open matlab software and run "growth_rate_module.m" file script. (Instructions for file naming etc can be found in the script)

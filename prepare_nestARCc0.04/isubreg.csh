#!/bin/csh -x
# Use this script to
# Remap archive file 
# from ARCC0.08 -> ARCc0.04
# Note that the input
# archive file has to be on the same grid/domain
# as the output grid, the output grid 
# can be a finer-grid but must be an integer
# multiple of the original grid
#
setenv DF1 /p/work1/ddukhovs/hycom/ARCc0.04/nest_arc08
setenv DF2 /p/work1/ddukhovs/hycom/ARCc0.04/nest_arc04
setenv DT8 /p/work1/ddukhovs/hycom/ARCc0.04/topo_arc08
setenv DT4 /p/work1/ddukhovs/hycom/ARCc0.04/topo
setenv G11 depth_ARCc0.08_11D
setenv G17 depth_ARCc0.04_17DD
setenv F1 archv_arcT11L41.2007_211_00
setenv F2 archv_arc04T17L41.2007_211err
setenv SRC /p/home/wallcraf/hycom/ALLcnl/subregion/src

touch regional.grid.a
/bin/rm -f regional.grid.[ab]
/bin/ln -s ${DT8}/regional.grid.a # ARCc0.08 input grid
/bin/ln -s ${DT8}/regional.grid.b

setenv flnm_in  ${DF1}/${F1}
setenv flnm_tin ${DT8}/${G11}
setenv flnm_out ${DF2}/${F2}
setenv flnm_top ${DT4}/${G17}

# Check existing files, the code cannot overwrite it
/bin/rm -f ${flnm_out}.[ab]

# Input:
#c --- 'flnm_in'   = input  filename
#c --- 'flnm_tin'  = input  bathymetry filename
#c --- 'flnm_out'  = output filename
#c --- 'flnm_top'  = output bathymetry filename
#c --- 'cline_out' = output title line (replaces preambl(5))
#/Net/ocean/ddmitry/HYCOM/hycom/ALL/subregion/src/isubregion <<E-o-D
${SRC}/isubregion <<E-o-D
${flnm_in}.a
${flnm_tin}.a
${flnm_out}.a
${flnm_top}.a
From ARCc0.08 T11D grid nest (from GOFS3.1 GLBb0.08)  -> ARCc0.04 T17DD corrected 
    3200     'idm   ' = longitudinal array size
    5040     'jdm   ' = latitudinal  array size
    1        'irefi ' = longitudinal input  reference location
    1        'jrefi ' = latitudinal  input  reference location
    1        'irefo ' = longitudinal output  reference location
    1        'jrefo ' = latitudinal  output  reference location
    2        'ijgrd ' = integer scale factor between input and output grids
    1        'iceflg' = ice in output archive flag (0=none,1=energy loan model)
    0        'smooth' = smooth interface depths (0=F,1=T)
E-o-D

exit 0


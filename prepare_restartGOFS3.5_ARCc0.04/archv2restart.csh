#!/bin/csh -fvx
#PBS -N rest2archv 
#PBS -j oe
#PBS -o archv2rest.log
#PBS -l walltime=12:00:00
#PBS -l select=1
#PBS -A ONRDC10855122
#PBS -q transfer
#
# --- Form a HYCOM restart file from a HYCOM archive file.
#
set echo

setenv R ARCc0.04
setenv T 17DD
setenv S /p/work1/ddukhovs/hycom/${R}
setenv E 010
setenv EE `echo ${E} | awk '{printf("%04.1f", $1*0.1)}'`
setenv RST04 /p/work1/${user}/hycom/${R}/rest_arc04
setenv SRC /p/home/wallcraf/hycom/ALLcnl/archive/src
setenv Fin archv.ARCc0.04.2005_001_00
setenv Rin restart_ARCc0.04_test_094a
setenv Fout restart_105a

cd $RST04

rm -f regional.depth.[ab]
rm -f regional.grid.[ab]

touch regional.depth.a regional.depth.b
if (-z regional.depth.a) then
  /bin/rm regional.depth.a
  ln -s ${S}/topo/depth_ARCc0.04_17DD.a regional.depth.a
endif
if (-z regional.depth.b) then
  /bin/rm regional.depth.b
  ln -s ${S}/topo/depth_ARCc0.04_17DD.b regional.depth.b
endif
#
touch regional.grid.a regional.grid.b
if (-z regional.grid.a) then
  /bin/rm regional.grid.a
  ln -s ${S}/topo/regional.grid.a regional.grid.a
endif
if (-z regional.grid.b) then
  /bin/rm regional.grid.b
  ln -s ${S}/topo/regional.grid.b regional.grid.b
endif
#
# ---   'flnmarch' = name of  input archive file
# ---   'flnmrsi'  = name of  input restart file
# ---   'flnmrso'  = name of output restart file
# ---   'iexpt '   = experiment number x10  (000=from archive file)
# ---   'yrflag'   = days in year flag (0=360J16,1=366J16,2=366J01,3=actual)
# ---   'idm   '   = longitudinal array size
# ---   'jdm   '   = latitudinal  array size
# ---   'kapref'   = thermobaric reference state (-1 to 3, optional, default 0)
# ---   'kdm   '   = number of layers

${SRC}/archv2restart <<E-o-D
${RST04}/${Fin}.a
${RST04}/${Rin}.a
${RST04}/${Fout}.a
  ${E} 'iexpt ' = experiment number x10 (000=from archive file)
    3  'yrflag' = days in year flag (0=360J16,1=366J16,2=366J01,3-actual)
 3200  'idm   ' = longitudinal array size
 5040  'jdm   ' = latitudinal  array size
   -1  'kapref' = thermobaric ref. state
   41  'kdm   ' = number of layers
 34.0  'thbase' = reference density (sigma units)
 120.0 'baclin' = baroclinic time step (seconds), int. divisor of 86400
E-o-D

exit 0


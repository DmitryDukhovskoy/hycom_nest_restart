#!/bin/csh -fvx
#PBS -N rest2archv
#PBS -j oe
#PBS -o rest2archv.log
#PBS -l walltime=12:00:00
#PBS -l select=1
#PBS -A ONRDC10855122
#PBS -q transfer
#
#
# Create archv from restart HYCOM
#
set echo

setenv R ARCc0.04
setenv R08 ARCc0.08
setenv T 17DD
setenv T11 11D
setenv S /p/work1/ddukhovs/hycom/${R}
#setenv E 010
#setenv E 012
#setenv EE `echo ${E} | awk '{printf("%04.1f", $1*0.1)}'`
setenv DW /p/home/${user}/hycom/${R}/prepare_restartARCc0.04
setenv RST08 /p/work1/${user}/hycom/${R}/rest_arc08
setenv RST04 /p/work1/${user}/hycom/${R}/rest_arc04
setenv dDay 7
setenv SRC /p/home/wallcraf/hycom/ALLcnl/archive/src
#setenv SRC /p/home/abozec/hycom/ALL4/archive/src # tracer flad is turned on - does not work

setenv FRST08 restart_105a
setenv FARCHV archv.20050101

cd ${S}/topo

touch regional.grid.a regional.grid.b
if (-z regional.grid.a) then
  rcp newton:/u/home/ddukhovs/hycom/${R}/topo/regional.grid.a .
  rcp newton:/u/home/ddukhovs/hycom/${R}/topo/regional.grid.b .
  wait
endif

setenv G17 depth_ARCc0.04_17DD
touch ${G17}.a
touch ${G17}.b
if (-z ${G17}.a) then
  rcp newton:/u/home/ddukhovs/hycom/${R}/topo/${G17}.a .
  rcp newton:/u/home/ddukhovs/hycom/${R}/topo/${G17}.b .
  wait
endif

cd ${S}/topo_arc08
touch regional.grid.a regional.grid.b
if (-z regional.grid.a) then
  rcp newton:/u/home/ddukhovs/hycom/ARCc0.08/topo/regional.grid.a .
  rcp newton:/u/home/ddukhovs/hycom/ARCc0.08/topo/regional.grid.b .
  wait
endif

setenv G11 depth_ARCc0.08_11D
touch ${G11}.a ${G11}.b
if (-z ${G11}.a) then
  rcp newton:/u/home/ddukhovs/hycom/ARCc0.08/topo/${G11}.a .
  rcp newton:/u/home/ddukhovs/hycom/ARCc0.08/topo/${G11}.b .
  wait
endif

cd $DW
touch regional.depth.a regional.depth.b
rm regional.depth.[ab]
ln -s ${S}/topo_arc08/${G11}.a regional.depth.a
ln -s ${S}/topo_arc08/${G11}.b regional.depth.b

touch regional.grid.a regional.grid.b
rm regional.grid.[ab]
ln -s ${S}/topo_arc08/regional.grid.a .
ln -s ${S}/topo_arc08/regional.grid.b .

touch blkdat.input
rm blkdat.input*
#if (-z blkdat.input) then
#  cp /p/home/ddukhovs/hycom/ARCc0.08/expt_11.0/blkdat.input blkdat.input
#endif

rm -f ${RST08}/${FARCHV}.[ab]

# --- 
# ---   'flnmrsi'  = name of  input restart file
# ---   'flnmarch' = name of output archive file
# ---   'iexpt '   = experiment number x10  (000=from archive file)
# ---   'yrflag'   = days in year flag (0=360J16,1=366J16,2=366J01,3=actual)
# ---   'sshflg'   = diagnostic SSH flag (0=SSH,1=SSH&stericSSH)
# ---                 note that sshflg==1 implies reading relax.ssh.a
# ---   'iceflg'   = ice model flag (0=none(default),1=energy loan model)
# ---   'idm   '   = longitudinal array size
# ---   'jdm   '   = latitudinal  array size
# ---   'kapref'   = thermobaric reference state (-1 to 3, optional, default 0)
# ---   'kdm   '   = number of layers
# ---   'n     '   = extract restart time slot number (1 or 2)
# ---   'thbase' = reference density ( 'sigma' = sigma layer units)
# ---   layer densities ( 'sigma' = sigma layer units)
#
echo "Calling restart2archv "
#${SRC}/restart2archv_trcr <<E-o-D
${SRC}/restart2archv <<E-o-D
${RST08}/${FRST08}.a
${RST08}/${FARCHV}.a
000     'iexpt ' = experiment number x10 (000=from archive file)
  3     'yrflag' = days in year flag (0=360J16,1=366J16,2=366J01,3-actual)
  0     'sshflg'   = diagnostic SSH flag (0=SSH,1=SSH&stericSSH)
  0     'iceflg'   = ice model flag (0=none(default),1=energy loan model)
1600    'idm   ' = longitudinal array size
2520    'jdm   ' = latitudinal  array size
 -1     'kapref' = thermobaric reference state (-1 to 3, optional, default 0)
 41     'kdm   ' = number of layers
  1     'n     '   = extract restart time slot number (1 or 2) 
 34.0   'thbase' = reference density ( 'sigma' = sigma layer units)
  17.00   'sigma ' = layer  1 isopycnal target density (sigma units)
  18.00   'sigma ' = layer  2 isopycnal target density (sigma units)
  19.00   'sigma ' = layer  3 isopycnal target density (sigma units)
  20.00   'sigma ' = layer  4 isopycnal target density (sigma units)
  21.00   'sigma ' = layer  5 isopycnal target density (sigma units)
  22.00   'sigma ' = layer  6 isopycnal target density (sigma units)
  23.00   'sigma ' = layer  7 isopycnal target density (sigma units)
  24.00   'sigma ' = layer  8 isopycnal target density (sigma units)
  25.00   'sigma ' = layer  9 isopycnal target density (sigma units)
  26.00   'sigma ' = layer 10 isopycnal target density (sigma units)
  27.00   'sigma ' = layer 11 isopycnal target density (sigma units)
  28.00   'sigma ' = layer 12 isopycnal target density (sigma units)
  29.00   'sigma ' = layer 13 isopycnal target density (sigma units)
  29.90   'sigma ' = layer 14 isopycnal target density (sigma units)
  30.65   'sigma ' = layer  A isopycnal target density (sigma units)
  31.35   'sigma ' = layer  B isopycnal target density (sigma units)
  31.95   'sigma ' = layer  C isopycnal target density (sigma units)
  32.55   'sigma ' = layer  D isopycnal target density (sigma units)
  33.15   'sigma ' = layer  E isopycnal target density (sigma units)
  33.75   'sigma ' = layer  F isopycnal target density (sigma units)
  34.30   'sigma ' = layer  G isopycnal target density (sigma units)
  34.80   'sigma ' = layer  H isopycnal target density (sigma units)
  35.20   'sigma ' = layer  I isopycnal target density (sigma units)
  35.50   'sigma ' = layer 15 isopycnal target density (sigma units)
  35.80   'sigma ' = layer 16 isopycnal target density (sigma units)
  36.04   'sigma ' = layer 17 isopycnal target density (sigma units)
  36.20   'sigma ' = layer 18 isopycnal target density (sigma units)
  36.38   'sigma ' = layer 19 isopycnal target density (sigma units)
  36.52   'sigma ' = layer 20 isopycnal target density (sigma units)
  36.62   'sigma ' = layer 21 isopycnal target density (sigma units)
  36.70   'sigma ' = layer 22 isopycnal target density (sigma units)
  36.77   'sigma ' = layer 23 isopycnal target density (sigma units)
  36.83   'sigma ' = layer 24 isopycnal target density (sigma units)
  36.89   'sigma ' = layer 25 isopycnal target density (sigma units)
  36.97   'sigma ' = layer 26 isopycnal target density (sigma units)
  37.02   'sigma ' = layer 27 isopycnal target density (sigma units)
  37.06   'sigma ' = layer 28 isopycnal target density (sigma units)
  37.10   'sigma ' = layer 29 isopycnal target density (sigma units)
  37.17   'sigma ' = layer 30 isopycnal target density (sigma units)
  37.30   'sigma ' = layer 31 isopycnal target density (sigma units)
  37.42   'sigma ' = layer 32 isopycnal target density (sigma units)
E-o-D

exit 0

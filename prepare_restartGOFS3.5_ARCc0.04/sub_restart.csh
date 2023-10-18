#! /bin/csh -xv
# Prepares qsub script
# for generating 1 restart file
# from GLBc0.04 GOFS3.5 --> ARCc0.04
# 
# usage csh sub_restart.csh 2017 165
# 
setenv R ARCc0.04

if ($#argv < 2) then
  echo "Not enough input"
  echo "Usage: csh sub_restart.csh YEAR YEAR_DAY (e.g., 2017 151)"
  exit 1
endif

setenv Y1 $argv[1]
if (`echo ${Y1} | awk '{if ($1 > 1900) print 1; else print 0}'`) then
  setenv Y1 `echo ${Y1} | awk '{printf("%3.3i", $1-1900)}'`
endif
setenv Y2 $Y1
setenv dS $argv[2]
setenv dm1 `echo $dS | awk '{printf("%3.3i", $1)}'`

setenv DSCR /p/work1/ddukhovs/hycom/${R}/GLBc0.04_output
mkdir -pv ${DSCR}

setenv YR1 `echo ${Y1} | awk '{printf("%4.4i", $1+1900)}'`
#setenv YR2 `echo ${Y2} | awk '{printf("%4.4i", $1+1900)}'`


# Clean old unfinished gz files
# to avoid error messages
# 216_archm_2017013112.tar.gz
#echo ${YR1}
ls -l ${DSCR}/*${YR1}*tar.gz
#rm -f ${DSCR}/*${YR1}${MM}${DD}*tar.gz

#exit 1

# from archm:
#setenv HEX archmGLBc2restARCc.com
# from archv:
setenv HEX archvGLBc2restARCc.com

set FSCR = restARCc${YR1}${dm1}.com
sed -e "s|^#PBS -N .*|#PBS -N rest${YR1}${dm1}|"\
    -e "s|^#PBS -o .*|#PBS -o Rrest${YR1}${dm1}.log|"\
    -e "s|^setenv Y01 .*|setenv Y01 ${Y1}|"\
    -e "s|^setenv dS .*|setenv dS ${dS}|" ${HEX} >! ${FSCR}

chmod 755 ${FSCR}
qsub ${FSCR}

exit 0

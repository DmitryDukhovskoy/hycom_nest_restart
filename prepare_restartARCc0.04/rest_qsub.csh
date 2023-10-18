#! /bin/csh -xv
# Prepares qsub script
# for generating restart files
# Year format can be HYCOM or calendar: 095 or 1995
# months: numbers 1 - 12 or letters a-l
#
# usage csh rest_qsub.csh 094  5   
#  

if ($#argv < 2) then
  echo "Not enough input"
  echo "Usage: csh rest_qsub.csh Y1 (e.g., 095 or 1995) AB month"
  exit 1
endif

setenv Y1 $argv[1]
if (`echo ${Y1} | awk '{if ($1 > 1900) print 1; else print 0}'`) then
  setenv YR1 ${Y1}
  setenv Y1 `echo ${YR1} | awk '{printf("%3.3i", $1-1900)}'`
else
  setenv YR1 `echo ${Y1} | awk '{printf("%4.4i", $1+1900)}'`
endif

# check if month is a number or a letter:
setenv MM $argv[2]
if ( $MM != ^[0-9]+$ ) then
  setenv AB $MM
  setenv MM `echo "AB2MM" | awk -f nest_dates.awk AB=${AB}`
else
  setenv AB `echo "MM2AB" | awk -f nest_dates.awk i=${MM}`
endif

echo "Y1 ${Y1}, YR1 ${YR1}, Month AB=${AB} MM=${MM}"

setenv DSCR /p/work1/ddukhovs/hycom/ARCc0.04/rest_arc04

set FSCR = restartARCc004_${Y1}.com
sed -e "s|^#PBS -N .*|#PBS -N restOB${Y1}|"\
    -e "s|^#PBS -o .*|#PBS -o restOB${Y1}.log|"\
    -e "s|^setenv YRST .*|setenv YRST ${YR1}|"\
    -e "s|^setenv AB .*|setenv AB ${AB}|"  restartARCc004.com >! ${DSCR}/${FSCR}

#cd ${DSCR}
chmod 755 ${DSCR}/${FSCR}
qsub ${DSCR}/${FSCR}



exit 0

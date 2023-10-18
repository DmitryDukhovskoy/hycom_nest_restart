#! /bin/csh -xv
# Prepares qsub script
# for generating nest OB files
# for 1 year
# usage csh sub_nestOB.csh 094 or
#       csh sub_nestOB.csh 1994
# 
setenv E 110
setenv R ARCc0.04

if ($#argv < 1) then
  echo "Not enough input"
  echo "Usage: csh sub_nestOB.csh Y1 (e.g., 095)"
  exit 1
endif

setenv Y1 $argv[1]
if (`echo ${Y1} | awk '{if ($1 > 1900) print 1; else print 0}'`) then
  setenv Y1 `echo ${Y1} | awk '{printf("%3.3i", $1-1900)}'`
endif
setenv Y2 $Y1
setenv DSCR /p/work1/ddukhovs/hycom/${R}/GLBc0.04_output
mkdir -pv ${DSCR}

setenv YR1 `echo ${Y1} | awk '{printf("%4.4i", $1+1900)}'`
#setenv YR2 `echo ${Y2} | awk '{printf("%4.4i", $1+1900)}'`


# Clean old unfinished gz files
# to avoid error messages
#echo ${YR1}
ls -l ${DSCR}/*${YR1}*tar.gz
#rm -f ${DSCR}/*${YR1}*tar.gz

#exit 1

set FSCR = nestOB${YR1}.com
sed -e "s|^#PBS -N .*|#PBS -N nestOB${YR1}|"\
    -e "s|^#PBS -o .*|#PBS -o nestOB${YR1}.log|"\
    -e "s|^setenv Y01 .*|setenv Y01 ${Y1}|"\
    -e "s|^setenv Ye .*|setenv Ye ${Y2}|" ${E}nestOB.com >! ${FSCR}

chmod 755 ${FSCR}
qsub ${FSCR}

exit 0

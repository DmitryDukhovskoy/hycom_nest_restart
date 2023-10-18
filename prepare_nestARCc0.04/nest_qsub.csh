#! /bin/csh -xv
# Prepares qsub script
# for generating nest OB files
# for 1 year
# Do months for 1 year at a time!!!
# i.e. do not submit several jobs extracting different months for 1 year
# 
# Double check if list_filesYEAR.dat need to be removed
# 
# nest_qsub.csh -> create_nest004.com -> isubregion_arc08_arc04.csh
#                                     -> submits bash job that runs fix_isubregion_arc04/fillnans.x
#
# Note that arc0.08 nest files are saved for 7-day intervals
# starting frmo Jan. 1 1993
# script ???dates.awk is needed
# to calculate actual nest dates for a given year
# Specify year and (optional) months to process
# Year format can be HYCOM or calendar: 095 or 1995
# months: numbers 1 - 12
#
# usage csh nest_qsub.csh 094  5 8  <- processed 1994 from 5 through 8
# usage csh nest_qsub.csh 094  5    <- processed 1994 for 5
# usage csh nest_qsub.csh 094       <- processed 1994 1 - 12 
# usage csh nest_qsub.csh 1994      <- same 
#  

if ($#argv < 1) then
  echo "Not enough input"
  echo "Usage: csh nest_qsub.csh Y1 (e.g., 095 or 1995)  [month1 [month2]] (e.g., 1  8)"
  exit 1
endif

setenv Y1 $argv[1]
if (`echo ${Y1} | awk '{if ($1 > 1900) print 1; else print 0}'`) then
  setenv YR1 ${Y1}
  setenv Y1 `echo ${YR1} | awk '{printf("%3.3i", $1-1900)}'`
else
  setenv YR1 `echo ${Y1} | awk '{printf("%4.4i", $1+1900)}'`
endif

if ($#argv > 1) then
  setenv M1 $argv[2]
else
  setenv M1 1
endif

if ($#argv == 3) then
  setenv M2 $argv[3]
else if ($#argv == 2) then
  setenv M2 ${M1}
else
  setenv M2 12
endif

echo "Y1 ${Y1}, YR1 ${YR1}, M1 ${M1}, M2 ${M2} "
#setenv Y2 $Y1
#setenv YR2 `echo ${Y2} | awk '{printf("%4.4i", $1+1900)}'`

setenv DSCR /p/work1/ddukhovs/hycom/ARCc0.04/nest_arc04

#setenv G8 depth_ARCc0.08_11    # input topo
#setenv G4 depth_ARCc0.04_17DD  # output topo

# Clean old unfinished gz files
# to avoid error messages
#echo ${YR1}
#ls -l ${DSCR}/*${YR1}*tar.gz
#rm -f ${DSCR}/*${YR1}*tar.gz

#exit 1

set FSCR = nestOB${Y1}.com
sed -e "s|^#PBS -N .*|#PBS -N nest004OB${Y1}|"\
    -e "s|^#PBS -o .*|#PBS -o nest004OB${Y1}.log|"\
    -e "s|^setenv YNST .*|setenv YNST ${YR1}|"\
    -e "s|^setenv M1 .*|setenv M1 ${M1}|"\
    -e "s|^setenv M2 .*|setenv M2 ${M2}|"  create_nest004.com >! ${DSCR}/${FSCR}

#cd ${DSCR}
chmod 755 ${DSCR}/${FSCR}
qsub ${DSCR}/${FSCR}



exit 0

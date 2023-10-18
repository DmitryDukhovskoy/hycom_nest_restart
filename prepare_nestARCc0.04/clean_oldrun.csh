#! /bin/csh -xv
#
# clean old files after creating nest for YR
# usage clean_oldrun.csh 2001
#
setenv R ARCc0.04
setenv S  /p/work1/${user}/hycom/${R}  # shepard scratch
setenv DF1 ${S}/archv_arc08T11L41
setenv SG  ${S}/GLBb0.08_output # tempor. dir. to keep GLBb output

setenv WD ${cwd}

if ($#argv < 1) then
  echo "Year not specified, usage clean_scr.csh 2001"
  exit 1
endif

setenv Y1 $argv[1]
if (`echo ${Y1} | awk '{if ($1 > 1900) print 1; else print 0}'`) then
  setenv Y1 `echo ${Y1} | awk '{printf("%3.3i", $1-1900)}'`
endif

setenv YR1 `echo ${Y1} | awk '{printf("%4.4i", $1+1900)}'`

cd ${S}/nest_arc04
echo "Cleaning files for ${YR1}:"
ls -l fillqsub${YR1}*.csh
ls -l nestOB${Y1}*.com
ls -l *${YR1}*.log*
ls -l dump/*${YR1}*
ls -l tarv${YR1}_??

rm -f fillqsub${YR1}*.csh
rm -f nestOB${Y1}*.com
rm -f *${YR1}*.log*
rm -f dump/*${YR1}*
rm -r tarv${YR1}_??

cd ${S}/nest_arc08
ls *${YR1}*
rm -f *${YR1}*

cd $WD
ls -l nest*${YR1}*.log
ls -l nest*${Y1}*.log
ls -l fix_isubregion_arc04/PRM${YR1}*dat

rm -f nest*${YR1}*.log
rm -f nest*${Y1}*.log
rm -f fix_isubregion_arc04/PRM${YR1}*dat


exit 0

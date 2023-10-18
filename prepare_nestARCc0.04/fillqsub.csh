#! /bin/csh -xv
#PBS -N fillnans
#PBS -j oe
#PBS -o fillnans.log
#PBS -l walltime=12:00:00
##PBS -l select=1:ncpus=1:host=gordon09
#PBS -l select=1
#PBS -A ONRDC10855122
#PBS -q transfer
##
## Prepares and submits qsub script
## for running fill_nans executable
## then check if output is ready to be tarred and rcped to newton
##  
# Setenv 
setenv PRM XX #PRM2005087.dat
setenv YNST XX #2005
setenv MM XX #03
setenv dS XX #087 current day, dS1 <= dS <= dL
setenv dS1 XX # day dS1 - 1st day in the current month with dDay stepping
setenv dDay XX # 7 days - time stepping in creating nest files
setenv dL XX # Last day in the current month with dDay stepping
setenv FLOG XX #list_nest2005.dat
setenv DF2 XX #/p/work1/ddukhovs/hycom/ARCc0.04/nest_arc04
setenv DF3 XX #/p/work1/ddukhovs/hycom/ARCc0.04/nest_arc04
setenv F2 XX #archv_arc04T17L41.2005_087err
setenv F3 XX #archv_arc04T17L41.2005_087_00
setenv DW XX #/p/home/ddukhovs/hycom/ARCc0.04/prepare_nestARCc0.04
setenv R ARCc0.04  #ARCc0.04
setenv T 17        # 17 DD   

cd ${DW}/fix_isubregion_arc04
./fillnans.x ${PRM} 
wait 

# Check completion and update the log file 
cd ${DF3}
ls -l ${F3}.a >& /dev/null
if ($status == 0) then
# Move to directory for tarring  
  setenv DTAR tarv${YNST}_${MM}
  mkdir -pv ${DTAR}
  mv ${F3}.[ab] ${DTAR}/.
  ls -l ${DTAR}/*

# Update Log file: <---- do it later, when tarring
#  cd ${DW}
#  echo ${dS} | cat >> ${FLOG}

# Old Files to Dump
  cd ${DF2}
  /bin/mv ${F2}* dump/.
  
else
  echo "${F3} not created, stopping ..."
  exit 1
endif

# Tar and rcp to newton if all files have been created for the current month:
# Create list of files 
setenv day0 $dS1
@ ii = 0
set flist =
while (`echo $day0 $dL | awk '{if ($1 <= $2) print 1; else print 0}'`)
  @ ii++
  setenv FNAME archv_arc04T${T}L41.${YNST}_${day0}_00
  set flist = ($flist $FNAME)
  setenv day0 `echo ${day0} ${dDay} | awk '{printf("%3.3i", $1+$2)}'`
end  # while loop for day0

cd ${DF3}/${DTAR}
@ chfls = 0
foreach fl ($flist)
  if (-e $fl.a && -e $fl.b) then
    @ chfls++
  endif
end

echo " Checking list of corrected files, Found $chfls corrected files in the month $MM"
if (`echo ${chfls} $#flist | awk '{if ($1 == $2) print 1; else print 0}'`) then
  echo "All files created, start tarring $YNST $MM"
  pwd
  ls -l *.[ab]
  setenv FTAR archv_${R}_T${T}L41.${YNST}_${MM}
  rm -f ${FTAR}
  tar czvf ${FTAR}.tar.gz *${YNST}*.[ab]
  wait

  archive put -C /u/home/ddukhovs/hycom/ARCc0.04/nest_T17_L41/ ${FTAR}.tar.gz
  wait

# Update the log file:
#  cd ${DW}
#  echo ${dS} | cat >> ${FLOG}
  touch ${DW}/${FLOG}  
  setenv day0 $dS1
  while (`echo $day0 $dL | awk '{if ($1 <= $2) print 1; else print 0}'`)
    @ ii++
    setenv FNAME archv_arc04T${T}L41.${YNST}_${day0}_00
    setenv day0 `echo ${day0} ${dDay} | awk '{printf("%3.3i", $1+$2)}'`
    echo $day0 | cat >> ${DW}/${FLOG}
  end  # while loop for day0

# 
# Cleaning
  if (-e ${FTAR}.tar.gz) then
    echo "Cleaning tarred files ..."
    rm *${YNST}*.[ab]

    echo "Cleaning dump" 
    foreach fl ($flist)
      rm ${DF2}/dump/${fl}*
    end

  endif

else
  echo "Not all files have been created, exist files: $chfls, Expected $#FNAME, not ready for tarring ..."
endif

#if (`echo ${dS} ${dL} | awk '{if ($1 == $2) print 1; else print 0}'`) then
#  cd ${DF3}/${DTAR}
#  echo "Tarring $YNST $MM"
#  ls -l *${YNST}*.[ab]
#  setenv FTAR archv_${R}_T${T}L41.${YNST}_${MM}
#  tar czvf ${FTAR}.tar.gz *${YNST}*.[ab]
#  wait
#
#  archive put -C /u/home/ddukhovs/hycom/ARCc0.04/nest_T17_L41/ ${FTAR}.tar.gz
#  wait
#
#  if (-e ${FTAR}.tar.gz) then
#    echo "Cleaning tarred files ..."
#    rm *${YNST}*.[ab]
##    rm ${DF2}/dump/${F2}*
#  endif
#
#endif # tarring


exit 0

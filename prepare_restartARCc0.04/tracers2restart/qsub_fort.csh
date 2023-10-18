#! /bin/csh -fvx 
#PBS -N tracer2restart04
#PBS -j oe
#PBS -o tracer2restart04.log
#PBS -l walltime=12:00:00
#PBS -l select=1
#PBS -A ONRDC10855122
#PBS -q transfer
cd /p/home/ddukhovs/hycom/ARCc0.04/prepare_restartARCc0.04/tracers2restart
./trcRST.x

exit 0


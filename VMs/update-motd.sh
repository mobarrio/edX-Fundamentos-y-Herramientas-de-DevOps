#!/bin/bash

vKernel="`uname -s` `uname -r`"
vOperatingSystem=`/usr/bin/lsb_release -d|cut -f2`
vHostname="$(hostname)"
vTimeZone=`timedatectl |egrep "Time zone" | awk -F":" '{gsub(/^[ \t]+/, "", $2); print $2}'`
vVirtualization=`hostnamectl status|grep Virtualization|cut -d":" -f2|xargs`
vCPU=`lscpu|grep "^CPU(s):"|cut -d":" -f2|xargs`
vModelName=`lscpu|grep "^Model name"|cut -d":" -f2|xargs`
vRootFSTotal=`df -Ph | grep /$ | awk '{print $2}' | tr -d '\n'`
vRootFSLibre=`df -Ph | grep /$ | awk '{print $4}' | tr -d '\n'`
vRootFSUsed=`df -Ph | grep /$ | awk '{print $5}' | tr -d '\n'`
vLOAD1=`cat /proc/loadavg | awk {'print $1'}`
vLOAD5=`cat /proc/loadavg | awk {'print $2'}`
vLOAD15=`cat /proc/loadavg | awk {'print $3'}`
vSwapTotal=`free -m|grep "Swap:" |awk '{print $2}'`
vSwapUsed=`free -m|grep "Swap:" |awk '{print $3}'`
vMemTotal=`free -t -m | grep "Mem:" | awk '{print $2; }'`
vMemLibre=`free -t -m | grep "Mem:" | awk '{print $4; }'`
vMemUsada=`free -t -m|grep "Mem:" |awk '{print ($3+$5+$6); }'`
vFecha=`date +"%Y-%m-%d %H:%M:%S"`
vIPAddrs=`/usr/bin/hostname -I`
echo "
----------------------------------------------------------------------------------------------------
                               edX - Fundamentos y Herramientas de DevOps
                                          [$vFecha]
----------------------------------------------------------------------------------------------------
Operating System : $vOperatingSystem
Kernel           : $vKernel
Model Name       : $vModelName
Phyisical/Virtual: $vVirtualization
----------------------------------------[Estado del Sistema]----------------------------------------
Hostname         : $vHostname
IP address       : $vIPAddrs
Time Zone        : $vTimeZone
Load Average     : $vLOAD1, $vLOAD5, $vLOAD15 (1,5,15)
CPU(s)           : $vCPU  
Memory           : $vMemLibre MB de $vMemTotal MB ($vMemUsada usada aprox.)
Swap             : $vSwapUsed MB de $vSwapTotal MB
FileSystem (/)   : $vRootFSLibre de $vRootFSTotal ($vRootFSUsed usado aprox.)
----------------------------------------------------------------------------------------------------
"


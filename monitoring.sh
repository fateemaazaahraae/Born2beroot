#!/bin/bash

# ARCH
arch=$(uname -a)

# PHYSICAL CPU
fcpu=$(grep '^physical id' /proc/cpuinfo | wc -l)

# VIRTUAL CPU
vcpu=$(grep '^processor' /proc/cpuinfo | wc -l)

# RAM
ram=$(free --mega | grep '^Mem:' | awk '{print $3 "/" $2}')
ram_percent=$(free --mega | grep '^Mem:' | awk '{printf("%.2f"), $3/$2*100}')

# DISK
disk=$(df -h --total | grep '^total' | awk '{printf "%d/%d" , $3*1000, $2}')
disk_percent=$(df -h --total | grep '^total' | awk '{printf("(%.2f%%)", $3/$2*100)}')

# CPU LOAD
cpu_load=$(mpstat | grep 'all' | awk '{print 100 - $NF}')

# LAST BOOT
last_boot=$(who -b | awk '{print $3 " " $4}')

# LVM USE
lvmu=$(if [ $(lsblk | grep 'lvm' | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

# CONNECTIONS
connection=$(netstat | grep 'ESTABLISHED' | wc -l)

# USERS
usr=$(users | wc -w)

# Network
ip=$(hostname -I)
mac=$(ip link | grep 'link/ether' | awk '{print  $2}')

# SUDO
nsudo=$(journalctl _COMM=sudo -q | grep 'COMMAND' | wc -l)


wall " #Architecture: $arch
#CPU physical : $fcpu
#vCPU : $vcpu
#Memory Usage: ${ram}MB ($ram_percent%)
#Disk Usage: ${disk}Gb $disk_percent
#CPU load: $cpu_load%
#Last boot: $last_boot
#LVM use: $lvmu
#Connections TCP : $connection ESTABLISHED
#User log: $usr
#Network: IP $ip ($mac)
#Sudo : $nsudo cmd
"

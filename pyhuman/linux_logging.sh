#!/bin/bash

cd /home/ubuntu/human/pyhuman/

filey=/home/ubuntu/hardware_logs/$(date +'%m.%d.%Y-%H.%M.%S').resources.log;

mkdir -p /home/ubuntu/hardware_logs/

git pull origin >> $filey

echo "$(date +'%m.%d.%Y-%H.%M.%S'): STARTED LOGGING - - - - - - - - - - - " >> $filey;

function pcpugrep() { pgrep $@ | xargs --no-run-if-empty ps -o command,pid,cpuid,%cpu,%mem --sort -%cpu | head -n 10;}

function pmemgrep() { pgrep $@ | xargs --no-run-if-empty ps -o command,pid,cpuid,%cpu,%mem --sort -%mem | head -n 10;}


while :
	do
		echo "$(date +'%m.%d.%Y-%H.%M.%S') DIAGNOSTICS - - - - - - - - - - - " >> $filey;
		echo "CPU DIAGNOSTICS + + + + + + + + + + + + +" >> $filey;
		mpstat >> $filey

		printf "\n" >> $filey


		echo -n "TOTAL NUMBER OF PROC RUNNING: " >> $filey;
		ps aux --no-heading | wc -l >> $filey;

		printf "\n" >> $filey

		echo "LOADAVGS = = = = = = = = = = = = = = =" >> $filey;
		uptime >> $filey

		printf "\n\n" >> $filey

		echo "LIST OF CHROME PROCESSES BY CPU:" >> $filey;
		pcpugrep chrome >> $filey; 

		printf "\n" >> $filey

		echo "LIST OF CHROME PROCESSES BY MEM:" >> $filey;
		pmemgrep chrome >> $filey; 

		printf "\n" >> $filey

		echo "AVILABLE DISK SPACE:" >> $filey;
		df -h >> $filey; 



		printf "\n\n\n" >> $filey;

		sleep 15m

	done


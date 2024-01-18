#!/bin/bash

cd /home/ubuntu/human/pyhuman/

filey=/home/ubuntu/mchp_logs/$(date +'%m.%d.%Y-%H.%M.%S').mchp_linux.log;

mkdir -p /home/ubuntu/mchp_logs/

echo "$(date +'%m.%d.%Y-%H.%M.%S'): STARTED LOGGING" >> $filey;

while : 
        do
                echo "$(date +'%m.%d.%Y-%H.%M.%S') BEGINNING HUMAN EXECUTION - - - - - - - - - - - - - - - " >> $filey;
		xvfb-run -a python3 ./human.py >> $filey;


                echo "$(date +'%m.%d.%Y-%H.%M.%S') CRASHED - - - - - - - - - - - - - - - - - - - - - - - - " >> $filey;
                # cleanup any processes laying around.
                killall -9 chrome chromedriver nacl_helper Xvfb xvfb-run python3 >> $filey;
                rm -r ~/Downloads/* >> $filey;
        done

echo "(date +'%m.%d.%Y-%H.%M.%S') END LOGGING" > $filey;

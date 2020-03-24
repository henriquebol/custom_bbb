#!/bin/bash

# sudo wget -O - https://raw.githubusercontent.com/henriquebol/custom_bbb/master/bbb_cron.sh | sudo bash

cd ~/
mkdir cron
cd ~/cron

sudo wget -O - https://raw.githubusercontent.com/henriquebol/custom_bbb/master/cron.daily/bbb-recording-cleanup  bbb-recording-cleanup
sudo wget -O - https://raw.githubusercontent.com/henriquebol/custom_bbb/master/cron.daily/bigbluebutton  bigbluebutton

sudo cp bbb-recording-cleanup /etc/cron.daily/
sudo cp bigbluebutton /etc/cron.daily/

sudo chown root:root /etc/cron.daily/bbb-recording-cleanup
sudo chmod 755 /etc/cron.daily/bbb-recording-cleanup

sudo chown root:root /etc/cron.daily/bigbluebutton
sudo chmod 755 /etc/cron.daily/bigbluebutton

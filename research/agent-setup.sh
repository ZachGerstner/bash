#!/bin/bash
#EDIT THIS BEFORE USE!!!!
CONTROLLER_IP=130.127.38.2
CONTROLLER_PORT=6011
DESIRED_IP=192.168.2.1/24
PARTNER_IP=192.168.2.2 #any other machine in the topology
#Go To line 56 change the perl command as needed
#####################################################################
#Should be Automatic From this point on  more or less except 59     #
#####################################################################
echo 'Before running this script check the following :'
echo "	1. The script variables are set correctly including line 59.
	2. The controller has been properly configured and is running
		->For controller assistance contact <cbarrin@clemson.edu>"
echo 'You have 5 seconds to exit to make any necessary adjustments.'

sleep 5

echo 'Warning: This script was built for installing sos agents in cloudlab and Geni environments.'
echo '		Please report any missing dependencies to <zigerst@clemson.edu>'
echo 'Warning: This script will run to completion with only pauses to check output.'

sleep 3

echo 'Checking if ovs is present...'

OVS=$(ovs-vswitchd --version)
if [-z $OVS ]
	echo 'OVS was not found, verify that it is properly installed. If so remove these lines.'
	exit
else

	echo 'Checking and installing necessary dependencies...'
	sudo apt-get update
	sudo apt-get install clang -y
	sudo apt-get install uuid-dev -y
	sudo apt-get install libxml2-dev -y
	sudo apt-get install screen -y
	sudo apt-get install vim -y
	sudo apt-get install xfspogs -y
	sudo apt-get install python-setuptools -y
	sudo apt-get install xfslibs-dev -y
	sudo apt-get install python-dev -y
	sudo apt-get install numactl -y
	sudo apt-get install libnuma-dev -y
	echo 'Dependency install complete, 5 second rest to exit should errors occur.'
	
	sleep 5

	echo 'Building Bridge...'
	sudo ovs-vsctl add-br br0
	sudo ovs-vsctl add-port br0 $(ifconfig | awk '{print $1}' | grep "vlan")
	sudo ifconfig $(ifconfig | awk '{print $1}' | grep "vlan") 0 up
	sudo ifconfig br0 $DESIRED_IP up
	sudo ovs-vsctl set-controller br0 tcp:$CONTROLLER_IP:$CONTROLLER_PORT
	sudo ovs-vsctl show
	ifconfig br0 

	sleep 5

	echo 'Checking if flows are correct...'
	ping -c 3 $PARTNER_IP
	ping -c 3 $CONTROLLER_IP

	sleep 5

	echo 'Installing SoS Agents now...'
	sudo git clone http://github.com/cbarrin/sos-agent 
	cd ./sos-agent
	sudo perl -p -i -e 's/10.0.255/192.168.2/g' ./common.h
	sudo make 
	#curl http://$CONTROLLER_IP:$CONTROLLER_PORT/wm/sos/agent/add/jason '{"ip-address":"'$DESIRED_IP'", "data-port":
	echo 'Instillation complete.'
	echo 'Do not forget to configure the controller with this agent!'
	echo 'This is done through the REST-API found on page https://clemsonopenflowgroup.atlassian.net/wiki/display/SOS/How+to+Use+the+SOS+Controller'
	echo 'To run the SoS agent run ./run.sh.'	
	echo 'Recommended that you do so from a screen session.'
fi

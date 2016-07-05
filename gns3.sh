#!/bin/bash

case "$1" in
	start)
		/usr/bin/gns3server --config /opt/gns3/.config/gns3_server.conf --log /opt/gns3/.log/gns3_server.log --pid /opt/gns3/.pid/gns3.pid --controller --daemon; /bin/bash
		;;
	status)
		ps -ef | awk '/gns3server/&&/python3/&&!/grep/ {print $9 " has been executed and is running on PID "$2}' || echo "GNS3 Server is not running. | Usage: $0 {start|status|restart}"
		;;
	restart)
		ps -ef | awk '/gns3server/&&/python3/&&!/grep/ {print $2}' | xargs kill && rm -rf /opt/gns3/.pid/gns3.pid
		sleep 3
                /usr/bin/gns3server --config /opt/gns3/.config/gns3_server.conf --log /opt/gns3/.log/gns3_server.log --pid /opt/gns3/.pid/gns3.pid --controller --daemon 
		;;
	update-check)
		echo "Checking for update..."
		pip3 install gns3-server --upgrade
		;;
	*)
		echo $"Usage: $0 {start|status|restart|update-check}"
		exit 1
esac
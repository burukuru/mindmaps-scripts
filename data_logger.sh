if [ -f /tmp/data_loader.pid ];
then
	echo "Data Loader runnning"
	DLPID=`cat /tmp/data_loader.pid`
else
	echo "Start the data loader script first"
	exit 1
fi

RUNNING=true
WAITING=false
echo $$ > /tmp/data_logger.pid

trap 'RUNNING=false' SIGUSR1
trap 'WAITING=false' SIGUSR2

kill -SIGUSR1 $DLPID

while $RUNNING;
do
	while $WAITING;
	do
		sleep 10
	done
	(tail -f mindmaps.log & ) | grep -q -e "Ontology loaded" -e "All tasks done"
	#pkill -P $$ tail
	kill -SIGUSR1 $DLPID
	echo "Sent SIGUSR1"
	WAITING=true
done

echo "Everything done. Quitting."
rm /tmp/data_logger.pid
exit 0
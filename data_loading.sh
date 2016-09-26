TMP=`echo $PWD`
SCHEMA=\'\{\"path\":\"$TMP/schema.gql\"\}\'
DATA=\'\{\"path\":\"$TMP/movie-data.gql\"\}\'

WAITING=true

echo $$ > /tmp/data_loader.pid
trap 'WAITING=false' SIGUSR1
### THE FOLLOWING COMMANDS MUST BE EXECUTED IN ORDER!
## Instructions: Uncomment each of the following lines one at a time, in order
## and execute everytime this script from the folder where the Movie .gql files are located
echo "Waiting for the logger to start"
while $WAITING;
do
	sleep 1
done
sleep 1
LOGGERPID=`cat /tmp/data_logger.pid`
echo "Logger started"
echo "Loading the ontology"
eval curl -H \"Content-Type: application/json\" -X POST -d `echo $SCHEMA` http://localhost:4567/import/ontology

while $WAITING;
do
	sleep 1
done
echo "Ontology loaded"
WAITING=true
echo "Loading data"
eval curl -H \"Content-Type: application/json\" -X POST -d `echo $DATA` http://localhost:4567/import/batch/data
sleep 3
kill -SIGUSR2 $LOGGERPID
while $WAITING;
do
	sleep 1
done

kill -SIGUSR2 $LOGGERPID

while $WAITING;
do
	sleep 1
done
rm /tmp/data_loader.pid

kill -SIGUSR1 $LOGGERPID
kill -SIGUSR2 $LOGGERPID
echo "Everything loaded! You can start Graql now!"
exit 0
#Ontology loaded
#All tasks done!
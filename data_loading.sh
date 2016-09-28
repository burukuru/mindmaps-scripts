#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

LOAD_COMPONENT=all
if [[ $1 == ontology ]]; then
  LOAD_COMPONENT=ontology
elif [[ $1 == data ]]; then
  LOAD_COMPONENT=data
fi

SCHEMA_DIR="$PROGDIR/sample-datasets/movies/"
DATA_GQL_DIR="$PROGDIR/sample-datasets/movies/small-dataset/"
SLAVE_NODES=$(cat $PROGDIR/engine_slave_dev_mindmaps.txt)

SCHEMA="{\"path\":\"$SCHEMA_DIR/schema.gql\"}"
GQL_DATA="{\"path\":\"$DATA_GQL_DIR/large-dataset-data.gql\",\"hosts\":[${SLAVE_NODES}]}"
WAITING=true
LOADING=true

MINDMAPS_LOG=$(lsof -p $(cat /tmp/mindmaps-engine.pid) | grep mindmaps.log | awk '{print $9}')

echo $$ > /tmp/data_loader.pid
sleep 1

if [[ $LOAD_COMPONENT == "all" || $LOAD_COMPONENT == "ontology" ]]; then
  echo "Loading the ontology"
  curl -s -H "Content-Type: application/json" -X POST -d ${SCHEMA} http://localhost:4567/import/ontology

  while $LOADING;
  do
    (tail -n1 -f ${MINDMAPS_LOG} & ) | grep -q -e "Ontology loaded" -e "All tasks done" && LOADING=false && WAITING=false
    while $WAITING;
    do
      sleep 2
    done
  done
  echo ""
  echo "Ontology loaded"
fi

LOADING=true
COUNT=0

if [[ $LOAD_COMPONENT == "all" || $LOAD_COMPONENT == "data" ]]; then
  echo "Loading data"
  curl -s -H "Content-Type: application/json" -X POST -d ${GQL_DATA} http://localhost:4567/import/distribute/data
  sleep 3
  while $LOADING;
  do
    (tail -n0 -f ${MINDMAPS_LOG} & ) | grep -q -e "All tasks done" && let COUNT+=1
    if [[ $COUNT -ge 2 ]]; then
      LOADING=false
    fi
  done
  echo ""
  echo "Data loaded"
fi

rm /tmp/data_loader.pid

echo ""
echo "Everything loaded! You can start Graql now!"
exit 0
##Ontology loaded
##All tasks done!

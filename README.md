# mindmaps-scripts

A bunch of scripts useful for working with [MindmapsDB](https://mindmaps.io) software stack

### nightly_build.command
If you download this on a Mac, you can double click it wherever it is and it will do several things:
* Download the latest version of the [MindmapsDB](https://github.com/mindmapsdb/mindmapsdb) source code from GitHub
* Build it with Maven
* Download a copy of the latest version of the [Sample Datasets](https://github.com/mindmapsdb/sample-datasets)
* Load the small Movie dataset into the graph using other scripts in this repository

To make the scripts work, you will need to install and setup

1. Java 8 and the JAVA_HOME variable

2. Maven

3. git

### data_loading.sh

Fill out engine_slave_dev_mindmaps.txt as required with comma-separated double-quoted IP addresses of Engine servers.
Load ontology + data: ./data_loading.sh
Load ontology: ./data_loading.sh ontology
Load data: ./data_loading.sh data

## Disclaimer
These scripts are distibuted without any guarantee they will work, nor any support on my part. I use them to do repetitive tasks and thought to share them. Use them as you please, but at your own risk.

## Known problems

* When the script has finished loading the dataset, it will hang after printing "Everything loaded! You can start Graql now!". This is due to the data_loading.sh script running in the background that has not been terminated as it should have had. Just Ctrl+C and the script will go on.
* If anything goes wrong, you will have two files left in your /tmp/ folder (namely /tmp/data_logger.pid and /tmp/data_loader.pid) that need to be removed by hand.
* Once again, if something goes wrong, there will probably be MindmapsDB engine and Cassandra running. Stop them using MindmapsDB script or just ```sudo pkill -9 java``` if that does not work.

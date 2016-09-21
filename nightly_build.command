#This will build a fresh install of MindmapsDB on your desktop folder.
#After that it will download the sample-datasets and load the small movie dataset into the graph

TD=`date "+%Y-%m-%d-%H_%M"`
echo $TD
cd ./Desktop
mkdir $TD
cd $TD
git clone https://github.com/mindmapsdb/mindmapsdb.git
cd mindmapsdb
mvn package -DskipTests
cd mindmaps-dist/target
unzip *.zip
cd mindmaps*
ln -s $PWD/bin ../../../bin
ln -s $PWD/logs ../../../logs
cd ../../../../
git clone https://github.com/mikonapoli/mindmaps-scripts.git
mv ./mindmaps-scripts/data_logger.sh ./mindmapsdb/logs/
chmod +x ./mindmapsdb/logs/data_logger.sh
git clone https://github.com/mindmapsdb/sample-datasets.git
cp ./mindmaps-scripts/data_loading.sh ./sample-datasets/movies/small-dataset/
mv ./mindmaps-scripts/data_loading.sh ./sample-datasets/movies/large-dataset/
cp ./sample-datasets/movies/schema.gql ./sample-datasets/movies/small-dataset/
cp ./sample-datasets/movies/schema.gql ./sample-datasets/movies/large-dataset/
chmod +x ./sample-datasets/movies/small-dataset/data_loading.sh
chmod +x ./sample-datasets/movies/large-dataset/data_loading.sh
./mindmapsdb/bin/mindmaps.sh start
cd sample-datasets/movies/small-dataset
./data_loading.sh &
cd ../../../mindmapsdb/logs
sleep 10
./data_logger.sh
cd ../../
rm -rf mindmaps-scripts/
./mindmapsdb/bin/mindmaps.sh stop
#### RUN TESTS 
Permissions to files be executables 

```
chmod +x applicacaoEsolucao2.sh del appTimeToDeployTest.sh
```
#### 1. DEPLOY ONLY APPLICATION
Be sure that all images, (workpress, mysql, netflow_data_export, netflow_collector),  solution and app containers were removed.
```
./del
docker-compose up -d 
``` 
#### 2. APP DEPLOY TIME TEST
Before run test a tool to see styled csv can be installed:
```
sudo apt-get install nodejs
sudo apt install npm
```
Input of test are number of times that the test is run, (_first argument_), and the output file, (_second argument_), that will contain measure values. (example run 2 tests and store measures in appResults.csv)
``` 
./del
bash appTimeToDeployTest.sh  2 appResults.csv
``` 
#### 1. DEPLOY APPLICATION AND SOLUTION

```
./del
./aplicacaoEsolucao2.sh
```
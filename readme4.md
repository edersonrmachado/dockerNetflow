#### RUN TESTS 
Permissions to files be executables 

```
chmod +x del del2 appTimeToDeployTest.sh appAndSolution.sh runAppAndSolution.sh appWithImage.sh  appAndSolutionWithImage.sh
```
#### 1. DEPLOY ONLY APPLICATION WITH PRELOADED IMAGES
Run application to load images. ./del2 will remove network and containers, leaving only workpress and mySql images
```
docker-compose up -d
.\del2
``` 
Once Images were loaded we can run app deploy time test. To do it we use a bash file  _appWithImage.sh_ chosing arguments accordingly.  The first argument is the number of times that the test will run, and the second argument is the output file, that will contain measure values in csv format. (example run 30 tests and store measures in _deployWithImages.csv_)
```
bash appWithImage.sh 30 deployWithImages.csv
``` 
Detailed information of results fields are presented in *variables_descriptor* file. We can see results in styled csv tty format installing following tools:
```
sudo apt-get install nodejs
sudo apt install npm
```
After revised  errors in output csv file, we can see styled table of results with
```
sudo npm i -g tty-table
cat deploWIthImages.csv | tty-table
```
#### 2. DEPLOY  APPLICATION AND SOLUTION WITH PRELOADED IMAGES 
Run application and solution to  load images. ./del2 will remove network and containers, leaving only _workpress_, _mySql_, *aqualtune/netflow_collector* and *aqualtune/netflow_data_export* images.
```
bash appAndSolutionWithImage.sh 1 deployAppAndSolutionWithImages.csv
rm deployAppAndSolutionWithImages.csv
``` 
Run final test
```
bash appAndSolutionWithImage.sh 30 deployAppAndSolutionWithImages.csv
``` 

After revise  errors in output csv file, we can see styled tty table of results with:
```
sudo npm i -g tty-table
cat deployAppAndSolutionWithImages.csv | tty-table
```
 
#### 3. DEPLOY APLICATION PULLING IMAGES FROM INTERNET REPOSITORY
This test is not very useful once it depends on internet traffic rate.

``` 
./del
bash appTimeToDeployTest.sh  30 appResults.csv
``` 
Styled tty results
```
sudo npm i -g tty-table
cat appDeploy.csv | tty-table
```


#### 4. DEPLOY APPLICATION AND SOLUTION PULLING IMAGES FORM INTERNET REPOSITORY

```
./del
bash appAndSolution.sh  30 appAndSolution.csv
```
After revise errors in output csv file, we can see styled tty table of results with:
```
sudo npm i -g tty-table
cat appAndSolution.csv | tty-table
```
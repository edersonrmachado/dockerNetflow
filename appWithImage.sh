#!/bin/sh

#$1 : number of times that app test will run
#$2 : filename to save results

echo "starting Application deploy time test $1x ... "
echo -e "%E,%e,%S,%U,%P,%M,%K,%D,%p,%X,%Z,%F,%R,%W,%c,%w,%I,%O,%r,%s,%k,%C,%x">>$2

i=1
while [ $i -le $1 ]
do
 echo -e "--------------------------------------------------\n"	
 echo -e  "\tStart deploy number:$i...\n "
 echo -e "--------------------------------------------------\n"       
 # store time of app deploy in X variable
 /usr/bin/time -o $2 -a  -f   "%E,%e,%S,%U,%P,%M,%K,%D,%p,%X,%Z,%F,%R,%W,%c,%w,%I,%O,%r,%s,%k,%C,%x" docker-compose up -d
 
 # increase i value
 i=`expr $i + 1`

 # delete containers, network and images created without show them  in shell
 ./del2 >/dev/null
done
echo -e "------------------ Test Finished ------------------\n"
# clear terminal shell
clear

# show file generated
echo "CSV file generated:"
cat "$2"

# content result descriptor
echo " Content Result Descriptor"
cat  variables_descriptor

# show  styled results table
#echo "tty table"
#sudo  npm i -g tty-table >/dev/null
#cat $2 | tty-table



#!/bin/bash

###################################################
#Perpous: To Detect the changes in the passwd file
#Version: 1.0
#Author : Aditya Patel <adityapatel081993@gmail.com>
#Input  : N/A
#Output : User add or delated
####################################################

# copy the password file
cp /etc/passwd /tmp/original_pass_file.txt

#Assiging variables to file with path
BACKUP_FILE=/tmp/backup_file.txt
PASS_FILE=/tmp/original_pass_file.txt

#create the difference file and saving the output to /tmp/diff_file.txt
diff ${BACKUP_FILE} ${PASS_FILE}  |  awk -F':' '{ print $1,$3 }' > /tmp/diff_file.txt

FILES=/tmp/diff_file.txt
LOG_FILE=/tmp/log.txt

if [ -s $FILES ]
then
        date
        echo -e "\n--------------"
        awk '{ if ($1 == "<") print "User Deleted : " $2 " and UID is = " $3 }' $FILES
        awk '{ if ($1 == ">") print "User Added : " $2 " and UID is = " $3 }' $FILES
        echo -e "--------------\n"

# for creating the log file
        date >>$LOG_FILE
        echo -e "\n--------------" >>$LOG_FILE
        awk '{ if ($1 == "<") print "User Deleted : " $2 " and UID is = " $3 }' $FILES >>$LOG_FILE
        awk '{ if ($1 == ">") print "User Added : " $2 " and UID is = " $3 }' $FILES >>$LOG_FILE
        echo -e "--------------\n" >>$LOG_FILE
else
        date
        echo -e "\n--------------"
        echo -e "No new changes found"
        echo -e "--------------\n"

# for creating the log file
        date >>/tmp/log.txt
        echo -e "\n--------------" >>$LOG_FILE
        echo -e "No new changes found" >>$LOG_FILE
        echo -e "--------------\n" >>$LOG_FILE
        exit
fi

# matching the BACKUP_FILE and PASS_FILE
cp $PASS_FILE $BACKUP_FILE

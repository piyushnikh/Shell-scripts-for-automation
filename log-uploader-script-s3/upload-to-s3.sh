#!/bin/bash

#Script to optimize log storage.
#Author : Piyush
#Version: V1-final
#Usage: ./s3-upload.sh

###########Declaring variables###################################################

JENKINS_HOME="/var/lib/jenkins"
S3_BUCKET="s3://jenkins-log-storage-bucket"
DATE="$(date +%Y-%m-%d)"

#################################################################################

####################Validate if AWS CLI is installed & configured################

/usr/local/bin/aws --version

if [ "$?" -eq 0 ]; then
    echo "AWS CLI is installed on your machine! You rock!"
else 
    echo "Install AWS CLI by link --> https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
fi 

#################################################################################

############################## Core logic #########################################

for job_dir in ""$JENKINS_HOME"/jobs/"*/; do
    job_name="$(basename "$job_dir")"

    for build_dir in ""$job_dir"/builds/"*/; do
        build_number="$(basename "$build_dir")"
        log_file="$build_dir/log"

        if [ -f "$log_file" ] && [ "$(date -r "$log_file" +%Y-%m-%d)" = "$DATE" ]; then
            # Upload files into S3 bucket
            /usr/local/bin/aws s3 cp "$log_file" "$S3_BUCKET/$job_name-$build_number.log"

            if [ "$?" -eq 0 ]; then
                echo "The logs are uploaded successfully!"
            else
                echo "There was an error, check further."
            fi
        fi
    done
done 

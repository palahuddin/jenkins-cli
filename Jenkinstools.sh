#!/bin/bash

usage="
Jenkins Cli Script

Usage:
   $0 <task>

Available 'task' :
   list        List all job
   get         Dump job to XML file
   copy        Cloning job to new job
   get-all     Dump all job to XML file
   update-all  Update all job from XML file
"
task=$1

function jenkins () {
    java -jar jenkins-cli.jar -s `cat domain` -webSocket -auth @Jenkinstoken $@
}

case $task in
    list)
        jenkins list-jobs
    ;;
    get)
        echo $(cat list.xml |grep xxx)
    ;;
    get-all)
        ARR=( $($0 list) )
        for i in ${ARR[@]};do
            echo "---DUMP JOB: $i "
            jenkins get-job $i > ${dir:=.}/$i.xml
        done
    ;;
    copy)
    ;; 
    update-all)
        echo "[ Create Backup First... ]"
        dir="$(date +%H%m%S)"
        mkdir -p $dir
        dir="$(date +%H%m%S)" $0 get-all
        echo "[ Update Jobs... ]"
        dir="."
        ARR=( $($0 list) )
        for i in ${ARR[@]};do
            echo "---UPDATE JOB: $i "
            jenkins update-job $i < ${dir:=.}/$i.xml
        done
    ;;                    
    *)
         echo "$usage"
    ;;            
esac
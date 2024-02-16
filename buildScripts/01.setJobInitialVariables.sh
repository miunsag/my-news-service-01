#!/bin/bash
# Set Job Common Variables

echo 'Computing initial local variables for job'
JOB_DATE=$(date +%y-%m-%d)
echo "JOB_DATE=${JOB_DATE}"
## Azure DevOps Specific
echo "##vso[task.setvariable variable=JOB_DATE;]${JOB_DATE}"

JOB_DATETIME=$(date +%y-%m-%d'T'%H.%M.%S_%3N)
echo "JOB_DATETIME=${JOB_DATETIME}"
## Azure DevOps Specific
echo "##vso[task.setvariable variable=JOB_DATETIME;]${JOB_DATETIME}"

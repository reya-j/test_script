#!/bin/bash -e
export PRE_JOB=push_image_tag
export PRE_JOB_UP=$(echo ${PRE_JOB//-/} | awk '{print toupper($0)}')
echo $PRE_JOB_UP

export PRE_JOB_OPERATION=$(eval echo "$"$PRE_JOB_UP"_OPERATION")
echo pre_operation=$PRE_JOB_OPERATION

export PRE_JOB_STATE=$(eval echo "$"$PRE_JOB_UP"_STATE")
echo pre_job_state=$PRE_JOB_STATE

export PRE_JOB_PATH=$(eval echo "$"$PRE_JOB_UP"_PATH")
echo pre_job_path=$PRE_JOB_PATH

export PRE_JOB_TYPE=$(eval echo "$"$PRE_JOB_UP"_TYPE")
echo pre_job_type=$PRE_JOB_TYPE

export PRE_JOB_VERSIONNUMBER=$(eval echo "$"$PRE_JOB_UP"_VERSIONNUMBER")
echo pre_job_versionnumber=$PRE_JOB_VERSIONNUMBER

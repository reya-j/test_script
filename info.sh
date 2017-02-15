#!/bin/bash -e

echo 'sample-script for runsh1'     
export CURR_REPO_RESO=sample-script
export CURR_REPO_RESO_UP=$(echo ${CURR_REPO_RESO//-/} | awk '{print toupper($0)}')

echo "<===About resource repo===>"
export REPO_RESO_VERSION=$(eval echo "$"$CURR_REPO_RESO_UP"_VERSIONNUMBER")
export MY_REPO_BRANCH=$(eval echo "$"$CURR_REPO_RESO_UP"_BRANCH")
export MY_REPO_COMMIT=$(eval echo "$"$CURR_REPO_RESO_UP"_COMMIT")
export MY_REPO_COMMIT_MESSAGE=$(eval echo "$"$CURR_REPO_RESO_UP"_COMMIT_MESSAGE")
export MY_REPO_COMMITTER=$(eval echo "$"$CURR_REPO_RESO_UP"_COMMITTER")
#export MY_REPO_PULL_REQUEST=$(eval echo "$"$CURR_REPO_RESO_UP"_PULL_REQUEST")
#export MY_REPO_BASE_BRANCH=$(eval echo "$"$CURR_REPO_RESO_UP"_BASE_BRANCH")
#export MY_REPO_HEAD_BRANCH=$(eval echo "$"$CURR_REPO_RESO_UP"_HEAD_BRANCH")

echo REPO_RESOURCE_VERSION=$REPO_RESO_VERSION
echo MY_BRANCH=$MY_REPO_BRANCH
echo MY_COMMIT=$MY_REPO_COMMIT
echo MY_COMMIT_MESSAGE=$MY_REPO_COMMIT_MESSAGE
echo MY_RESO_COMMITER=$MY_REPO_COMMITTER
#echo MY_RESO_PULL_REQUEST=$MY_REPO_PULL_REQUEST
#echo MY_RESO_BASE_BRANCH=$MY_REPO_BASE_BRANCH
#echo MY_RESO_HEAD_BRANCH=$MY_REPO_HEAD_BRANCH

echo "<===Got about reso repo===>"

echo RESO_ID_RUNSH_REPO=$RESOURCE_ID
echo MY_JOB_NAME=$JOB_NAME
echo MY_JOB_TYPE=$JOB_TYPE

echo "MY_BUILD_ID=$BUILD_ID"
echo "MY_BUILD_NUMBER=$BUILD_NUMBER"
echo "MY_BUILD_JOB_ID=$BUILD_JOB_ID"
echo "MY_BUILD_JOB_NUMBER=$BUILD_JOB_NUMBER"

echo MY_JOB_STATE=$JOB_STATE
echo MY_JOB_PREVIOUS_STATE=$JOB_PREVIOUS_STATE
echo MY_JOB_MESSAGE_PATH=$JOB_MESSAGE

export MY_JOBNAME_PREVIOUS_STATE=$(eval echo "$"$JOB_NAME"_PREVIOUS_STATE")
export MY_JOBNAME_STATE=$(eval echo "$"$JOB_NAME"_STATE")
export MY_JOBNAME_PATH=$(eval echo "$"$JOB_NAME"_PATH")
export MY_JOBNAME_MESSAGE=$(eval echo "$"$JOB_NAME"_MESSAGE")

echo $MY_JOBNAME_STATE
echo $MY_JOBNAME_PREVIOUS_STATE
echo $MY_JOBNAME_PATH
echo $MY_JOBNAME_MESSAGE

export RES_MY_DOCKERHUB_INTEGRATIONRESO=my-docker-int
export RES_MY_DOCKERHUB_INTEGRATIONRESO_UP=$(echo ${RES_MY_DOCKERHUB_INTEGRATIONRESO//-/} | awk '{print toupper($0)}')
export MY_DOCKERHUB_INTEGRATION=$RES_MY_DOCKERHUB_INTEGRATIONRESO_UP"_INTEGRATION" #this is fetches docker integration details like username, email or password

export MY_DH_USERNAME=$(eval echo "$"$MY_DOCKERHUB_INTEGRATION"_USERNAME")
export MY_DH_PASSWORD=$(eval echo "$"$MY_DOCKERHUB_INTEGRATION"_PASSWORD")
export MY_DH_EMAIL=$(eval echo "$"$MY_DOCKERHUB_INTEGRATION"_EMAIL")

echo "MY_DOCH_USERNAME=$MY_DH_USERNAME"
echo "MY_DOCH_PASSWORD_LENGTH=${#MY_DH_PASSWORD}" 
echo "MY_DOCH_EMAIL=$MY_DH_EMAIL"
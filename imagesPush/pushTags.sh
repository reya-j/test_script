#!/bin/bash -e
#sleep 4m
export TEST_CURR_JOB="push_image_tag"
export TEST_RES_DH="ship_dh"
export TEST_RES_REPO="scriptami_repo"
export RES_IMAGE_OUT="test_out_img"

# since resources here have dashes Shippable replaces them and UPPER cases them
export TEST_RES_REPO_UP=$(echo $TEST_RES_REPO | awk '{print toupper($0)}')
export TEST_RES_REPO_STATE=$(eval echo "$"$TEST_RES_REPO_UP"_STATE")

#get dockerhub EN string
export TEST_RES_DH_UP=$(echo $TEST_RES_DH | awk '{print toupper($0)}')
export TEST_RES_DH_INT_STR=$TEST_RES_DH_UP"_INTEGRATION"
  
export RES_IMAGE_OUT_UP=$(echo $RES_IMAGE_OUT | awk '{print toupper($0)}')
export RES_IMAGE_OUT_VERSION=$(eval echo "$"$RES_IMAGE_OUT_UP"_VERSIONNUMBER")
echo "-----> Out image resource"
echo RES_IMG_OUT_VERSION=$RES_IMAGE_OUT_VERSION
echo RES_IMG_OUT_UP=$RES_IMAGE_OUT_UP

echo "-----> Installed package versions"
echo PACKER_VERSION=$(packer version)
echo TERRAFORM_VERSION=$(terraform --version)

echo "-----> About buildsJob"
echo RESO_ID_RUNSH_REPO=$RESOURCE_ID
echo TEST_JOB_NAME=$JOB_NAME
echo TEST_JOB_TYPE=$JOB_TYPE
echo TEST_BUILD_ID=$BUILD_ID
echo TEST_BUILD_NUMBER=$BUILD_NUMBER
echo TEST_BUILD_JOB_ID=$BUILD_JOB_ID
echo TEST_BUILD_JOB_NUMBER=$BUILD_JOB_NUMBER
echo TEST_JOB_STATE=$JOB_STATE
echo TEST_JOB_PREVIOUS_STATE=$JOB_PREVIOUS_STATE
echo TEST_JOB_MESSAGE_PATH=$JOB_MESSAGE

export TEST_JOBNAME_PREVIOUS_STATE=$(eval echo "$"$JOB_NAME"_PREVIOUS_STATE")
export TEST_JOBNAME_STATE=$(eval echo "$"$JOB_NAME"_STATE")
export TEST_JOBNAME_PATH=$(eval echo "$"$JOB_NAME"_PATH")
export TEST_JOBNAME_MESSAGE=$(eval echo "$"$JOB_NAME"_MESSAGE")

echo $TEST_JOBNAME_STATE
echo $TEST_JOBNAME_PREVIOUS_STATE
echo $TEST_JOBNAME_PATH
echo $TEST_JOBNAME_MESSAGE

echo "-----> About git repo resource"
set_context() {
  export TEST_VERSION=$(eval echo "$"$TEST_RES_REPO_UP"_VERSIONNUMBER")
  export TEST_REPO_BRANCH=$(eval echo "$"$TEST_RES_REPO_UP"_BRANCH")
  export TEST_REPO_COMMIT=$(eval echo "$"$TEST_RES_REPO_UP"_COMMIT")
  export TEST_REPO_COMMIT_MESSAGE=$(eval echo "$"$TEST_RES_REPO_UP"_COMMIT_MESSAGE")
  export TEST_REPO_COMMITTER=$(eval echo "$"$TEST_RES_REPO_UP"_COMMITTER")  
  #export MY_REPO_PULL_REQUEST=$(eval echo "$"$VAN_RES_REPO_UP"_PULL_REQUEST")
  #export MY_REPO_BASE_BRANCH=$(eval echo "$"$VAN_RES_REPO_UP"_BASE_BRANCH")
  #export MY_REPO_HEAD_BRANCH=$(eval echo "$"$VAN_RES_REPO_UP"_HEAD_BRANCH")



  echo TEST_RES_REPO=$TEST_RES_REPO
  echo TEST_RES_REPO_UP=$TEST_RES_REPO_UP
  echo TEST_RES_REPO_STATE=$TEST_RES_REPO_STATE

  echo TEST_REPO_RESO_VERSION=$TEST_VERSION
  echo TEST_BRANCH=$TEST_REPO_BRANCH
  echo TEST_COMMIT=$TEST_REPO_COMMIT
  echo TEST_COMMIT_MESSAGE=$TEST_REPO_COMMIT_MESSAGE
  echo TEST_RESO_COMMITER=$TEST_REPO_COMMITTER
  #echo TEST_RESO_PULL_REQUEST=$TEST_REPO_PULL_REQUEST
  #echo TEST_RESO_BASE_BRANCH=$TEST_REPO_BASE_BRANCH
  #echo TEST_RESO_HEAD_BRANCH=$TEST_REPO_HEAD_BRANCH
  
}

get_params() {
  echo "-----> Env in paramas resource"
  export RES_PARAMS="test_params"
  export RES_PARAMS_UP=$(echo $RES_PARAMS | awk '{print toupper($0)}')
  export RES_PARAMS_STR=$RES_PARAMS_UP"_PARAMS"
  export USER_PARAM=$(eval echo "$"$RES_PARAMS_STR"_TEST")
  export SEC_PARAM=$(eval echo "$"$RES_PARAMS_STR"_DEV")

  echo RES_PARAMS_STR=$RES_PARAMS_STR
  echo USER_PARAM=$USER_PARAM
  echo SEC_PARAM=$SEC_PARAM
}

dockerhub_login() {
  echo "-----> Logging in to Dockerhub" 
  
  export TEST_DH_USERNAME=$(eval echo "$"$TEST_RES_DH_INT_STR"_USERNAME")
  export TEST_DH_PASSWORD=$(eval echo "$"$TEST_RES_DH_INT_STR"_PASSWORD")
  export TEST_DH_EMAIL=$(eval echo "$"$TEST_RES_DH_INT_STR"_EMAIL")
  
  echo TEST_DH_USERNAME=$TEST_DH_USERNAME
  echo TEST_DH_PASSWORD_LENGTH=${#TEST_DH_PASSWORD} #show only count
  sudo docker login -u $TEST_DH_USERNAME -p $TEST_DH_PASSWORD -e $TEST_DH_EMAIL
}


create_out_state() {

  echo "-----> Creating a state file for $RES_IMG_OUT_UP"
  echo versionName=$TEST_VERSION > "$TEST_STATE/$RES_IMAGE_OUT.env"
  echo commitSHA=$TEST_REPO_COMMIT >> "$JOB_STATE/$RES_IMAGE_OUT.env"
  
  echo "-----> Creating a state file for $TEST_CURR_JOB"
  echo versionName=$TEST_VERSION > "$JOB_STATE/$TEST_CURR_JOB.env"
  cat "$JOB_STATE/$TEST_CURR_JOB.env"

  echo "-----> Creating a previous state file for $TEST_CURR_JOB"
  cat "$JOB_PREVIOUS_STATE/$TEST_CURR_JOB.env"
    
}

main() {
  set_context
  get_params
  dockerhub_login
  create_out_state  
  
}

main

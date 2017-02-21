#!/bin/bash -e

export TEST_CURR_JOB="push_image_tag"
###### remove this export VAN_RES_VER="ship_ver"
export TEST_RES_DH="ship_dh"
export TEST_RES_REPO="scriptami_repo"
export RES_IMAGE_OUT="test_out_img"

# since resources here have dashes Shippable replaces them and UPPER cases them
###### remove this export VAN_RES_VER_UP=$(echo ${VAN_RES_VER//-/} | awk '{print toupper($0)}')

# get dockerhub EN string
export TEST_RES_DH_UP=$(echo $TEST_RES_DH | awk '{print toupper($0)}')
export TEST_RES_DH_INT_STR=$TEST_RES_DH_UP"_INTEGRATION"

# since resources here have dashes Shippable replaces them and UPPER cases them
export TEST_RES_REPO_UP=$(echo $TEST_RES_REPO | awk '{print toupper($0)}')
export TEST_RES_REPO_STATE=$(eval echo "$"$TEST_RES_REPO_UP"_STATE")


export RES_IMAGE_OUT_UP=$(echo $RES_IMAGE_OUT | awk '{print toupper($0)}')
export RES_IMAGE_OUT_VERSION=$(eval echo "$"$RES_IMAGE_OUT_UP"_VERSIONNUMBER")
echo RES_IMG_OUT_VERSION=$RES_IMAGE_OUT_VERSION
echo RES_IMG_OUT_UP=$RES_IMAGE_OUT_UP
echo "<<<<<<<<<<<<<<<<<<<<<<============== THIS IS ABOUT JOBS AND BUILDS ==============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo RESO_ID_RUNSH_REPO=$RESOURCE_ID
echo TEST_JOB_NAME=$JOB_NAME
echo TEST_JOB_TYPE=$JOB_TYPE

echo "TEST_BUILD_ID=$BUILD_ID"
echo "TEST_BUILD_NUMBER=$BUILD_NUMBER"
echo "TEST_BUILD_JOB_ID=$BUILD_JOB_ID"
echo "TEST_BUILD_JOB_NUMBER=$BUILD_JOB_NUMBER"

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

echo "<<<<<<<<<<<<<<<<<<<<<<============== THIS IS ALL ABOUT JOBS AND BUILDS ==============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

echo "<<<<<<<<<<<<<<<<<<<<<<============== THIS IS ABOUT GITREPO ==============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
set_context() {
 ###### remove this  export VAN_VERSION=$(eval echo "$"$VAN_RES_VER_UP"_VERSIONNAME")
  export TEST_VERSION=$(eval echo "$"$TEST_RES_REPO_UP"_VERSIONNUMBER")
  
  export TEST_REPO_BRANCH=$(eval echo "$"$TEST_RES_REPO_UP"_BRANCH")
  export TEST_REPO_COMMIT=$(eval echo "$"$TEST_RES_REPO_UP"_COMMIT")
  export TEST_REPO_COMMIT_MESSAGE=$(eval echo "$"$TEST_RES_REPO_UP"_COMMIT_MESSAGE")
  export TEST_REPO_COMMITTER=$(eval echo "$"$TEST_RES_REPO_UP"_COMMITTER")  
  #export MY_REPO_PULL_REQUEST=$(eval echo "$"$VAN_RES_REPO_UP"_PULL_REQUEST")
  #export MY_REPO_BASE_BRANCH=$(eval echo "$"$VAN_RES_REPO_UP"_BASE_BRANCH")
  #export MY_REPO_HEAD_BRANCH=$(eval echo "$"$VAN_RES_REPO_UP"_HEAD_BRANCH")

  export TEST_DH_USERNAME=$(eval echo "$"$TEST_RES_DH_INT_STR"_USERNAME")
  export TEST_DH_PASSWORD=$(eval echo "$"$TEST_RES_DH_INT_STR"_PASSWORD")
  export TEST_DH_EMAIL=$(eval echo "$"$TEST_RES_DH_INT_STR"_EMAIL")

 # echo "CURR_JOB=$CURR_JOB"
 # echo "RES_VER=$RES_VER"
 # echo "RES_DH=$RES_DH"
  echo "TEST_RES_REPO=$TEST_RES_REPO"
 # echo "RES_VER_UP=$RES_VER_UP"
 # echo "RES_DH_UP=$RES_DH_UP"
 # echo "RES_DH_INT_STR=$RES_DH_INT_STR"
  echo "TEST_RES_REPO_UP=$TEST_RES_REPO_UP"
  echo "TEST_RES_REPO_STATE=$TEST_RES_REPO_STATE"

  echo "TEST_REPO_RESO_VERSION=$TEST_VERSION"
  
  echo MY_BRANCH=$MY_REPO_BRANCH
  echo MY_COMMIT=$MY_REPO_COMMIT
  echo MY_COMMIT_MESSAGE=$MY_REPO_COMMIT_MESSAGE
  echo MY_RESO_COMMITER=$MY_REPO_COMMITTER
  #echo MY_RESO_PULL_REQUEST=$MY_REPO_PULL_REQUEST
  #echo MY_RESO_BASE_BRANCH=$MY_REPO_BASE_BRANCH
  #echo MY_RESO_HEAD_BRANCH=$MY_REPO_HEAD_BRANCH
  echo "<<<<<<<<<<<<<<<<<<<<<<============== THIS IS ALL ABOUT GITREPO ==============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

  echo "<<<<<<<<<<<<<<<<<<<<<<============== THIS IS ABOUT INTEGRATION ==============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

  echo "MY_DH_USERNAME=$VAN_DH_USERNAME"
  echo "MY_DH_PASSWORD_LENGTH=${#VAN_DH_PASSWORD}" #show only count
 # echo "MY_DH_EMAIL=$VAN_DH_EMAIL"
  echo "<<<<<<<<<<<<<<<<<<<<<<============== THIS IS ALL ABOUT INTEGRATION ==============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

}
echo "<<<<<<<<<<<<<<<<<<<<<<========== PARAMS =============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
export RES_PARAMS="test_params"
export RES_PARAMS_UP=$(echo $RES_PARAMS | awk '{print toupper($0)}')
export RES_PARAMS_STR=$RES_PARAMS_UP"_PARAMS"
export USER_PARAM=$(eval echo "$"$RES_PARAMS_STR"_TEST")
export SEC_PARAM=$(eval echo "$"$RES_PARAMS_STR"_DEV")

echo RES_PARAMS_STR=$RES_PARAMS_STR
echo USER_PARAM=$USER_PARAM
echo SEC_PARAM=$SEC_PARAM

echo "<<<<<<<<<<<<<<<<<<<<<<========== those are my env ===============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<========= VERSIONS ===========>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo PACKER_VERSION=$(packer version)
echo TERRAFORM_VERSION=$(terraform version)
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<========= THATS ABOUT VERSIONS ===========>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

dockerhub_login() {
  echo "Logging in to Dockerhub"
  sudo docker login -u $VAN_DH_USERNAME -p $VAN_DH_PASSWORD -e $VAN_DH_EMAIL
}


create_out_state() {

  echo "Creating a state file for $RES_IMG_OUT_UP"
  echo "MY_REPO_RESO_VERSION=$VAN_VERSION"
  echo "MY_COMMIT=$MY_REPO_COMMIT"
  echo "MY_J_STATE=$JOB_STATE"
  #echo "MY_I_OUT=$RES_IMAGE_OUT"
  echo versionName=$VAN_VERSION > "$JOB_STATE/$RES_IMAGE_OUT.env"
  echo commitSHA=$MY_REPO_COMMIT >> "$JOB_STATE/$RES_IMAGE_OUT.env"
  
  echo "Creating a state file for $VAN_CURR_JOB"
  echo versionName=$VAN_VERSION > "$JOB_STATE/$VAN_CURR_JOB.env"
  #echo CURRENT=current_gitrepo_versionnumber > "$JOB_STATE/$VAN_CURR_JOB.env"
  cat "$JOB_STATE/$VAN_CURR_JOB.env"

  echo "Creating a previous state file for $VAN_PRE_JOB_VER"
 # echo versionName=$(VAN_VERSION) > "$JOB_PREVIOUS_STATE/$VAN_PRE_JOB_VER.env"
  #echo PREVIOUS=previous_gitrepo_versinnumber > "$JOB_PREVIOUS_STATE/$VAN_PRE_JOB_VER.env"
  #echo RC=qa > "$JOB_PREVIOUS_STATE/$VAN_PRE_JOB_VER.env"
  #echo ALPHA=engg > "$JOB_PREVIOUS_STATE/$VAN_PRE_JOB_VER.env"
  cat "$JOB_PREVIOUS_STATE/$VAN_CURR_JOB.env"
    
}

main() {
  set_context
  dockerhub_login
  create_out_state  
}

main

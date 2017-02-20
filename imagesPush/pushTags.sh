#!/bin/bash -e

echo 'test-script for runsh1'     
export CURR_REPO_RESO="scriptami_repo"
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

echo "<===done for reso repo===>"



export VAN_CURR_JOB="push_image_tag"
export VAN_RES_VER="ship_ver"
export VAN_RES_DH="ship_dh"
export VAN_RES_REPO="scriptami_repo"

# since resources here have dashes Shippable replaces them and UPPER cases them
export VAN_RES_VER_UP=$(echo ${VAN_RES_VER//-/} | awk '{print toupper($0)}')

# get dockerhub EN string
export VAN_RES_DH_UP=$(echo $VAN_RES_DH | awk '{print toupper($0)}')
export VAN_RES_DH_INT_STR=$VAN_RES_DH_UP"_INTEGRATION"

# since resources here have dashes Shippable replaces them and UPPER cases them
export VAN_RES_REPO_UP=$(echo $VAN_RES_REPO | awk '{print toupper($0)}')
export VAN_RES_REPO_STATE=$(eval echo "$"$VAN_RES_REPO_UP"_STATE")


set_context() {
  export VAN_VERSION=$(eval echo "$"$VAN_RES_VER_UP"_VERSIONNAME")
  export VAN_DH_USERNAME=$(eval echo "$"$VAN_RES_DH_INT_STR"_USERNAME")
  export VAN_DH_PASSWORD=$(eval echo "$"$VAN_RES_DH_INT_STR"_PASSWORD")
  export VAN_DH_EMAIL=$(eval echo "$"$VAN_RES_DH_INT_STR"_EMAIL")

 # echo "CURR_JOB=$CURR_JOB"
 # echo "RES_VER=$RES_VER"
 # echo "RES_DH=$RES_DH"
  echo "VAN_RES_REPO=$VAN_RES_REPO"
 # echo "RES_VER_UP=$RES_VER_UP"
 # echo "RES_DH_UP=$RES_DH_UP"
 # echo "RES_DH_INT_STR=$RES_DH_INT_STR"
  echo "VAN_RES_REPO_UP=$VAN_RES_REPO_UP"
  echo "VAN_RES_REPO_STATE=$VAN_RES_REPO_STATE"

  echo "VAN_REPO_RESO_VERSION=$VAN_VERSION"
  echo "VAN_DH_USERNAME=$VAN_DH_USERNAME"
  echo "VAN_DH_PASSWORD=${#VAN_DH_PASSWORD}" #show only count
  echo "VAN_DH_EMAIL=$VAN_DH_EMAIL"
}

get_image_list() {
  pushd "$VAN_RES_REPO_STATE/imagesPush"
  export VAN_IMAGE_NAMES=$(cat imgs.txt)
  export VAN_IMAGE_NAMES_SPACED=$(eval echo $(tr '\n' ' ' < imgs.txt))
  popd

  echo "VAN_IMAGE_NAMES=$VAN_IMAGE_NAMES"
  echo "VAN_IMAGE_NAMES_SPACED=$VAN_IMAGE_NAMES_SPACED"

  # create a state file so that next job can pick it up
  echo "versionName=$VAN_REPO_RESO_VERSION" > /build/state/$CURR_JOB.env #adding version state
  echo "VAN_IMAGE_NAMES=$VAN_IMAGE_NAMES_SPACED" >> /build/state/$CURR_JOB.env
}

dockerhub_login() {
  echo "Logging in to Dockerhub"
  echo "----------------------------------------------"
  sudo docker login -u $VAN_DH_USERNAME -p $VAN_DH_PASSWORD -e $VAN_DH_EMAIL
}

pull_tag_push_images() {
  for VAN_IMAGE_NAME in $VAN_IMAGE_NAMES; do
    __pull_tag_push_image $VAN_IMAGE_NAME
  done
}

__pull_tag_push_image() {
  if [[ -z "$1" ]]; then
    return 0
  fi

  VAN_IMAGE_NAME=$1
  VAN_PULL_NAME=$VAN_IMAGE_NAME":tip"
  VAN_PUSH_NAME=$VAN_IMAGE_NAME":"$VAN_VERSION

  echo "pulling image $VAN_PULL_NAME"
  sudo docker pull $VAN_PULL_NAME
  sudo docker tag -f $VAN_PULL_NAME $VAN_PUSH_NAME
  echo "pushing image $VAN_PUSH_NAME"
  sudo docker push $VAN_PUSH_NAME

  # removing the images to save space
  if [ $VAN_IMAGE_NAME!="shippabledocker/sample_ship_nod" -a $VAN_IMAGE_NAME!="shippabledocker/sample_ship_php" \
  -a $VAN_IMAGE_NAME!="shippabledocker/sample_ship_jav" -a $VAN_IMAGE_NAME!="shippabledocker/sample_ship_pyt" ]; then
    echo "Removing image VAN_IMAGE_NAME"
    sudo docker rmi -f $VAN_PUSH_NAME
    sudo docker rmi -f $VAN_PULL_NAME
  fi
}

main() {
  set_context
  get_image_list
  dockerhub_login
  pull_tag_push_images
}

main

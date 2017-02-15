#!/bin/bash -e

#export DOCKERHUB_ORG=drydock

export VAN_CURR_JOB="push_image_tag"
export VAN_RES_VER="ship_ver"
export VAN_RES_DH="ship_dh"
export VAN_RES_REPO="script_repo"

# since resources here have dashes Shippable replaces them and UPPER cases them
export VAN_RES_VER_UP=$(echo ${VAN_RES_VER//-/} | awk '{print toupper($0)}')

# get dockerhub EN string
export VAN_RES_DH_UP=$(echo $RES_DH | awk '{print toupper($0)}')
export VAN_RES_DH_INT_STR=$RES_DH_UP"_INTEGRATION"

# since resources here have dashes Shippable replaces them and UPPER cases them
export VAN_RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export VAN_RES_REPO_STATE=$(eval echo "$"$RES_REPO_UP"_STATE")

set_context() {
  export VAN_VERSION=$(eval echo "$"$VAN_RES_VER_UP"_VERSIONNAME")
  export VAN_DH_USERNAME=$(eval echo "$"VAN_$RES_DH_INT_STR"_USERNAME")
  export VAN_DH_PASSWORD=$(eval echo "$"$VAN_RES_DH_INT_STR"_PASSWORD")
  export VAN_DH_EMAIL=$(eval echo "$"$VAN_RES_DH_INT_STR"_EMAIL")

 # echo "CURR_JOB=$CURR_JOB"
 # echo "RES_VER=$RES_VER"
 # echo "RES_DH=$RES_DH"
 # echo "RES_REPO=$RES_REPO"
 # echo "RES_VER_UP=$RES_VER_UP"
 # echo "RES_DH_UP=$RES_DH_UP"
 # echo "RES_DH_INT_STR=$RES_DH_INT_STR"
 # echo "RES_REPO_UP=$RES_REPO_UP"
  #echo "RES_REPO_STATE=$RES_REPO_STATE"

  echo "VAN_REPO_RESO_VERSION=$VAN_VERSION"
 # echo "DH_USERNAME=$DH_USERNAME"
 # echo "DH_PASSWORD=${#DH_PASSWORD}" #show only count
 # echo "DH_EMAIL=$DH_EMAIL"
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

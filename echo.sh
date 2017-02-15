export RES_REPO=sample-script
export VERSION=v3.0
export KEY_INTEGRATION=rsakey

configure_node_creds() {
  ls IN
  echo "-------------------"
  ls IN/runImageIn
  echo "-------------------"
  #cat IN/runImageIn/version.json

#   ls IN/rsakey
#   cat IN/rsakey/version.json
#   cat IN/rsakey/integration.env
#   cat IN/rsakey/integration.json
  echo "Extracting Key"
  echo "-----------------------------------"
  local creds_path="IN/$KEY_INTEGRATION/integration.env"
  if [ ! -f $creds_path ]; then
    echo "No credentials file found at location: $creds_path"
    return 1
  fi

  export KEY_FILE_PATH="IN/$KEY_INTEGRATION/key.pem"
  cat IN/$KEY_INTEGRATION/integration.json  \
    | jq -r '.privateKey' > $KEY_FILE_PATH
  chmod 600 $KEY_FILE_PATH

  ls -al $KEY_FILE_PATH
  echo "KEY file available at : $KEY_FILE_PATH"
  echo "-----------------------------------"

  ssh-add $KEY_FILE_PATH
  echo "SSH key added successfully"
  echo "--------------------------------------"
}


tag_push(){
  pushd ./IN/$RES_REPO/gitRepo
  echo "pushing git tag $VERSION to $RES_REPO"
  git remote remove origin
  git remote add origin git@github.com:chetantarale/testRepo.git
  git tag $VERSION
  git push origin $VERSION
  #git remote add origin https://chetantarale:xxxxx@github.com/chetantarale/testRepo.git
  #ssh-agent $(ssh-add $KEY_FILE_PATH; git push origin git@github.com:chetantarale/testRepo.git)
  echo "completed pushing git tag $VERSION to $RES_REPO"
  popd
}

configure_node_creds
tag_push

export RES_REPO=sample-script
export VERSION=$(eval echo "$RELJOB_VERSIONNAME") 
export KEY_INTEGRATION=rsakey

configure_node_creds() {
#   ls IN
#   echo "-------------------"
#   ls IN/runimagein
   echo "-------------------"
#   cat IN/runimagein/version.json
#   ls IN/rsakey
#   cat IN/rsakey/version.json
#   cat IN/rsakey/integration.env
#   cat IN/rsakey/integration.json
  printenv
  
#   echo "Extracting Key"
#   echo "-----------------------------------"
#   local creds_path="IN/$KEY_INTEGRATION/integration.env"
#   if [ ! -f $creds_path ]; then
#     echo "No credentials file found at location: $creds_path"
#     return 1
#   fi

#   export KEY_FILE_PATH="IN/$KEY_INTEGRATION/key.pem"
#   cat IN/$KEY_INTEGRATION/integration.json  \
#     | jq -r '.privateKey' > $KEY_FILE_PATH
#   chmod 600 $KEY_FILE_PATH

#   ls -al $KEY_FILE_PATH
#   echo "KEY file available at : $KEY_FILE_PATH"
#   echo "-----------------------------------"
  eval `ssh-agent -s`
  ps -eaf | grep ssh
  which ssh-agent
  #ssh-add $KEY_FILE_PATH
#   echo "SSH key added successfully"
#   echo "--------------------------------------"
}


tag_push(){
  local CURR_SHA=$(jq -r '.version.propertyBag.REPO_COMMIT_SHA' IN/runimagein/version.json)
  echo "---------CURR_SHA----------"
  echo $CURR_SHA
  
  echo "pushing git tag $VERSION to $RES_REPO"
  git clone git@github.com:chetantarale/5134.git
  pushd 5134
  git fetch --tags
  git checkout $CURR_SHA
  git tag $VERSION #-m "pushing tag $VERSION"
  git tag
  git push origin --tags
  #git remote add origin https://chetantarale:xxxxx@github.com/chetantarale/testRepo.git
  #ssh-agent $(ssh-add $KEY_FILE_PATH; git push origin git@github.com:chetantarale/testRepo.git)
  echo "completed pushing git tag $VERSION to $RES_REPO"
  
}

clean_old_tags() {
   CURR_REL_TAG_TIME=$(git for-each-ref --format="%(refname:short) %(authordate:raw)" refs/tags/* | grep $VERSION | awk '{print $2}')
   git for-each-ref --format="%(refname:short) %(authordate:raw)" refs/tags/* | while read line
   do
      CURR_TAG=$(echo $line | awk '{print $1}')
      CURR_TAG_TIMESTAMP=$(echo $line | awk '{print $2}')
      if [[ $CURR_TAG_TIMESTAMP != "" && $CURR_TAG_TIMESTAMP != null && $CURR_TAG_TIMESTAMP -lt $CURR_REL_TAG_TIME ]] ; then
         echo "$CURR_TAG was pushed before $VERSION"
    	else
		   echo "Failed: $CURR_TAG with $CURR_TAG_TIMESTAMP"
      fi
   done
   popd
}
configure_node_creds
tag_push
clean_old_tags

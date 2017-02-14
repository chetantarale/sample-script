export RES_REPO=sample-script
export VERSION=v1.0

set_up() {
  cd IN/sample-script/gitRepo
  ls
  mkdir -p ~/.ssh
  mv IN/sample-script/gitRepo/authorized_keys ~/.ssh/authorized_keys
  ## Paste your public key and save
}

tag_push(){
  pushd ./IN/$RES_REPO/gitRepo
  echo "pushing git tag $VERSION to $RES_REPO"
  #git checkout $(git rev-list -n 1 $REL_VER)
  git tag $VERSION
  git push origin $VERSION
  echo "completed pushing git tag $VERSION to $RES_REPO"
  popd
}
echo "running"
set_up
tag_push

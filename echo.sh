export RES_REPO=sample-script
export VERSION=v1.0.1

set_up() {
  mkdir -p ~/.ssh
  cp IN/sample-script/gitRepo/authorized_keys ~/.ssh/authorized_keys
  ## Paste your public key and save
}

tag_push(){
  pushd ./IN/$RES_REPO/gitRepo
  echo "pushing git tag $VERSION to $RES_REPO"
  #git checkout $(git rev-list -n 1 $REL_VER)
  git remote remove origin
  git remote add origin git@github.com:chetantarale/testRepo.git
  #git remote add origin https://chetantarale:2mm10cs009@github.com/chetantarale/testRepo.git
  git tag $VERSION
  git push origin $VERSION
  echo "completed pushing git tag $VERSION to $RES_REPO"
  popd
}
echo "running"
set_up
tag_push

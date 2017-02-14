export RES_REPO=sample-script
export VERSION=v1.0

set_up() {
  sudo useradd -m -s /usr/bin/git-shell git
  sudo -u git bash
  cd ~
  ## cd /home/git
  mkdir -p .ssh
  mv ./IN/$RES_REPO/gitRepo/authorized_keys .ssh/authorized_keys
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

export RES_REPO=sample-script
export RES_REPO=v1.0


tag_push(){
  pushd ./IN/$RES_BASE_REPO/gitRepo
  echo "pushing git tag $VERSION to $RES_REPO"
  #git checkout $(git rev-list -n 1 $REL_VER)
  git tag $VERSION
  git push origin $VERSION
  echo "completed pushing git tag $VERSION to $RES_BASE_REPO at $REL_VER"
  popd
}
tag_push

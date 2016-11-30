install_node_modules() {
  local build_dir=${1:-}

  export LDFLAGS="-L$build_dir/.heroku/unixodbc/lib"

  if [ -e $build_dir/package.json ]; then
    cd $build_dir

    if [ -e $build_dir/npm-shrinkwrap.json ]; then
      echo "Installing node modules (package.json + shrinkwrap)"
    else
      echo "Installing node modules (package.json)"
    fi
    npm install --unsafe-perm --userconfig $build_dir/.npmrc 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}

rebuild_node_modules() {
  local build_dir=${1:-}

  export C_INCLUDE_PATH="$C_INCLUDE_PATH:$build_dir/.heroku/unixodbc/include"
  export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:$build_dir/.heroku/unixodbc/include"

  if [ -e $build_dir/package.json ]; then
    cd $build_dir
    echo "Rebuilding any native modules"
    npm rebuild --nodedir=$build_dir/.heroku/node 2>&1
    if [ -e $build_dir/npm-shrinkwrap.json ]; then
      echo "Installing any new modules (package.json + shrinkwrap)"
    else
      echo "Installing any new modules (package.json)"
    fi
    env
    npm install --unsafe-perm --userconfig $build_dir/.npmrc 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}

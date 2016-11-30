install_unixodbc() {
  local version="$1"
  local dir="$2"

  local download_url="http://www.unixodbc.org/unixODBC-$version.tar.gz"
  echo "Downloading and installing unixODBC at $download_url"
  curl "$download_url" --silent --fail --retry 5 --retry-max-time 15 -o /tmp/unixodbc.tar.gz || (echo "Unable to download unixODBC" && false)
  tar xzf /tmp/unixodbc.tar.gz -C /tmp
  mkdir -p $dir

  echo "Building unixODBC from source"
  cd /tmp/unixODBC-$version
  ./configure --prefix="$dir"
  make
  make install

  export PATH="$dir/bin:$PATH"
  export LD_LIBRARY_PATH="$dir/lib"
  export LDFLAGS="-L$dir/lib"

  env
}

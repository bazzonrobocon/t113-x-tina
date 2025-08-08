docker build \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  -f Dockerfile.ubuntu \
  -t myubuntu .

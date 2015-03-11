# VERSION 0.1
# DOCKER-VERSION  1.3.2
# AUTHOR:         Paolo Cozzi <paolo.cozzi@tecnoparco.org>
# DESCRIPTION:    Run image in our environment at tecnoparco
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -p 5000:5000 registry

# Get my updated (and fixed) image
FROM paolo/registry:fixed

# This are environment variables to use docker registry
ENV STANDALONE false
ENV MIRROR_SOURCE https://registry-1.docker.io
ENV MIRROR_SOURCE_INDEX https://index.docker.io

# The internal port to expose
EXPOSE 5000

CMD ["docker-registry"]


# VERSION 0.3
# DOCKER-VERSION  1.9.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A Neo4j instance database
# TO_BUILD:       docker build --rm -t ptp/neo4j:3.1 .
# TO_RUN:         docker run -d --publish=17473:17473 --publish=17474:17474 --publish=17687:17687 --name neo4j-taxonomy --env=NEO4J_AUTH=neo4j/password ptp/neo4j:3.1

# Get latest neo4j image
FROM neo4j:3.1

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# Get local configuration file
COPY neo4j.conf /var/lib/neo4j/conf/neo4j.conf

# Ovveride the default entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Ports to expose outside
EXPOSE 17473 17474 17687

# Using default entrypoint, and a custom command
CMD ["bin/neo4j", "console"]

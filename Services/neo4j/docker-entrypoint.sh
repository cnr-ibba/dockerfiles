#!/bin/bash -eu

# evel environment variables
if [ "${NEO4J_AUTH:-}" == "none" ]; then
    setting "dbms.security.auth_enabled" "false"
elif [[ "${NEO4J_AUTH:-}" == neo4j/* ]]; then
    password="${NEO4J_AUTH#neo4j/}"
    if [ "${password}" == "neo4j" ]; then
        echo "Invalid value for password. It cannot be 'neo4j', which is the default."
        exit 1
    fi
    bin/neo4j-admin set-initial-password "${password}"
elif [ -n "${NEO4J_AUTH:-}" ]; then
    echo "Invalid value for NEO4J_AUTH: '${NEO4J_AUTH}'"
    exit 1
fi

# Calling CMD
exec "$@"

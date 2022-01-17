#!/bin/bash

# Set paths to "Schwab demo" configuration folders and files
SCHWAB_DEMO_HOME=/mnt/c/clients/Schwab/demo
SCHWAB_DEMO_DOCKERFILE=${SCHWAB_DEMO_HOME}/build/Dockerfile.java-client
SCHWAB_DEMO_JAVA_BUILD_CONTEXT_FOLDER=${SCHWAB_DEMO_HOME}/ggnode

# Set build context to "demo" java project folder and export env variables.
source ${SCHWAB_DEMO_HOME}/build/schwab-demo-export-java.sh

# Postion current directory to the IntelliJ project folder to use as the context folder to build the docker image.
cd ${SCHWAB_DEMO_JAVA_BUILD_CONTEXT_FOLDER}

# Display build context and env variables (for debugging/verification purposes)
echo -e "\nUsing docker file: ${SCHWAB_DEMO_DOCKERFILE}"
echo -e "Build docker image: schwab-java-server in folder: ${PWD}"
echo "With environment variable settings:"
echo "     SCHWAB_DEMO_GG_CONFIGS_PATH: ${SCHWAB_DEMO_GG_CONFIGS_PATH}"
echo -e "     SCHWAB_DEMO_GG_JVMCLASSPATH: ${SCHWAB_DEMO_GG_JVMCLASSPATH}\n"

# Build the docker image: schwab-java-server:latest
docker build -f ${SCHWAB_DEMO_DOCKERFILE} -t sdemo-java-client:latest .
# docker build -f ${SCHWAB_DEMO_DOCKERFILE} --progress plain --no-cache -t sdemo-java-client:latest .

docker tag schwab-java-client:latest dgneubert/sdemo-java-client:latest
docker push dgneubert/sdemo-java-client:latest

# Run the docker image to test it.
echo -e "\nRun local docker image: sdemo-java-client\n"
docker run -it -e CONFIG_URI=/app/config/client-config.xml --rm --network host sdemo-java-client
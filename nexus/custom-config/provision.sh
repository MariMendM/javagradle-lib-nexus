#!/bin/bash

# A simple example script that publishes a number of scripts to the Nexus Repository Manager
# and executes them.

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

username=admin
password=admin123

# add the context if you are not using the root context
host=http://localhost:8081

#add a script to the repository manager and run it

function addAndRunScript {
  name=$1
  file=$2
  # using grape config that points to local Maven repo and Central Repository , default grape config fails on some downloads although artifacts are in Central
  # change the grapeConfig file to point to your repository manager, if you are already running one in your organization
  groovy -Dgroovy.grape.report.downloads=true -Dgrape.config=grapeConfig.xml addUpdateScript.groovy -u "$username" -p "$password" -n "$name" -f "$file" -h "$host"
  printf "\nPublished $file as $name\n\n"
  curl -v -X POST -u $username:$password --header "Content-Type: text/plain" "$host/service/rest/v1/script/$name/run"
  printf "\nSuccessfully executed $name script\n\n\n"
}

printf "Provisioning Integration API Scripts Starting \n\n"
printf "Publishing and executing on $host\n"


#Running corresponding script to perform tasks below
addAndRunScript addRole addRole.groovy
printf "addRole ok"
addAndRunScript raw rawRepositories.groovy
printf "rawRepositories ok"
addAndRunScript security security.groovy
printf "security ok"
addAndRunScript docker dockerRepositories.groovy
printf "dockerRepositories ok"
#addAndRunScript delete deleteAllRepositoryConfig.groovy

printf "\nProvisioning Scripts Completed\n\n"
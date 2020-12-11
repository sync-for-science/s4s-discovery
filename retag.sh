#!/bin/bash

docker tag s4s-discovery_web:latest 272207098939.dkr.ecr.us-east-2.amazonaws.com/s4s-discovery/web:latest

docker tag s4s-discovery_procure-wip:latest 272207098939.dkr.ecr.us-east-2.amazonaws.com/s4s-discovery/procure-wip:latest


docker tag s4s-discovery_data-server:latest 272207098939.dkr.ecr.us-east-2.amazonaws.com/s4s-discovery/data-server:latest

docker tag s4s-discovery_fhir-data-dstu2:latest 272207098939.dkr.ecr.us-east-2.amazonaws.com/s4s-discovery/fhir-data-dstu2:latest
docker tag s4s-discovery_fhir-data-dstu3:latest 272207098939.dkr.ecr.us-east-2.amazonaws.com/s4s-discovery/fhir-data-dstu3:latest

#!/bin/bash

docker build --build-arg 
  \ DATA_HOST=aaccdf7459ce842799e4615ad4920589-278800391.us-east-2.elb.amazonaws.com:8081
  \ -t 272207098939.dkr.ecr.us-east-2.amazonaws.com/s4s-discovery/web:latest . --target=production

  
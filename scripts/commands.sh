#!/bin/bash

start_env() {
  echo -e "\e[1;32msetting up the python environment for the project\e[0m"
  python3 -m venv ~/.v-python &2> /dev/null
  . ~/.v-python/bin/activate

  echo -e "\e[1;32mcloning the Demo Repository...\e[0m"
  cd ~/
  git clone https://github.com/Pet-slack/udacity-cicd-demo.git
  sleep 2
  echo -e "\e[1;32mRunning the DEMO Project locally...\e[0m"
  cd ~/udacity-cicd-demo
  make all

  echo -e "\e[1;32mCreating the AZURE Web Service instance...\e[0m"
  az webapp up --name ml-webapp-001 --sku F1 --location eastus --resource-group udacity-demo-rg
  echo -e "\e[1;33mWaiting for the Web Service to come up...\e[0m"
  sleep 30
  az webapp log tail --name ml-webapp-001 --resource-group udacity-demo-rg
}

stop_env() {
  echo -e "\e[1;32mStopping the Azure Web Service...\e[0m"
  az webapp stop --name ml-webapp-001 --resource-group udacity-demo-rg
}

rm_all() {
  echo -e "\e[1;31mDeleting all the Demo resources...\e[0m"
  az group delete --name udacity-demo-rg -y --no-wait
}

case "$1" in
  start)
    start_env
    ;;

  stop)
    stop_env
    ;;

  delete)
    rm_all
    ;;

  *)
    echo "Usage: $0 <start|stop|delete>"
    ;;

esac

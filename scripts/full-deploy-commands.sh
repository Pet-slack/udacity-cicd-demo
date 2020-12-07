#!/bin/bash
## Default env variables (CHANGE-IT ACCORDING YOUR ENVIRONMENT)
GIT_URL="https://github.com/Pet-slack/udacity-cicd-demo.git"
APP_NAME="ml-webapp-001"
RES_GRP="udacity-demo-rg"
LOC="eastus"

activate () {
  . ~/.v-python/bin/activate
}

start_env() {
  echo -e "\e[1;32msetting up the python environment for the project\e[0m"
  python3 -m venv ~/.v-python
  activate

  echo -e "\e[1;32mcloning the Demo Repository...\e[0m"
  cd ~/
  git clone $GIT_URL
  sleep 3
  cd ~/udacity-cicd-demo
  echo -e "\e[1;32mRunning the DEMO Project locally...\e[0m"
  make all
}

deploy_env() {
  if [ ! -d ~/udacity-cicd-demo ]; then
    echo -e "\e[1;31mWorking project directory doesn´t exist. Please run the start first...BYE.\e[0m"
    exit 1
  else
    activate
    cd ~/udacity-cicd-demo
    echo -e "\e[1;32mCreating the AZURE Web Service instance...\e[0m"
    az webapp up --name $APP_NAME --sku F1 --location $LOC --resource-group $RES_GRP
    echo -e "\e[1;33mWaiting for the Web Service to come up...\e[0m"
    sleep 30
    az webapp log tail --name $APP_NAME --resource-group $RES_GRP
  fi
}

stop_env() {
  echo -e "\e[1;32mStopping the Azure Web Service...\e[0m"
  az webapp stop --name $APP_NAME --resource-group $RES_GRP
}

rm_all() {
  echo -e "\e[1;31mDeleting all the Demo resources...\e[0m"
  az group delete --name $RES_GRP -y --no-wait
  rm -rf ~/.v-python
}

case "$1" in
  start)
    start_env
    ;;

  deploy)
    deploy_env
    ;;

  stop)
    stop_env
    ;;

  delete)
    rm_all
    ;;

  *)
    echo "Usage: $0 <start|deploy|stop|delete>"
    ;;

esac

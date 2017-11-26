#!/bin/bash
shopt -s nullglob

DATABASE_CMD="ansible-playbook database.yml -e cmd=$1 -e env=$2 -e site=$3"
ENVIRONMENTS=( hosts/* )
ENVIRONMENTS=( "${ENVIRONMENTS[@]##*/}" )
NUM_ARGS=3

show_usage() {
  echo "Usage: ./database.sh <action> <environment> <site name>

<action> is the sync mode ("push", "pull", "backup")
<environment> is the environment to sync database ("staging", "production", etc)
<site name> is the WordPress site to sync database (name defined in "wordpress_sites")

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Example:
  ./bin/database.sh push staging example.com
"
}

HOSTS_FILE="hosts/$2"

[[ $# -ne $NUM_ARGS || $2 = -h ]] && { show_usage; exit 0; }

if [[ ! -e $HOSTS_FILE ]]; then
  echo "Error: $2 is not a valid environment ($HOSTS_FILE does not exist)."
  echo
  echo "Available environments:"
  ( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )
  exit 0
fi

case $3 in
  push)
    $DATABASE_PUSH_CMD
  ;;
  pull)
    $DATABASE_PULL_CMD
  ;;
  backup)
    $DATABASE_BACKUP_CMD
  ;;
  *)
    show_usage
  ;;
esac

#!/bin/bash
shopt -s nullglob

UPLOADS_CMD="ansible-playbook uploads.yml -e mode=$1 -e env=$2 -e site=$3"
ENVIRONMENTS=( hosts/* )
ENVIRONMENTS=( "${ENVIRONMENTS[@]##*/}" )
NUM_ARGS=3

show_usage() {
  echo "Usage: ./uploads.sh <action> <environment> <site name>

<action> is the sync mode ("push", "pull")
<environment> is the environment to sync uploads ("staging", "production", etc)
<site name> is the WordPress site to sync uploads (name defined in "wordpress_sites")

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Examples:
  ./bin/uploads.sh pull staging example.com
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

echo -e -n "Are you sure? (Y/n) "
read -n 1 answer
echo " "
if [ "$answer" == "Y" ]; then
  $UPLOADS_CMD
else
  echo "Operation aborted."
fi

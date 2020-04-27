#!/bin/sh

usage()
{
   echo ""
   echo "Usage: $0 -n project-name -o project-owner -p port -t [init|update]"
   echo "\t-n project name"
   echo "\t-o project owner"
   echo "\t-p port"
   echo "\t-t init or update"
   exit 1
}

while getopts "n:o:p:t:" opt
do
   case "$opt" in
      n ) name="$OPTARG" ;;
      o ) owner="$OPTARG" ;;
      p ) port="$OPTARG" ;;
      t ) action="$OPTARG" ;;
      ? ) usage ;;
   esac
done

# Print usage in case parameters are empty
if [ -z "$name" ] || [ -z "$owner" ] || [ -z "$port" ] || [ -z "$action" ]
then
   echo "Invalid options";
   usage
fi

# Begin script in case all parameters are correct
echo "$name"
echo "$owner"
echo "$port"
echo "$action"

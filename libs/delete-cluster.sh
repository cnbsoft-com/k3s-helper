#!/bin/bash
set -e
# set -x

## Global Definitions Start ##
CMD="multipass"
## Global Definitions End ##

print_and_select_cluster() {
  # echo "--------------------------------------------------------------------------------------------"
  # echo -e "No\t$($CMD ls | head -n 1)"
  # echo "--------------------------------------------------------------------------------------------"
  # idx=1
  # while IFS= read -r line; do
  #   echo -e "${idx}\t${line}"
  #   idx=$((idx+1))
  # done < <($CMD ls | grep -E "^[a-zA-Z0-9_-]+-master\s")
  # if [ $idx -gt 1 ]; then
  #   echo "--------------------------------------------------------------------------------------------"
  #   read -p "Type number to delete cluster : " selected_cluster
  # else
  #   echo "No cluster found"
  #   echo "--------------------------------------------------------------------------------------------"
  #   exit 1
  # fi
  PS3="
👉 Select cluster to delete: "
echo "--------------------------------------------------------------------------------------------"
echo -e "No $($CMD ls | head -n 1)"
echo "--------------------------------------------------------------------------------------------"
  select choice in "$(multipass ls | grep -E "^[a-zA-Z0-9_-]+-master\s")"; do
    if [ -n "$choice" ]; then
      selected_cluster=$(sed -e "s/-master//g" <<< $choice)
      break
    else
      echo "⚠️  Invalid selection. Please enter a number from the list above."
    fi
  done
}

confirm_delete_cluster() {
  read -p "You will now delete '${selected_cluster}' cluster. This action can't be undone. [Y/n]: " isApply
  if [[ -z $isApply || "Y" == $isApply ]]; then
    # multipass delete ${selected_cluster}-master
    # multipass purge
    echo "${selected_cluster} deleted"
  fi
}


main() {
  print_and_select_cluster
  confirm_delete_cluster
}

main
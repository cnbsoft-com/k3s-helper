#!/bin/bash


cluster_list=()
selected_cluster=""
select_cluster_list() {
  cluster_list=$(multipass ls | grep master | awk '{print$1}')
  echo "--------------------------------"
  echo "Cluster name"
  echo "--------------------------------"
  PS3="
👉 Select cluster : "
  select choice in "${cluster_list[@]}"; do
    if [ -n "$choice" ]; then
      selected_cluster=$(sed -e "s/-master//g" <<< $choice)
      break
    else
      echo "⚠️  Invalid selection. Please enter a number from the list above."
    fi
  done

  echo "selected cluster is ${selected_cluster}"
}

selected_worker_list=()
selected_worker=""
select_worker_list() {
  selected_worker_list=$(multipass ls | grep "${selected_cluster}-worker" | awk '{print$1}')
  echo "--------------------------------------------------------------------------------------------"
  echo "Worker name(Type number seperated by space to select workers)"
  echo "--------------------------------------------------------------------------------------------"

  idx=1
  available_worker_list=()
  for i in ${selected_worker_list[@]}; do
    echo "${idx}) ${i}"
    idx=$((idx+1))
    available_worker_list+=(${i})
  done

  read -p "Select worker : " selected_worker

  validate_selected_worker
}

will_delete_worker_list=()
validate_selected_worker() {
  if [[ -z $selected_worker ]]; then
    echo "Error: No worker selected"
    exit 1
  else
    echo "selected worker is ${selected_worker}"
    for i in ${selected_worker}; do
      if [[ "${available_worker_list[@]}" != *"${i}"* ]]; then
        echo "Error: ${selected_cluster}-worker${i} not found"
      elif [[ -n $i ]]; then
        will_delete_worker_list+=(${i})
      fi
    done
  fi
}

delete_worker() {
  for i in ${will_delete_worker_list[@]}; do
    echo "${selected_cluster}-worker${i} will be deleted"
    read -p "Delete ${selected_cluster}-worker${i}? It is not recoverable [Y/n]: " isApply
    if [[ -z $isApply || "Y" == $isApply ]]; then
      multipass delete ${selected_cluster}-worker${i}
      multipass purge
      echo "${selected_cluster}-worker${i} deleted"
    fi
  done
}

main() {
  select_cluster_list
  select_worker_list
  delete_worker
}

main

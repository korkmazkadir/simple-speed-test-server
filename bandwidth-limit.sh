#!/bin/bash


function throttle()
{

   process_index=$1
   pid=$2

   echo "creating cgroup. Process pid is $pid process index is $process_index"

   printf -v gminor "%04x" "$process_index"
   

   group_name_suffix="algorand_${process_index}"

   # Create a net_cls cgroup
   group_name="net_cls:${group_name_suffix}"
   sudo cgcreate -g "${group_name}"

   # Set the class id for the cgroup
   # By default gmajor is 1
   echo_cmd="echo 0x1${gminor} > /sys/fs/cgroup/net_cls/${group_name_suffix}/net_cls.classid"
   sudo sh -c  "${echo_cmd}"

   # Classify packets from pid into cgroup
   sudo cgclassify -g "${group_name}" "${pid}"

   # By default gmajor is 1
   #printf -v class_id "1:%d" "$process_index"
   printf -v class_id "1:%x" "$process_index"

   # Rate limit packets in cgroup class
   #tc qdisc add dev eno1 root handle 1: htb
   #sudo tc filter add dev eno1 parent 1: handle 1: cgroup
 
   sudo tc class add dev $nic parent 1: classid "${class_id}" htb rate 20mbit
}

#Delete previous control groups
sudo cgdelete -r net_cls:/

#Defines network interface to apply tc rules
nic="eno1"

#Delete previous tc rules
sudo tc qdisc del dev $nic root


#Adds root qdisc
sudo tc qdisc add dev $nic root handle 1: htb
sudo tc filter add dev $nic parent 1: handle 1: cgroup


# tc -s -d class show dev lo
# tc -s -d class show dev eno1

#for (( i=1; i<=$number_of_nodes; i++ ))
#do  

echo "creating wget process"
   

for (( i=1; i<=25; i++ ))
do 

	./simple-speed-test-server >> process.out &
	process_pid=$!

	echo "pid of the wget process: $process_pid"
	throttle $i $process_pid

done

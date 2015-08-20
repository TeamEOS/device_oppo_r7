#!/system/bin/sh
#VENDEDIT 
# yonggao.jiang@MultiMedia  10/26/2014  ADD FOR POWER CONTROL

	power_ctrl_interval=`getprop persist.sys.power_ctrl.interval`
	power_ctrl_off_cores=`getprop persist.sys.power_ctrl.off_cores`
	power_ctrl_on_threshold=`getprop persist.sys.power_ctrl.on_threshold`
	power_ctrl_off_threshold=`getprop persist.sys.power_ctrl.off_threshold`
	power_ctrl_ctrl_gpu=`getprop persist.sys.power_ctrl.ctrl_gpu`
	power_ctrl_ctrl_gpu_low_max_freq=`getprop persist.sys.power_ctrl.gpu_low_max_freq`
	power_ctrl_ctrl_gpu_high_max_freq=`getprop persist.sys.power_ctrl.gpu_high_max_freq`
	power_ctrl_log=`getprop persist.sys.power_ctrl.log`
	
	if [ "$power_ctrl_interval" == "" ]; then
		power_ctrl_interval=1
	fi
	
	if [ "$power_ctrl_off_cores" == "" ]; then	
	   power_ctrl_off_cores=12
	fi
	
	if [ "$power_ctrl_on_threshold" == "" ]; then
	        power_ctrl_on_threshold=1344000
	fi
	
	if [ "$power_ctrl_off_threshold" == "" ]; then
	        power_ctrl_off_threshold=1344000
	fi
	
	if [ "$power_ctrl_ctrl_gpu" == "" ]; then
         power_ctrl_ctrl_gpu=true
  fi
  
	if [ "$power_ctrl_ctrl_gpu_low_max_freq" == "" ]; then
      power_ctrl_ctrl_gpu_low_max_freq=400000000
  fi
  
	if [ "$power_ctrl_ctrl_gpu_high_max_freq" == "" ]; then
      power_ctrl_ctrl_gpu_high_max_freq=550000000
  fi
  
	if [ "$power_ctrl_log" == "" ]; then	
		power_ctrl_log=/dev/null
  fi

  echo "#### multi-core power control enabled ####"

#	stop thermal-engine

	echo $power_ctrl_off_cores > /sys/module/msm_thermal/core_control/cpus_offlined
	state=0
	
	while true; do
		cat /sys/power/wake_lock | grep PowerManagerService.Display
		if [ $? == 0 ]; then
			sleep $power_ctrl_interval
			cpu0_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
     
			if [ "$cpu0_freq" -gt "$power_ctrl_on_threshold" ]; then
				if [ $state == 0 ]; then
					echo 0 > /sys/module/msm_thermal/core_control/cpus_offlined
					state=1
				fi
			else
				if [ $state == 1 ]; then
					echo "$power_ctrl_off_cores" > /sys/module/msm_thermal/core_control/cpus_offlined
					state=0
				fi
			fi
		else
			if [ $state == 1 ]; then
				echo "$power_ctrl_off_cores" > /sys/module/msm_thermal/core_control/cpus_offlined
				state=0
			fi
			sleep 5
		fi
	done

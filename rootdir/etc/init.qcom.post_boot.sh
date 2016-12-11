#!/system/bin/sh
# Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`
case "$target" in
    "msm8916")
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case "$soc_id" in
           "239")
		echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
		echo 10 > /sys/class/net/rmnet0/queues/rx-0/rps_cpus
	    ;;
       esac
    ;;
esac

case "$target" in
    "msm8916")

        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

        # HMP scheduler settings for 8916, 8936, 8939, 8929
        echo 3 > /proc/sys/kernel/sched_window_stats_policy

        # Apply governor settings for 8916
	# Apply governor settings for 8936

        # Apply governor settings for 8939
        case "$soc_id" in
            "239")
                # HMP scheduler load tracking settings
                echo 5 > /proc/sys/kernel/sched_ravg_hist_size
                # HMP Task packing settings for 8939, 8929
                echo 20 > /proc/sys/kernel/sched_small_task
                echo 30 > /proc/sys/kernel/sched_mostly_idle_load
                echo 4 > /proc/sys/kernel/sched_mostly_idle_nr_run
		for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
		do
			 echo "bw_hwmon" > $devfreq_gov
                         for cpu_io_percent in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent
                         do
                                echo 20 > $cpu_io_percent
                         done
		done
		for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
		do
			 echo 40 > $gpu_bimc_io_percent
		done
		# disable thermal core_control to update interactive gov settings
                echo 0 > /sys/module/msm_thermal/core_control/enabled
                # enable governor for perf cluster
                echo 1 > /sys/devices/system/cpu/cpu0/online
                echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
				# above_hispeed_delay - время анализа нагрузки на любой частоте cвыше установленной в hispeed_freq;
                echo "20000 1113600:39000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
                # go_hispeed_load - загрузка процессора, при которой частота устанавливается равной hispeed_freq;
				echo 98 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
  				# timer_rate - время анализа нагрузки на любой в данный момент частоте (показатель, используемый для повышения частоты (чем меньше, тем выше производительность и хуже энергоэффективность));
				echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
				# hispeed_freq - промежуточная частота, на которую говернор будет переводить процессор, если нагрузка превышает go_hispeed_load. Если нагрузка остается высокой в течении времени > above_hispeed_delay, частота может быть увеличина;
                echo 1113600 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
				# target_loads - значения загрузки центрального процессора (в %), по достижении которой, говернор повышает тактовую частоту;
                echo 90 /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
				# min_sample_time - минимальный интервал времени ожидания на любой частоте, прежде чем перевести CPU на более низкую частоту;
                echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
				# sampling_down_factor - определяет, как часто процессор должен находится на повышенной частоте, когда действительно имеет какую-либо нагрузку. Стандартная задача – быстро понижать частоту. Высокое значение увеличивает производительность, позволяя процессору дольше находится на максимальной частоте при реальной нагрузке на него, нежели понижая частоту при небольшом спадении нагрузки (допустим, смена динамичной сцены на спокойную в игре).
                echo 30000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/sampling_down_factor
                echo 200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
                # enable governor for power cluster
                echo 1 > /sys/devices/system/cpu/cpu4/online
                echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
				# above_hispeed_delay - время анализа нагрузки на любой частоте cвыше установленной в hispeed_freq;
                echo "20000 800000:30000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
                # go_hispeed_load - загрузка процессора, при которой частота устанавливается равной hispeed_freq;
                echo 90 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
				# timer_rate - время анализа нагрузки на любой в данный момент частоте (показатель, используемый для повышения частоты (чем меньше, тем выше производительность и хуже энергоэффективность));
                echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
				# hispeed_freq - промежуточная частота, на которую говернор будет переводить процессор, если нагрузка превышает go_hispeed_load. Если нагрузка остается высокой в течении времени > above_hispeed_delay, частота может быть увеличина;
                echo 998400 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
                echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
				# target_loads - значения загрузки центрального процессора (в %), по достижении которой, говернор повышает тактовую частоту;
                echo 80 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
				# min_sample_time - минимальный интервал времени ожидания на любой частоте, прежде чем перевести CPU на более низкую частоту;
                echo 30000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
				# sampling_down_factor - определяет, как часто процессор должен находится на повышенной частоте, когда действительно имеет какую-либо нагрузку. Стандартная задача – быстро понижать частоту. Высокое значение увеличивает производительность, позволяя процессору дольше находится на максимальной частоте при реальной нагрузке на него, нежели понижая частоту при небольшом спадении нагрузки (допустим, смена динамичной сцены на спокойную в игре).
                echo 35000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/sampling_down_factor
                echo 249000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
                # enable thermal core_control now
		echo 1 > /sys/module/msm_thermal/core_control/enabled
		sleep 3
		echo 0 > /sys/module/msm_thermal/core_control/enabled
		echo 1113600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
		echo 1 > /sys/module/msm_thermal/core_control/enabled
                # Bring up all cores online
				echo 1 > /sys/devices/system/cpu/cpu1/online
				echo 1 > /sys/devices/system/cpu/cpu2/online
				echo 1 > /sys/devices/system/cpu/cpu3/online
				echo 1 > /sys/devices/system/cpu/cpu4/online
                echo 1 > /sys/devices/system/cpu/cpu5/online
                echo 1 > /sys/devices/system/cpu/cpu6/online
                echo 1 > /sys/devices/system/cpu/cpu7/online
				
				# Enable low power modes
                echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
				echo 50 > /proc/sys/kernel/sched_spill_load
				echo 5 > /proc/sys/kernel/sched_spill_nr_run
				echo 10 > /proc/sys/kernel/sched_upmigrate_min_nice

                # HMP scheduler (big.Little cluster related) settings
                echo 98 > /proc/sys/kernel/sched_upmigrate
                echo 85 > /proc/sys/kernel/sched_downmigrate
                sleep 3
                # echo 0xffffffff to cpu scaling_max_freq, it will fall back to max available freq
                echo 0 > /sys/module/msm_thermal/core_control/enabled
                echo 1344000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
                echo 1113600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
                echo 1 > /sys/module/msm_thermal/core_control/enabled
                # cpu idle load threshold
                echo 40 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_load
                echo 50 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_load
                echo 50 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_load
                echo 50 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_load
                echo 30 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_load
            ;;
        esac
    ;;
esac

chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy

emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac

# Post-setup services
case "$target" in
    "msm8916")
        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case $soc_id in
            "239")
            setprop ro.min_freq_0 200000
            setprop ro.min_freq_4 249000
        ;;
        esac
        #start perfd after setprop
        start perfd # start perfd on 8916, 8939 and 8929
    ;;
esac

# Change adj level and min_free_kbytes setting for lowmemory killer to kick in
case "$target" in
    "msm8916")
        # Let kernel know our image version/variant/crm_version
        image_version="10:"
        image_version+=`getprop ro.build.id`
        image_version+=":"
        image_version+=`getprop ro.build.version.incremental`
        image_variant=`getprop ro.product.name`
        image_variant+="-"
        image_variant+=`getprop ro.build.type`
        oem_version=`getprop ro.build.version.codename`
        echo 10 > /sys/devices/soc0/select_image
        echo $image_version > /sys/devices/soc0/image_version
        echo $image_variant > /sys/devices/soc0/image_variant
        echo $oem_version > /sys/devices/soc0/image_crm_version
        ;;
esac

# Create native cgroup and move all tasks to it. Allot 15% real-time
# bandwidth limit to native cgroup (which is what remains after
# Android uses up 80% real-time bandwidth limit). root cgroup should
# become empty after all tasks are moved to native cgroup.

CGROUP_ROOT=/dev/cpuctl
mkdir $CGROUP_ROOT/native
echo 150000 > $CGROUP_ROOT/native/cpu.rt_runtime_us

# We could be racing with task creation, as a result of which its possible that
# we may fail to move all tasks from root cgroup to native cgroup in one shot.
# Retry few times before giving up.

for loop_count in 1 2 3
do
	for i in $(cat $CGROUP_ROOT/tasks)
	do
		echo $i > $CGROUP_ROOT/native/tasks
	done

	root_tasks=$(cat $CGROUP_ROOT/tasks)
	if [ -z "$root_tasks" ]
	then
		break
	fi
done

# Check if we failed to move all tasks from root cgroup
if [ ! -z "$root_tasks" ]
then
	echo "Error: Could not move all tasks to native cgroup"
fi

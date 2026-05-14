#!/bin/bash

get_cpu_temp() {
    # Find coretemp hwmon path
    HWMON_PATH=$(grep -l "coretemp" /sys/class/hwmon/hwmon*/name | head -n 1 | xargs -r dirname)

    if [ -z "$HWMON_PATH" ]; then
        echo "{\"text\": \" N/A\", \"tooltip\": \"Coretemp sensor not found\"}"
        return
    fi

    # Find the label file for "Package id 0"
    LABEL_FILE=$(grep -l "Package id 0" "$HWMON_PATH"/temp*_label | head -n 1)

    if [ -n "$LABEL_FILE" ]; then
        # Construct input file path (replace _label with _input)
        INPUT_FILE="${LABEL_FILE/_label/_input}"
        
        if [ -f "$INPUT_FILE" ]; then
            TEMP_MILLI=$(cat "$INPUT_FILE")
            TEMP_C=$((TEMP_MILLI / 1000))
            
            # Determine icon based on temp
            if [ "$TEMP_C" -ge 80 ]; then
                ICON="" # Critical
            elif [ "$TEMP_C" -ge 60 ]; then
                ICON="" # High
            else
                ICON="" # Normal
            fi

            echo "{\"text\": \"$ICON $TEMP_C°C\", \"tooltip\": \"CPU Package Temp\nSensor: $INPUT_FILE\", \"class\": \"custom-cpu-temp\", \"percentage\": $TEMP_C}"
        else
            echo "{\"text\": \" Err\", \"tooltip\": \"Input file not found: $INPUT_FILE\"}"
        fi
    else
        # Fallback to temp1_input if label not found
        FALLBACK="$HWMON_PATH/temp1_input"
        if [ -f "$FALLBACK" ]; then
            TEMP_MILLI=$(cat "$FALLBACK")
            TEMP_C=$((TEMP_MILLI / 1000))
            echo "{\"text\": \" $TEMP_C°C\", \"tooltip\": \"CPU Temp (Fallback)\nSensor: $FALLBACK\", \"class\": \"custom-cpu-temp\"}"
        else
            echo "{\"text\": \" N/A\", \"tooltip\": \"No suitable sensor found\"}"
        fi
    fi
}

get_ram_temp() {
    # Find all spd5118 hwmon paths
    HWMON_PATHS=$(grep -l "spd5118" /sys/class/hwmon/hwmon*/name | xargs -r dirname)

    if [ -z "$HWMON_PATHS" ]; then
        echo "{\"text\": \" N/A\", \"tooltip\": \"SPD5118 sensors not found\"}"
        return
    fi

    MAX_TEMP=0
    TOOLTIP="RAM Temperatures:"

    for path in $HWMON_PATHS; do
        if [ -f "$path/temp1_input" ]; then
            TEMP_MILLI=$(cat "$path/temp1_input")
            TEMP_C=$((TEMP_MILLI / 1000))
            TOOLTIP="$TOOLTIP\nSensor $(basename "$path"): ${TEMP_C}°C"
            if [ "$TEMP_C" -gt "$MAX_TEMP" ]; then
                MAX_TEMP=$TEMP_C
            fi
        fi
    done

    if [ "$MAX_TEMP" -eq 0 ]; then
        echo "{\"text\": \" N/A\", \"tooltip\": \"No temperature data found\"}"
        return
    fi

    # Determine icon based on temp
    if [ "$MAX_TEMP" -ge 60 ]; then
        ICON="" # Critical/High for RAM
    elif [ "$MAX_TEMP" -ge 50 ]; then
        ICON="" # Warm
    else
        ICON="" # Normal
    fi

    echo "{\"text\": \"$ICON $MAX_TEMP°C\", \"tooltip\": \"$TOOLTIP\", \"class\": \"custom-ram-temp\", \"percentage\": $MAX_TEMP}"
}

get_load() {
    read -r LOAD_1 LOAD_5 LOAD_15 _ < /proc/loadavg
    CORES=$(nproc)
    PERCENT=$(awk -v loadavg="$LOAD_1" -v cores="$CORES" 'BEGIN { printf "%d", (loadavg / cores) * 100 }')

    echo "{\"text\": \"󰓅 $LOAD_1\", \"tooltip\": \"Load average: $LOAD_1, $LOAD_5, $LOAD_15\nCPU threads: $CORES\", \"class\": \"custom-load\", \"percentage\": $PERCENT}"
}

get_disk() {
    # Disk Usage for /
    USAGE=$(df -h / | tail -1 | awk '{print $3 " / " $2}')

    # Find all NVMe sensors using sensors command
    NVME_DEVICES=$(sensors 2>/dev/null | grep "nvme-pci-" | cut -d'-' -f3)
    
    MAX_TEMP=0
    TOOLTIP_TEXT="Disk Usage: $USAGE"
    
    for dev in $NVME_DEVICES; do
        SENSOR_NAME="nvme-pci-$dev"
        TEMP=$(sensors "$SENSOR_NAME" 2>/dev/null | grep "Composite" | awk '{print $2}' | cut -d. -f1 | cut -c2-)
        
        if [ -n "$TEMP" ]; then
            if [ "$TEMP" -gt "$MAX_TEMP" ]; then
                MAX_TEMP=$TEMP
            fi
            TOOLTIP_TEXT="$TOOLTIP_TEXT\n$SENSOR_NAME: ${TEMP}°C"
        fi
    done

    if [ "$MAX_TEMP" -eq 0 ]; then
        TEMP_TEXT="N/A"
    else
        TEMP_TEXT="${MAX_TEMP}°C"
    fi

    echo "{\"text\": \" $USAGE   $TEMP_TEXT\", \"tooltip\": \"$TOOLTIP_TEXT\", \"class\": \"custom-disk\"}"
}

case "$1" in
    "cpu")
        get_cpu_temp
        ;;
    "ram")
        get_ram_temp
        ;;
    "load")
        get_load
        ;;
    "disk")
        get_disk
        ;;
    *)
        echo "Usage: $0 {cpu|ram|load|disk}"
        exit 1
        ;;
esac

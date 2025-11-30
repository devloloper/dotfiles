#!/bin/bash
# Fan 7 (High RPM) likely CPU
FAN_CPU=$(sensors nct6798-isa-0290 | grep "fan7" | awk '{print $2}')
# Fan 2 (Low RPM) likely Case/Chassis
FAN_CASE=$(sensors nct6798-isa-0290 | grep "fan2" | awk '{print $2}')

echo "{\"text\": \"󰈐 $FAN_CPU RPM\", \"tooltip\": \"CPU Fan: $FAN_CPU RPM\nCase Fan: $FAN_CASE RPM\", \"class\": \"custom-fans\"}"

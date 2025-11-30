#!/bin/bash

# Extract "power total" from sensors output for corsairpsu
# Output format: power total: 370.00 W
PSU_WATTS=$(sensors corsairpsu-hid-3-6 | grep "power total" | awk '{print $3}' | cut -d. -f1)

# Get GPU power
GPU_WATTS=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | awk '{print $1}' | cut -d. -f1)

# Ensure values are set (default to 0 if empty)
PSU_WATTS=${PSU_WATTS:-0}
GPU_WATTS=${GPU_WATTS:-0}

# Format with fixed width (3 chars) to prevent jitter
# Using printf to pad with spaces on the left
GPU_FMT=$(printf "%3s" "$GPU_WATTS")
PSU_FMT=$(printf "%3s" "$PSU_WATTS")

echo "{\"text\": \"⚡ GPU: ${GPU_FMT}W | Total: ${PSU_FMT}W\", \"tooltip\": \"PSU Power Draw: ${PSU_WATTS}W\nGPU Power Draw: ${GPU_WATTS}W\", \"class\": \"custom-wattage\"}"
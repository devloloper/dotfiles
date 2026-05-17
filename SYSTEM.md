# Gemini Memories

## Hardware & Environment
- **Monitor:** Samsung Odyssey Neo G9 (32:9, 7680x2160).
- **GPU:** Nvidia 5090 dGPU (pci-0000:01:00.0) and Intel iGPU (pci-0000:00:02.0).
- **Controller:** Razer Wolverine V3 Pro (VID 1532, PID 0a3f) using patched `xone` driver.
- **Sound Card (Active):** Motherboard Realtek ALC4082 via S/PDIF to Sony STR-DB790 receiver.
- **Sound Card (Legacy/Bench):** Creative AE-5 Plus (CA0132 DSP). Prone to thermal lockups and PCIe errors (riser cable issues). Currently unused due to physical constraints (240mm radiator blocks the optimal slot; other slots would halve PCIe lanes to the GPU).
- **PCIe Lane Logic:** Avoid populating second PCIe 5.0 slot on Z690 Hero to maintain full x16 bandwidth to the Nvidia 5090.
    - *Note:* While PCIe 5.0 x8 (~32GB/s) is equivalent to PCIe 4.0 x16 and sufficient for gaming/standard GenAI, x16 is preferred for heavy model swapping (Stable Diffusion) or VRAM offloading (LLMs) to minimize latency.

## Preferences & Tweaks
- **Theme:** Automated via `auto-theme.sh` (Wallhaven 32:9 images + Pywal).
- **Power Saving:** Switching G9 from 240Hz to 60Hz saves ~60W.
- **Video Decoding:** Using `hwdec=nvdec` in mpv on Nvidia 5090.
- **System Monitoring:** Prefer 'By Hardware' grouping (CPU=Usage+Temp+Fan).
- **Code Style:** No emojis in scripts/code.

## Fixed Issues
- **Razer Controller:** Patched `xone` to handle 0x02/0x03 ACKs and 0x05 secret response quirks.
- **Hyprland:** Custom Lua-based configuration (`hyprland.lua`).

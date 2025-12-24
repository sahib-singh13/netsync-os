# NetSync-OS: A Network-Triggered Predictive Microkernel

## Overview
NetSync-OS is an experimental x86 microkernel written in C and Assembly, designed to mitigate tail latency in Multipath TCP (MPTCP) environments. Unlike traditional "network-blind" operating systems, NetSync implements a cross-layer scheduling architecture where the CPU scheduler dynamically re-prioritizes tasks based on real-time network subflow metrics and data arrival predictions.

**Research Focus:** Eliminating the "Blind Scheduler" bottleneck and reducing P99 tail latency in multi-homed systems (e.g., simultaneous 5G and Wi-Fi connections).

---

## The Problem and Innovation

### The "Blind Scheduler" Gap
In standard monolithic kernels, the CPU scheduler has no visibility into the state of the network stack. In MPTCP scenarios, high-speed subflows (like Wi-Fi) often wait for slower subflows (like 5G) due to Head-of-Line (HoL) Blocking. When the missing data finally arrives, the target process may be unscheduled or in a "sleeping" state, leading to a significant spike in processing latency, known as Tail Latency.



### The NetSync Solution
NetSync bridges this gap by exposing MPTCP subflow metrics—such as Round-Trip Time (RTT), Congestion Window (CWND), and sequence numbering—directly to the kernel's Priority Manager. 

* **Predictive Pre-emption:** The kernel identifies when a missing data block is likely to arrive based on subflow RTT and pre-emptively boosts the priority of the receiving task.
* **Network-Informed Context Switching:** By ensuring the CPU is ready for high-volume bursts before they are fully reassembled, NetSync minimizes the "Packet-to-Process" lag.

---

## Technical Architecture
* **Kernel Type:** Microkernel (Minimalist Core)
* **Language:** Pure C (Freestanding) and x86 Assembly
* **Target Architecture:** i686 (32-bit Protected Mode)
* **Boot Protocol:** Multiboot (GRUB-compatible)
* **Key Subsystems:**
    * **Custom GDT/IDT:** Low-level hardware abstraction and interrupt handling.
    * **VirtIO-Net Driver:** High-performance paravirtualized network interface for QEMU.
    * **Divsa-Scheduler:** A predictive, priority-based preemptive scheduler.
    * **Memory Management:** Bitmap-based Physical Memory Manager (PMM) and 4KB-page-level Virtual Memory.



---
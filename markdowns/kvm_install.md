
# KVM and Virtual Machines


## Linux
### Install kvm packages

1. Useful websites:

    * `https://ubuntu.com/blog/kvm-hyphervisor`
    * `https://linuxconfig.org/how-to-create-and-manage-kvm-virtual-machines-from-cli`
    * `https://libvirt.org/docs.html`

2. Install the kvm stack -
    * qemu-kvm -- performs OS emulation
    * libvirt -- includes libirtd server
    * libvirt-client - contains the  `virsh` and other client utilities
    * virt-install -- utility to install virtual machines
    * virt-viewer -- utility to display VM GUI


    ```
    $ sudo apt -y install qemu
    $ sudo apt -y install qemu-kvm
    $ sudo apt -y install libvirt-daemon-system
    $ sudo apt -y install bridge-utils
    $ sudo apt -y install cpu-checker
    $ sudo apt -y install libvirt-clients
    $ sudo apt -y install libvirt-daemon
    $ sudo apt install virt-manager
    $ sudo apt install virt-viewer
    ```

3. Check your hardware for compatability -

    ```
    $ kvm-ok
    INFO: /dev/kvm exists
    KVM acceleration can be used
    ```

    ```
    $ lsmod | grep kvm
    kvm_amd               245760  0
    kvm                  1441792  1 kvm_amd
    irqbypass              16384  1 kvm
    ccp                   159744  1 kvm_amd
    ```

### Install a virtual machine

1. Enable the `libvertd` daemon. This launches the daemon and enables the daemon on boot.

    `$ systemctl enable --now libvirtd`

2. Download the distro iso and store it at:

    `/var/lib/libvirt/images`

3. Install the VM.

In this example, we create a Kali linux vm called `--name=kali` using 2 virtual cpus, 2Gb memory, and a 40 Gb virtual disk, from a disk image (*e.g.,* `kali-linux-2025.3-installer-amd64.iso`). This version of Kali is part of the Debian test distro. You can check which OS variants are supported with: `osinfo-query os`.

  ```
    $ sudo virt-install \
    --name=kali \
    --vcpus=2 \
    --memory=2048 \
    --cdrom=/var/lib/libvirt/images/<your_iso> \
    --disk size=40 \
    --os-variant=debiantesting
  ```

### List and Run Virtual Machines

1. List all VM with:

    `$ sudo virsh list --all`

2. Launch a specific VM.

    `$ sudo virsh start <your_vm>`
    `$ sudo virt-viewer <your_vm>`

3. Additional commands

    * Graceful shutdown -
      `$ virsh shutdown <your_vm>`
    * Force shutdown -
      `$ virsh destroy <your_vm>`
    * Autostart vm -
      `$ virsh autostart <your_vm>`

### Modify Virtual Machines

Configure a VM with:

  `$ sudo virsh edit <vm_name>`

Modify the xml document to re-allocate host resources (*e.g.,* `<vcpu placement='static'>2</vcpu>` allocates 2 cpu cores to the machine), and reboot: `$ virsh reboot <vm_name>`

### Creating and Maintaining VM Snapshots

This feature allows us to capture the state of a virtual machine at a specific moment. This feature allows us to safely administer changes to a virtual machine and roll back to a previous state if our efforts break the machine.

1. List all VMs (may require sudo):

    `$ virsh list --all`

2. Create a snapshot for a specific VM:

    ```
      $ virsh snapshot-create-as <vm_name> <snapshot_name> \
      --description "<description>"
    ```

3. Verify the snapshot took:

    `$virsh snapshot-list <domain>`

### Revert a VM

1. List available snapshots:

    `$ virsh snapshot-list <vm_name>`

2. Revert VM:

    `$ virsh snapshot-revert <vm_name> <snapshot_name>`

### Delete VM Snapshots

1. List available snapshots:

    `$ virsh snapshot-list <vm_name>`

2. Delete VM snapshots:

    `$ virsh shanpshot-delete <vm_name> <snapshot_name>`

### Delete a VM

The following command deletes the VM and the associated storage pool:

   `$ sudo virsh undefine <vm_name> --remove-all-storage`


### Troubleshooting

## Windows 11

1. Download and move VirtIO driver ISOs to the KVM storage pool.

    `wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso`

    `$ sudo mv <virtio-win.iso> /var/lib/libvirt/images`

2. Install necessary packages:

    ```
    $ sudo apt update
    $ sudo apt -y install ovmf swtpm swtpm-tools
    ```

3. Download Windows 10/11 ISOs and move to KVM storage pool:

    `https://www.microsoft.com/en-us/software-download/windows11`

    `https://www.microsoft.com/en-us/software-download/windows10ISO`

    `$ sudo mv <win.iso> /var/lib/libvirt/images`

4. Install a windows VM (*example*)

    ```
    $ sudo virt-install \
      --name win10 \
      --ram 8192 \
      --vcpus 4 \
      --cpu host-passthrough \
      --os-variant win10 \
      --disk path=/var/lib/libvirt/images/win10.qcow2,size=100,bus=virtio,format=qcow2 \
      --cdrom /var/lib/libvirt/images/Win10_22H2_English_x64v1.iso \
      --disk path=/var/lib/libvirt/images/virtio-win.iso,device=cdrom \
      --network network=default,model=virtio \
      --graphics spice \
      --channel spicevmc \
      --video qxl \
      --features kvm_hidden=on,smm=on \
      --tpm backend.type=emulator,backend.version=2.0,model=tpm-tis \
      --accelerate \
      --boot loader=/usr/share/OVMF/OVMF_CODE_4M.secboot.fd,loader_ro=yes,loader_type=pflash,nvram_template=/usr/share/OVMF/OVMF_VARS_4M.fd
    ```

5. Choose a windows install (*e.g.,* Win10 Pro/Home/etc.)

6. Select location to install Windows.

  The installer will not see a disk to install on. Click "Load driver" instead, browse to the "virtio-win" CD-ROM and click on an "amd64" folder corresponding to your chosen Windows install. A virtual disk should now be available for install.

7. Install additional drivers.

  Open a file explorer on first boot and navigate to the virtio-win CD drive. Double-click and install the "virtio-guest-tools" package. Run through the wizard.

8. Optional driver installs.

  Install drivers for "virtio-win-gt-x64" (64-bit) or "virtio-win-gt-x86" (32-bit)

9. Verify that devices in device manager are using the correct drivers.

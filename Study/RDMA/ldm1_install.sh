zfs create rpool/export/home/ld1
sleep 2

zfs create -V 10g rpool/export/home/ld1/ldom1
sleep 2

ldm add-vcc port-range=5000-5100 primary-vcc1 primary
sleep 2

ldm add-vds primary-vds1 primary
sleep 2

ldm add-vsw net-dev=net0 primary-vsw1 primary
sleep 2

svcadm enable svc:/ldoms/vntsd:default
sleep 2

ldm add-domain ldm1
sleep 2
ldm add-vcpu 8 ldm1
sleep 2
ldm add-memory 8G ldm1
sleep 2
ldm add-vdsdev  /dev/zvol/dsk/rpool/export/home/ld1/ldom1 install_vol1@primary-vds1
sleep 2
ldm add-vdisk install_vdisk1 install_vol1@primary-vds1 ldm1
sleep 2
ldm add-vdsdev /root/sol-12_0-93_1-text-sparc.iso iso_vol1@primary-vds1
sleep 2
ldm add-vdisk iso_vdisk1 iso_vol1@primary-vds1 ldm1
sleep 2
ldm add-vnet vnet1 primary-vsw1 ldm1
sleep 2
ldm set-var auto-boot\?=true ldm1
sleep 2


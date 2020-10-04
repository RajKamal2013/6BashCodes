zfs create rpool/export/home/ld1
sleep 2
zfs create rpool/export/home/ld2
sleep 2
zfs create rpool/export/home/ld3
sleep 2
zfs create rpool/export/home/ld4
sleep 2

zfs create -V 10g rpool/export/home/ld1/ldom1
sleep 2
zfs create -V 10g rpool/export/home/ld2/ldom2
sleep 2
zfs create -V 10g rpool/export/home/ld3/ldom3
sleep 2
zfs create -V 10g rpool/export/home/ld4/ldom4
sleep 2

ldm add-vcc port-range=5000-5100 primary-vcc1 primary
sleep 2

ldm add-vds primary-vds1 primary
sleep 2
ldm add-vds primary-vds2 primary
sleep 2
ldm add-vds primary-vds3 primary
sleep 2
ldm add-vds primary-vds4 primary
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
ldm add-vdsdev /root/s12_70a/sol-12_0-70-text-sparc.iso  iso_vol1@primary-vds1
sleep 2
ldm add-vdisk iso_vdisk1 iso_vol1@primary-vds1 ldm1
sleep 2
ldm add-vnet vnet1 primary-vsw1 ldm1
sleep 2
ldm set-var auto-boot\?=true ldm1

sleep 2



ldm add-domain ldm2
sleep 2
ldm add-vcpu 8 ldm2
sleep 2
ldm add-memory 8G ldm2
sleep 2
ldm add-vdsdev  /dev/zvol/dsk/rpool/export/home/ld2/ldom2 install_vol2@primary-vds2
sleep 2
ldm add-vdisk install_vdisk2 install_vol2@primary-vds2 ldm2
sleep 2
ldm add-vdsdev /root/s12_70b/sol-12_0-70-text-sparc.iso  iso_vol2@primary-vds2
sleep 2
ldm add-vdisk iso_vdisk2 iso_vol2@primary-vds2 ldm2
sleep 2
ldm add-vnet vnet2 primary-vsw1 ldm2
sleep 2
ldm set-var auto-boot\?=true ldm2
sleep 2

ldm add-domain ldm3
sleep 2
ldm add-vcpu 8 ldm3
sleep 2
ldm add-memory 8G ldm3
sleep 2
ldm add-vdsdev  /dev/zvol/dsk/rpool/export/home/ld3/ldom3 install_vol3@primary-vds3
sleep 2
ldm add-vdisk install_vdisk3 install_vol3@primary-vds3 ldm3
ldm add-vdsdev /root/s12_70c/sol-12_0-70-text-sparc.iso  iso_vol3@primary-vds3
sleep 2
ldm add-vdisk iso_vdisk3 iso_vol3@primary-vds3 ldm3
sleep 2
ldm add-vnet vnet3 primary-vsw1 ldm3
sleep 2
ldm set-var auto-boot\?=true ldm3

ldm add-domain ldm4
sleep 2
ldm add-vcpu 8 ldm4
sleep 2
ldm add-memory 8G ldm4
sleep 2
ldm add-vdsdev  /dev/zvol/dsk/rpool/export/home/ld4/ldom4 install_vol4@primary-vds4
sleep 2
ldm add-vdisk install_vdisk4 install_vol4@primary-vds4 ldm4
sleep 2
ldm add-vdsdev /root/s12_70d/sol-12_0-70-text-sparc.iso  iso_vol4@primary-vds4
sleep 2
ldm add-vdisk iso_vdisk4 iso_vol4@primary-vds4 ldm4
sleep 2
ldm add-vnet vnet4 primary-vsw1 ldm4
sleep 2
ldm set-var auto-boot\?=true ldm4
sleep 2

ldm list-constraints -xldm1 > ldm1.xml
ldm list-constraints -xldm2 > ldm2.xml
ldm list-constraints -xldm3 > ldm3.xml
ldm list-constraints -xldm4 > ldm4.xml


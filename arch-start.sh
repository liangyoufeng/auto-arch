#!/bin/bash
echo 'Server = https://mirrors.huaweicloud.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
if [ -f /root/pacman.conf ]
then
        cp -f /root/pacman.conf /etc
        echo '[archlinuxcn]' >> /etc/pacman.conf
        echo 'Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch' >> /etc/pacman.conf
        sed -i 's/#Color/Color/g' /etc/pacman.conf
        pacman -Syy
        pacman -Sy archlinuxcn-keyring --noconfirm
        pacman -Syy
else
        cp -f /etc/pacman.conf /root/
        echo '[archlinuxcn]' >> /etc/pacman.conf
        echo 'Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch' >> /etc/pacman.conf
        sed -i 's/#Color/Color/g' /etc/pacman.conf
        pacman -Syy
        pacman -Sy archlinuxcn-keyring --noconfirm
        pacman -Syy
fi
echo "root:root"|chpasswd
systemctl start sshd
iptmp=`ip a | grep global | awk '{print $2}' | cut -f1 -d "/"`
if [ -d /sys/firmware/efi ]
then
echo '**********************'
tmpefi=eif/gpt
echo -e "startup type:\033[31m"efi"\033[0m"
echo '**********************'
else
tmpefi=bios/msdos
echo '**********************'
echo -e "startup type:\033[31m"msdos"\033[0m"
echo '**********************'
fi
echo -e 'Please run \033[31m"parted"\033[0m to see the partition content! \033[31m"print"\033[0m'
echo -e 'Please run \033[31m"lsblk"\033[0m to see the partition content'
echo -e 'Please run \033[31m"fdisk/cfdisk"\033[0m to partition the disk'
echo -e 'Please run the \033[31m"mkfs.ext4/dev/sdxxx"\033[0m formatted partition'
echo -e 'Please run \033[31m"mkfs.fat-F32/dev/sdxxx"\033[0m to format EFI partitions'
echo -e 'Please run \033[31m"mkswap/dev/sdxx"\033[0m and \033[31m"swapon/dev/sdxx"\033[0m formats and enable swap partitions'
echo -e 'After partitioning, please \033[31m"mount/dev/sdxxx"\033[0m partition directory'
echo -e 'Please press \033[31m"Alt + F2"\033[0m terminal for partition operation! After the operation is completed, press \033[31m"Alt + F1"\033[0m to return to the terminal and enter "\033[31myes\033[0m"'
echo -e 'Check whether your disk partition type is GPT or MRB. Use \033[31m"parted / dev / sdxx"\033[0m and \033[31m"mklabel msdos / gpt"\033[0m if you need a partition'
echo '********************************************************************************************************'
echo '*                                      Are you ready?                               *'
echo '*   This process takes a long time, please do not close the current terminal! Otherwise, the program will quit! *'
echo -e '*   Please enter "\033[31myes\033[0m" return, start installation, enter "\033[31mno\033[0m" return, exit installation, if 1 minute no exercise will automatically end the program! *'
echo '********************************************************************************************************'
echo -e "ssh: IP:\033[31m$iptmp\033[0m  USER:\033[31mroot\033[0m   PASSWD:\033[31mroot\033[0m   startup type:\033[31m$tmpefi\033[0m"
read -t 6000 -p "Please enter  yes/no  ：" install
if [ ! -z $install ]
then
        case "$install" in
                "yes")
                        echo 'Executing Procedure*************************'
                        pacstrap /mnt base base-devel linux linux-firmware --noconfirm
                        genfstab -U /mnt >> /mnt/etc/fstab
                                                ;;
                        "no")
                        ;;
                        *)
                echo "You entered something wrong! Make sure you are capitalized or full/half-corner symbols! Please enter the correct letter"
                ;;
        esac
else
        echo 'Can be null!'
fi
wget https://gitee.com/zerohacker/Arch-auto-install/raw/master/arch-over.sh
chmod +x arch-over.sh && cp arch-over.sh /mnt/
echo "OK"
arch-chroot /mnt
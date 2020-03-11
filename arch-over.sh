#!/bin/bash
echo -e 'Do you need to create new users?   \033[31mnewuser/no\033[0m'
##234534646gfdgdgfdgs
read -t 6000 -p "Please enter   newuser/no :" newuser
if [ ! -z $newuser ]
then
        case "$newuser" in
                "$newuser")
                        echo 'Executing Procedure*************************'
                        useradd -m -G wheel -s /bin/bash $newuser
                        echo "$newuser:root"|chpasswd
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
echo 'Server = https://mirrors.huaweicloud.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
if [ -f /tmp/pacman.conf ]
then
        cp -f /tmp/pacman.conf /etc
        echo '[archlinuxcn]' >> /etc/pacman.conf
        echo 'Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch' >> /etc/pacman.conf
        sed -i 's/#Color/Color/g' /etc/pacman.conf
        pacman -Syy
        pacman -S archlinuxcn-keyring --noconfirm
        pacman -Syy
else
        cp -f /etc/pacman.conf /tmp/
        echo '[archlinuxcn]' >> /etc/pacman.conf
        echo 'Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch' >> /etc/pacman.conf
        sed -i 's/#Color/Color/g' /etc/pacman.conf
        pacman -Syy
        pacman -S archlinuxcn-keyring --noconfirm
        pacman -Syy
fi
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
pacman -S dnsutils inetutils iproute2 vim dialog wpa_supplicant ntfs-3g networkmanager iw sudo axel --noconfirm
pacman -S openssh intel-ucode bash-completion yay --noconfirm
pacman -S ttf-dejavu wqy-zenhei wqy-microhei adobe-source-han-sans-cn-fonts net-tools openssh --noconfirm
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl enable sshd
sed -i '/zh_*/{s/#//}' /etc/locale.gen
sed -i '/en_US.UTF-8/{s/#//}' /etc/locale.gen
locale-gen
echo LANG=zh_CN.UTF-8 > /etc/locale.conf
echo Arch > /etc/hostname
echo '127.0.0.1 localhost.localdomain localhost' >> /etc/hosts
echo '::1 localhost.localdomain localhost' >> /etc/hosts
echo '127.0.1.1 Arch.localdomain Arch' >> /etc/hosts
#systemctl enable dhcpcd
systemctl enable NetworkManager.service
echo "root:root"|chpasswd
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
echo -e 'What is the boot mode of your system?  [ \033[31mdos\033[0m(bios)  \033[31mgpt\033[0m(efi)  ]'
read -t 6000 -p "Please enter    dos/gpt :" boot
if [ ! -z $boot ]
then
        case "$boot" in
                "dos")
                        echo 'Executing Procedure*************************'
                        echo -e 'What is the disk you installed? \033[31msdxxx\033[0m?'
                        read -t 6000 -p "Please enter:" sdax
                        pacman -S grub os-prober --noconfirm
                        grub-install --target=i386-pc /dev/$sdax
                        grub-mkconfig -o /boot/grub/grub.cfg
                        mkinitcpio -P
                                                ;;
                        "gpt")
                        pacman -S dosfstools grub efibootmgr --noconfirm
                        grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=grub
                        grub-mkconfig -o /boot/grub/grub.cfg
                        sed -i 's/use_lvmetad = 1/use_lvmetad = 0/g' /etc/lvm/lvm.conf
                        grub-mkconfig -o /boot/grub/grub.cfg
                        mkinitcpio -P
                        ;;
                        *)
                echo "You entered something wrong! Make sure you are capitalized or full/half-corner symbols! Please enter the correct letter"
                ;;
        esac
else
        echo 'Can be null!'
fi
echo -e 'You want to install that desktop environment?   \033[31m<1.xfce4   2.plasma(kde)   3.lxde   4.gnome   5.deepin>    no(exit)\033[0m'
read -t 6000 -p "Please enter  1    2    3    4    5    exit   :" desktop
if [ ! -z $desktop ]
then
        case "$desktop" in
                "1")
                        echo 'Executing Procedure*************************'
                        pacman -S xf86-video-vesa xorg xf86-input-synaptics --noconfirm
                        pacman -S alsa-utils pulseaudio pulseaudio-alsa xfce4 sddm --noconfirm
                        systmectl start sddm &
                        systemctl enable sddm.service
                                                ;;
                "2")
                        echo 'Executing Procedure*************************'
                        pacman -S xf86-video-vesa xorg xf86-input-synaptics --noconfirm
                        pacman -S alsa-utils pulseaudio pulseaudio-alsa sddm plasma --noconfirm
                        systmectl start sddm &
                        systemctl enable sddm.service
                                                ;;
                "3")
                        echo 'Executing Procedure*************************'
                        pacman -S xf86-video-vesa xorg xf86-input-synaptics --noconfirm
                        pacman -S alsa-utils pulseaudio pulseaudio-alsa lxde --noconfirm
                        systemctl start lxdm.service &
                        systemctl enable lxdm.service
                                                ;;
                "4")
                        echo 'Executing Procedure*************************'
                        pacman -S xf86-video-vesa xorg xf86-input-synaptics --noconfirm
                        pacman -S alsa-utils pulseaudio pulseaudio-alsa gnome gdm --noconfirm
                        systemctl start gdm.service &
                        systemctl enable gdm.service
                                                ;;
                "5")
                        echo 'Executing Procedure*************************'
                        pacman -S xf86-video-vesa xorg xf86-input-synaptics --noconfirm
                        pacman -S alsa-utils pulseaudio pulseaudio-alsa deepin --noconfirm
                        pacman -S lightdm lightdm-deepin-greeter --noconfirm
                        systemctl start lightdm.service &
                        systemctl enable lightdm.service
                                                ;;
                "exit")
                        ;;
                        *)
                echo "You entered something wrong! Make sure you are capitalized or full/half-corner symbols! Please enter the correct letter"
                ;;
        esac
else
        echo 'Can be null!'
fi
pacman -S neofetch screen screenfetch wget zip unzip tar simplescreenrecorder p7zip vlc git lxterminal gedit xdg-user-dirs-gtk fish zsh --noconfirm
cat > help.txt <<-EOF
更改家目录为英文
sudo pacman -S xdg-user-dirs-gtk
export LANG=en_US
xdg-user-dirs-gtk-update
然后会有个窗口提示语言更改，更新名称即可
export LANG=zh_CN.UTF-8
然后重启电脑如果提示语言更改，保留旧的名称即可

安装oh-my-zsh
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
chmod +x install.sh && ./install.sh
主题agnoster

安装vim
git clone https://gitee.com/chxuan/vimplus.git
cd ~/.vimplus
./install.sh
sed -i "s/colorscheme onedark/colorscheme peachpuff/g" ~/.vimrc

安装谷歌浏览器：
sudo pacman -S google-chrome

安装搜狗输入法：
sudo pacman -S fcitx-sogoupinyin fcitx-configtool fcitx-im
yay -Sa fcitx-qt4
sudo vim /etc/environment 
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS="@im=fcitx"
EOF
echo -e "Congratulations, the system has been installed! User is \033[31m$newuser\033[0m and all passwords are initialized to \033[31mroot\033[0m   \033[31mumount -R /mnt\033[0m    \033[31mreboot\033[0m"
exit

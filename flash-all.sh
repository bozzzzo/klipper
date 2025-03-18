set -ex
cd ~/klipper
make KCONFIG_CONFIG=.config.pico menuconfig
make KCONFIG_CONFIG=.config.pico clean
make KCONFIG_CONFIG=.config.pico 
MCU_CAN_UUID=b28a29fc6ddf 
MCU_SERIAL_ID=/dev/serial/by-id/usb-katapult_rp2040_4550357129124138-if00
test -e $MCU_SERIAL_ID || ~/katapult/scripts/flashtool.py -u $MCU_CAN_UUID -f ~/klipper/out/klipper.bin -r
while test \! -e $MCU_SERIAL_ID; do echo Wait reboot; sleep 1; done
python3 ~/katapult/scripts/flash_can.py -f ~/klipper/out/klipper.bin -d $MCU_SERIAL_ID
sleep 10
ifconfig
make KCONFIG_CONFIG=.config.ebb menuconfig
make KCONFIG_CONFIG=.config.ebb clean
make KCONFIG_CONFIG=.config.ebb 
EBB_CAN_UUID=007266ab5cca 
~/katapult/scripts/flashtool.py -u $EBB_CAN_UUID -i can0 -f ~/klipper/out/klipper.bin
sleep 10
make KCONFIG_CONFIG=.config.rpi menuconfig
make KCONFIG_CONFIG=.config.rpi clean
make KCONFIG_CONFIG=.config.rpi
sudo service klipper stop
make KCONFIG_CONFIG=.config.rpi flash
sudo service klipper start
service klipper-mcu status
service klipper status

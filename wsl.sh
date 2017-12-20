#!/bin/bash
# Kickstart Server Configurator - V.0.1
# Let's start by setting up our apt-cache server (Must Request Sudo)
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
if ping -c 1 10.162.150.10 > /dev/null
  then
    :
  else
    echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    echo This system was unable to contact NHSCS.
    echo It is NOT recomended to run this kickstart on machines that can not contact NHSCS.
    echo Based on this warning, do you want to continue? [y/N][ENTER]
    read nhscsping
    echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    if [ $nhscsping = "y" ]
      then
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=
        echo "Kickstart will continue."
        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=
      else
        if [ $nhscsping = "Y" ]
          then
            echo =-=-=-=-=-=-=-=-=-=-=-=-=-=
            echo "Kickstart will continue."
            echo =-=-=-=-=-=-=-=-=-=-=-=-=-=
          else
            if [ $nhscsping = "" ]
              then
                echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                echo "Kickstart will stop. Exiting."
                echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                exit
              else
                if [ $nhscsping = "N" ]
                  then
                    echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                    echo "Kickstart will stop. Exiting."
                    echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                    exit
                  else
                    if [ $nhscsping = "n" ]
                      then
                        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                        echo "Kickstart will stop. Exiting."
                        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                        exit
                      else
                        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                        echo "That's not an answer, exiting."
                        echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                        exit
                    fi
                fi
            fi
        fi
    fi
fi
echo 'Acquire::http::Proxy "http://EH3-NHSCS-UUC01.ad.nhscs.net:3142";' >> /etc/apt/apt.conf.d/01proxy
# Let's update the system
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo "WE ARE GOING TO UPDATE THE SYSTEM NOW"
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
sleep 2
apt-get update && apt-get dist-upgrade
echo =-=-=-=-=-=-=-=-=-=
echo "Updates are done"
echo =-=-=-=-=-=-=-=-=-=
sleep 2
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo "WE ARE GOING TO ADD CERTIFICATES NOW"
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
curl https://github.com/NHSCS-ORG/Ubuntu-Kickstart/blob/master/nhscs-landscape.cer -o /usr/local/share/ca-certificates/nhscs-landscape.crt
curl https://github.com/NHSCS-ORG/Ubuntu-Kickstart/blob/master/nhscs-landscape.cer -o /usr/share/ca-certificates/nhscs-landscape.crt
curl https://github.com/NHSCS-ORG/Ubuntu-Kickstart/blob/master/Firewall_Certificate.cer -o /usr/local/share/ca-certificates/tf-firewall.crt
curl https://github.com/NHSCS-ORG/Ubuntu-Kickstart/blob/master/Firewall_Certificate.cer -o /usr/share/ca-certificates/tf-firewall.crt
update-ca-certificates
sleep 5
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo "We're done. Reloading in 10 seconds."
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
sleep 10
bash.exe
exit

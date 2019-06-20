#!/bin/bash
#----------------------------------------------#
# this script is to request SSL certificates via let's encrpt tool acme
# to setup acme server please refer to acme documentation
# author: Zhou Guoliang
# email: zhou-guo-liang@pacific-textiles.com
#----------------------------------------------#

/root/.acme.sh/acme.sh --issue --dns dns_cf -d '*.pacific-textiles.com' -d 'pacific-textiles.com'

# generate current timestamp
currentTimestamp=`date "+%Y%m%d%H%M%S"`
if [ ! -f "/root/.ssh/id_rsa" ];then
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N ""
fi

count=`cat /opt/letsencrypt/systems.xml | grep HOSTNAME |wc -l`
echo "============================================================"
echo "start distribute cert and key ..."
for((i=1;i<=${count};i++));
do
    # get hostname
    hostname=`xpath -e "/HOSTS/HOST[$i]/HOSTNAME/text()" /opt/letsencrypt/systems.xml`
    keypath=`xpath -e "/HOSTS/HOST[$i]/KEYPATH/text()" /opt/letsencrypt/systems.xml`
    cerpath=`xpath -e "/HOSTS/HOST[$i]/CERPATH/text()" /opt/letsencrypt/systems.xml`
    cmd=`xpath -e "/HOSTS/HOST[$i]/COMMAND/text()" /opt/letsencrypt/systems.xml`

    #copy key
    cat /root/.ssh/known_hosts |grep ${hostname}
    if [ $? -ne 0 ];then
    ssh-keyscan -t ssh-rsa ${hostname} >>/root/.ssh/known_hosts
    ssh-copy-id -i /root/.ssh/id_rsa.pub -f ${hostname}
    fi

    # distribute key and cert
    ssh ${hostname} "mv ${keypath} ${keypath}${currentTimestamp}"
    scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.key ${hostname}:${keypath}
    ssh ${hostname} "mv ${cerpath} ${cerpath}${currentTimestamp}"
    scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.cer ${hostname}:${cerpath}

    # restart service
    ssh ${hostname} "${cmd}"
done
echo "program completed!"
echo "============================================================"
#echo "openproject ... ..."
##-----read hostname and related parameters
#hostname=`xpath -e "/HOSTS/HOST[@id='openproject']/HOSTNAME/text()" /opt/letsencrypt/systems.xml`
#keypath=`xpath -e "/HOSTS/HOST[@id='openproject']/KEYPATH/text()" /opt/letsencrypt/systems.xml`
#cerpath=`xpath -e "/HOSTS/HOST[@id='openproject']/CERPATH/text()" /opt/letsencrypt/systems.xml`
#cmd=`xpath -e "/HOSTS/HOST[@id='openproject']/COMMAND/text()" /opt/letsencrypt/systems.xml`
##-----copy key
#ssh-keyscan -t ssh-rsa ${hostname} >>/root/.ssh/known_hosts
#ssh-copy-id -i /root/.ssh/id_rsa.pub -f ${hostname}
##-----replace key and certificate
#ssh ${hostname} "mv ${keypath} ${keypath}${currentTimestamp}"
#scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.key ${hostname}:${keypath}
#ssh ${hostname} "mv ${cerpath} ${cerpath}${currentTimestamp}"
#scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.cer ${hostname}:${cerpath}
##-----execute remote command to reload service
#ssh ${hostname} "${cmd}"
#
#echo "idmdev ... ..."
##-----read hostname and related parameters
#hostname=`xpath -e "/HOSTS/HOST[@id='idmdev']/HOSTNAME/text()" /opt/letsencrypt/systems.xml`
#keypath=`xpath -e "/HOSTS/HOST[@id='idmdev']/KEYPATH/text()" /opt/letsencrypt/systems.xml`
#cerpath=`xpath -e "/HOSTS/HOST[@id='idmdev']/CERPATH/text()" /opt/letsencrypt/systems.xml`
#cmd=`xpath -e "/HOSTS/HOST[@id='idmdev']/COMMAND/text()" /opt/letsencrypt/systems.xml`
##-----copy key
#ssh-keyscan -t ssh-rsa ${hostname} >>/root/.ssh/known_hosts
#ssh-copy-id -i /root/.ssh/id_rsa.pub -f ${hostname}
##-----replace key and certificate
#ssh ${hostname} "mv ${keypath} ${keypath}${currentTimestamp}"
#scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.key ${hostname}:${keypath}
#ssh ${hostname} "mv ${cerpath} ${cerpath}${currentTimestamp}"
#scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.cer ${hostname}:${cerpath}
##-----execute remote command to reload service
#ssh ${hostname} "${cmd}"
#
#echo "idmuat ... ..."
##-----read hostname and related parameters
#hostname=`xpath -e "/HOSTS/HOST[@id='idmuat']/HOSTNAME/text()" /opt/letsencrypt/systems.xml`
#keypath=`xpath -e "/HOSTS/HOST[@id='idmuat']/KEYPATH/text()" /opt/letsencrypt/systems.xml`
#cerpath=`xpath -e "/HOSTS/HOST[@id='idmuat']/CERPATH/text()" /opt/letsencrypt/systems.xml`
#cmd=`xpath -e "/HOSTS/HOST[@id='idmuat']/COMMAND/text()" /opt/letsencrypt/systems.xml`
##-----copy key
#ssh-keyscan -t ssh-rsa ${hostname} >>/root/.ssh/known_hosts
#ssh-copy-id -i /root/.ssh/id_rsa.pub -f ${hostname}
##-----replace key and certificate
#ssh ${hostname} "mv ${keypath} ${keypath}${currentTimestamp}"
#scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.key ${hostname}:${keypath}
#ssh ${hostname} "mv ${cerpath} ${cerpath}${currentTimestamp}"
#scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.cer ${hostname}:${cerpath}
##-----execute remote command to reload service
#ssh ${hostname} "${cmd}"
#
#echo "idmprd ... ..."
##-----read hostname and related parameters
#hostname=`xpath -e "/HOSTS/HOST[@id='idmprd']/HOSTNAME/text()" /opt/letsencrypt/systems.xml`
#keypath=`xpath -e "/HOSTS/HOST[@id='idmprd']/KEYPATH/text()" /opt/letsencrypt/systems.xml`
#cerpath=`xpath -e "/HOSTS/HOST[@id='idmprd']/CERPATH/text()" /opt/letsencrypt/systems.xml`
#cmd=`xpath -e "/HOSTS/HOST[@id='idmprd']/COMMAND/text()" /opt/letsencrypt/systems.xml`
##-----copy key
#ssh-keyscan -t ssh-rsa ${hostname} >>/root/.ssh/known_hosts
#ssh-copy-id -i /root/.ssh/id_rsa.pub -f ${hostname}
##-----replace key and certificate
#ssh ${hostname} "mv ${keypath} ${keypath}${currentTimestamp}"
#scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.key ${hostname}:${keypath}
#ssh ${hostname} "mv ${cerpath} ${cerpath}${currentTimestamp}"
#scp /root/.acme.sh/*.pacific-textiles.com/*.pacific-textiles.com.cer ${hostname}:${cerpath}
##-----execute remote command to reload service
#ssh ${hostname} "${cmd}"
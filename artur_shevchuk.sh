#!/bin/bash
#Oleksandr,please note, that  I will download jre and sco it after that, because there is a mistake with java while
#ssh $hostname "wget..." and there is OK on local machine

show_help() {
cat << EOF
Usage: ${0##*/} [-j=true|false]
Install java to remote machine
    -j=true 	install java from archive
    -j=false	install java from yum repo
EOF
}

if [[ $# -ne 1 ]]
then
show_help
exit 1
fi


while [[ $1 = -* ]]; do
    arg=$1; shift          


    case $arg in
        -j=true)
        shift          
	while read hostname 
	do
        wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jre-8u101-linux-x64.tar.gz"	
	ssh $hostname "mkdir /opt/java_jre; mkdir /opt/configs"
	scp  jre-8u101-linux-x64.tar.gz $hostname:/opt/java_jre
	ssh $hostname "tar -zxvf /opt/java_jre/jre-8u101-linux-x64.tar.gz -C /opt/java_jre/"
        ssh $hostname "export JAVA_HOME=/opt/java_jre/jre1.8.0_101/bin/java"
	ssh $hostname "export PATH=$PATH:/opt/java_jre/jre1.8.0_101/bin"
	ssh $hostname "java -version"
	scp sampleconfig.conf $hostname:/opt/configs
	ssh $hostname "sed -i 's|/path-to-binary|/opt/java_jre/jre1.8.0_101/bin|g' /opt/configs/sampleconfig.conf"
	ssh $hostname "sed -i 's/ip-address/$hostname/g' /opt/configs/sampleconfig.conf"
	done < hostnames.txt
            ;;

        -j=false)
        while read hostname 
	do
        ssh $hostname "mkdir /opt/configs"
        ssh $hostname "yum install -y java-1.8.0-openjdk"
    	ssh $hostname "java -version"
        scp sampleconfig.conf $hostname:/opt/configs
	ssh $hostname "sed -i 's|/path-to-binary|$JAVA_HOME|g' /opt/configs/sampleconfig.conf"
	ssh $hostname "sed -i 's/ip-address/$hostname/g' /opt/configs/sampleconfig.conf"
	done < hostnames.txt
            ;;

        *)
            show_help
            exit 1
        ;;
    esac
done

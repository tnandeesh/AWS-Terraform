#!/bin/bash
sudo hostnamectl set-hostname "tomcat.cloudbinary.io"
echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts
sudo apt-get update
sudo apt-get install git wget unzip curl tree -y
sudo apt-get install openjdk-11-jdk -y
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >> /etc/environment
source /etc/environment
echo $JAVA_HOME
cd /opt/
sudo wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz
sudo apt-get update
sudo tar xvzf apache-tomcat-8.5.96.tar.gz
sudo mv apache-tomcat-8.5.96 tomcat
sudo apt-get update
cd /opt/tomcat/
sudo cp -pvr /opt/tomcat/conf/tomcat-users.xml "/opt/tomcat/conf/tomcat-users.xml_$(date +%F_%R)"
sed -i '$d' /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="manager-gui"/>'  >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="manager-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="manager-jmx"/>'    >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="admin-gui"/>'     >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="admin-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
echo '<user username="admin" password="redhat@123" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
echo "</tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml

sudo echo '<?xml version="1.0" encoding="UTF-8"?>' > /opt/tomcat/webapps/manager/META-INF/context.xml 
sudo echo '<Context antiResourceLocking="false" privileged="true" >' >> /opt/tomcat/webapps/manager/META-INF/context.xml 
sudo echo '</Context>' >> /opt/tomcat/webapps/manager/META-INF/context.xml 

sudo echo '<?xml version="1.0" encoding="UTF-8"?>' > /opt/tomcat/webapps/host-manager/META-INF/context.xml 
sudo echo '<Context antiResourceLocking="false" privileged="true" >' >> /opt/tomcat/webapps/host-manager/META-INF/context.xml 
sudo echo '</Context>' >> /opt/tomcat/webapps/host-manager/META-INF/context.xml 

sudo echo '[Unit]' > /etc/systemd/system/tomcat.service 
sudo echo 'Description=Apache Tomcat Web Application Container' >> /etc/systemd/system/tomcat.service 
sudo echo 'After=network.target' >> /etc/systemd/system/tomcat.service 
sudo echo '[Service]' >> /etc/systemd/system/tomcat.service 
sudo echo 'Type=forking' >> /etc/systemd/system/tomcat.service 
sudo echo 'Environment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64' >> /etc/systemd/system/tomcat.service 
sudo echo 'Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid' >> /etc/systemd/system/tomcat.service  
sudo echo 'Environment=CATALINA_HOME=/opt/tomcat' >> /etc/systemd/system/tomcat.service 
sudo echo 'Environment=CATALINA_BASE=/opt/tomcat' >> /etc/systemd/system/tomcat.service 
sudo echo 'Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'' >> /etc/systemd/system/tomcat.service 
sudo echo 'Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'' >> /etc/systemd/system/tomcat.service 
sudo echo 'ExecStart=/opt/tomcat/bin/startup.sh' >> /etc/systemd/system/tomcat.service 
sudo echo 'ExecStop=/opt/tomcat/bin/shutdown.sh' >> /etc/systemd/system/tomcat.service 
sudo echo 'User=root' >> /etc/systemd/system/tomcat.service 
sudo echo 'Group=root' >> /etc/systemd/system/tomcat.service 
sudo echo 'UMask=0007' >> /etc/systemd/system/tomcat.service 
sudo echo 'RestartSec=10' >> /etc/systemd/system/tomcat.service 
sudo echo 'Restart=always' >> /etc/systemd/system/tomcat.service 
sudo echo '[Install]' >> /etc/systemd/system/tomcat.service 
sudo echo 'WantedBy=multi-user.target' >> /etc/systemd/system/tomcat.service 
sudo apt-get update
systemctl enable tomcat.service
systemctl status tomcat.service 
systemctl enable tomcat.service 
systemctl status tomcat.service 
systemctl start tomcat.service 
systemctl start tomcat.service 


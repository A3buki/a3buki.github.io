#!/bin/bash

#В целях безопасности Tomcat должен запускаться как непривилегированный пользователь (Не root). Мы создадим нового пользователя и группу, которые будут запускать службу Tomcat.

#Для работы tomcat необходимо установить Java, устанавливаем java
yum install -y java


#Сначало нужно создать tomcat группу
groupadd tomcat


#Создаем новго пользователя tomcat с домашним котлогом: -d /opt/tomcat и без возможности логина: -s /bin/nologin определим его в группу -g tomcat
adduser -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat


###############################################
######### TomCat Installation #################
###############################################

#Теперь установим tomcat - для этого нужно на офф.сайте tomcat скачать tar.gz архив можно через wget, переходим в домашний катало root

cd ~

wget http://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-9/v9.0.10/bin/apache-tomcat-9.0.10.tar.gz

#Tomcat будем устанавливать (как принето) в /opt/tomcat деректорию, значит ее создадим и разархивируем туда скаченный ранее архив tomcat.

mkdir /opt/tomcat
tar -xvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1

#После установки мы готовы к конфигурации кота. Первое что перейдем к деректори tomcat и установим права для группы tomcat

cd /opt/tomcat

#Даем права владельца для группы tomcat 

chgrp -R tomcat /opt/tomcat


#Далее даем права чтиение к конфигурационной директиве и всему контенту и права записи

chmod -R g+r conf
chmod g+x conf


#Затем сделайте пользователя tomcat владельцем webapps, work, temp, и logs Директорий

chown -R tomcat webapps/ work/ temp/ logs/

#И так права розданы, перейдом к конфигурированю Unit для Systemd

#Создадим фалй unit в /etc/systemd/system/tomcat.service  и заполним его настройкой unita (данный юнит актуален - если java ставилась через yum install)

touch /etc/systemd/system/tomcat.service

echo "
# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
"  >> /etc/systemd/system/tomcat.service

#После создания unita нужно перезапустить сам systemd, запустить этот юнит и добавть в автозагрузку

#Перезапуск демона 
systemctl daemon-reload

#Запуск юнит в работу

systemctl start tomcat

#Добавлвение юнита в автозагрузку

systemctl enable tomcat

#После этого заходим через веб браузер на http://server_IP_address:8080 там должна быть стратовая страница tomcat















clear


echo -e \
  "\033[1;32m" \
  "███████████████████████████████████
█───██────██─███──█────██────██───█
██─███─██─██──█───█─██─██─██─███─██
██─███─██─██─█─█──█─█████────███─██
██─███─██─██─███──█─██─██─██─███─██
██─███────██─███──█────██─██─███─██
███████████████████████████████████


██████████████████████████████████████████████████████████
█─█─██────██───██────██─██─██────██────█████──██───██─██─█
█─█─██─██─███─███─██─██─██─██─██─██─██──███─█─██─████─██─█
█───██─██████─███────██────██─██─██────███─██─██───██────█
███─██─██─███─███─██─██─██─██─██─██─██──██─██─██─████─██─█
█───██────███─███─██─██─██─██────██────███─██─██───██─██─█
██████████████████████████████████████████████████████████
" \
  "\033[0m"
cd /


#Добовляем пользователя tomcat в группу wheel
#gpasswd -a tomcat wheel 
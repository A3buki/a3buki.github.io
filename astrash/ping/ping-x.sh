#!/bin/bash
# Название: ping-cr.sh
# Автоматически создает скрипт ping.sh и каталог ponglog в /opt
# При старте графической оболчки происходит пинг удаленного хоста


#Создаем директории
cd /opt
mkdir ponglog
cd /opt/ponglog


#Создаем скрипт
touch ping.sh

#Задаем ip адресс для пинга
echo "Введите IP адрес пингуемого хоста:"
read ip

#Заполняем скрипт дата для лога и команда пинга
echo "/bin/ping -c 100 $ip >> /opt/ponglog/ping.log &" > /opt/ponglog/ping.sh
echo "/bin/date >> /opt/ponglog/ping.log &" >> /opt/ponglog/ping.sh
/bin/chmod 777 /opt/ponglog/ping.sh


#Устанавливаем запуск скрипта при старте fly-dm
echo "/bin/bash  /opt/ponglog/ping.sh" >>  /etc/X11/fly-dm/Xsetup
clear
clear
echo
echo
echo "Перезагрузите компьютер."
echo
#!/bin/bash

#Срипт создания локльных репозиториев
#Скрипт будет работать если в /opt добавлены iso образы системы и обновления


cd /mnt


#Создаем катлоги и подкаталоги для монтирования и копирования.
/bin/mkdir /mnt/iso1
/bin/mkdir /mnt/iso2

/bin/mkdir -p /srv/repo/smolensk/update
/bin/mkdir -p /srv/repo/smolensk/main


#Монтируем образы в каталоги iso
/bin/mount -o loop /opt/20200327SE16.iso /mnt/iso1/
/bin/mount -o loop /opt/smolensk-*.iso /mnt/iso2/
clear
echo "Ожидайте ... "



#Копируем содержимое образов в катлоги репозитория /srv/... .

/bin/cp -r /mnt/iso1/* /srv/repo/smolensk/update && /bin/cp -r /mnt/iso2/* /srv/repo/smolensk/main

cd /tmp
#Резервная копия источника
/bin/cp -r /etc/apt/sources.list /etc/apt/sources.list.backup


#Очищаем source list
echo "" > /etc/apt/sources.list

#Наполняем source list
echo "deb file:///srv/repo/smolensk/main smolensk main contrib non-free" >> /etc/apt/sources.list
echo "deb file:///srv/repo/smolensk/update smolensk main contrib non-free" >> /etc/apt/sources.list

#Чистим /var/lib/apt/list
/bin/rm -rvf /var/lib/apt/lists/*
/bin/rm -r /mnt/iso*

#Обновляем кэшь
apt-get update
clear
clear
echo
echo -e "       .
       ,O,
      ,OOO,
'oooooOOOOOooooo'
   OOOOOOOOOOO
     OOOOOOO
    OOOO'OOOO
   OOO'   'OOO
  O'         'O
  "
echo
echo Обновите систему командой: apt dist-upgrade
echo


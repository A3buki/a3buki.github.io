#!/bin/bash
cd /etc/
echo "PS1='\[\033[00m\]\[\033[01m\]\[\033[01;35m\]┌─ \@ \[\033[01m\]\[\033[01;31m\]\u@\h\[\033[00m\]\[\033[01m\]\[\033[01;32m\]->[\[\033[01m\]\[\033[01;33m\]\w\[\033[00m\]\[\033[01m\]\[\033[01;32m\]]\n└─ # '"  >> /etc/bashrc

#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "VPS Manager 2.0.1" ; tput sgr0
tput setaf 3 ; tput bold ; echo "" ; echo "Este script irÃ¡:" ; echo ""
echo "â— Instalar e configurar o proxy squid nas portas 80, 3128, 8080 e 8799" ; echo "  para permitir conexÃµes SSH para este servidor"
echo "â— Configurar o OpenSSH para rodar nas portas 22 e 443"
echo "â— Instalar um conjunto de scripts como comandos do sistema para o gerenciamento de usuÃ¡rios" ; tput sgr0
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
tput setaf 2 ; tput bold ; echo "	Termos de Uso" ; tput sgr0
echo ""
echo "Ao utilizar o 'VPS Manager 2.0' vocÃª concorda com os seguintes termos de uso:"
echo ""
echo "1. VocÃª pode:"
echo "a. Instalar e usar o 'VPS Manager 2.0' no(s) seu(s) servidor(es)."
echo "b. Criar, gerenciar e remover um nÃºmero ilimitado de usuÃ¡rios atravÃ©s desse conjunto de scripts."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "2. VocÃª nÃ£o pode:"
echo "a. Editar, modificar, compartilhar ou redistribuir (gratuitamente ou comercialmente)"
echo "esse conjunto de scripts sem autorizaÃ§Ã£o do desenvolvedor."
echo "b. Modificar ou editar o conjunto de scripts para fazer vocÃª parecer o desenvolvedor dos scripts."
echo ""
echo "3. VocÃª aceita que:"
echo "a. O valor pago por esse conjunto de scripts nÃ£o inclui garantias ou suporte adicional,"
echo "porÃ©m o usuÃ¡rio poderÃ¡, de forma promocional e nÃ£o obrigatÃ³ria, por tempo limitado,"
echo "receber suporte e ajuda para soluÃ§Ã£o de problemas desde que respeite os termos de uso."
echo "b. O usuÃ¡rio desse conjunto de scripts Ã© o Ãºnico resposÃ¡vel por qualquer tipo de implicaÃ§Ã£o"
echo "Ã©tica ou legal causada pelo uso desse conjunto de scripts para qualquer tipo de finalidade."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "4. VocÃª concorda que o desenvolvedor nÃ£o se responsabilizarÃ¡ pelos:"
echo "a. Problemas causados pelo uso dos scripts distribuÃ­dos sem autorizaÃ§Ã£o."
echo "b. Problemas causados por conflitos entre este conjunto de scripts e scripts de outros desenvolvedores."
echo "c. Problemas causados por ediÃ§Ãµes ou modificaÃ§Ãµes do cÃ³digo do script sem autorizaÃ§Ã£o."
echo "d. Problemas do sistema causados por programas de terceiro ou modificaÃ§Ãµes/experimentaÃ§Ãµes do usuÃ¡rio."
echo "e. Problemas causados por modificaÃ§Ãµes no sistema do servidor."
echo "f. Problemas causados pelo usuÃ¡rio nÃ£o seguir as instruÃ§Ãµes da documentaÃ§Ã£o do conjunto de scripts."
echo "g. Problemas ocorridos durante o uso dos scripts para obter lucro comercial."
echo "h. Problemas que possam ocorrer ao usar o conjunto de scripts em sistemas que nÃ£o estÃ£o na lista de sistemas testados."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
IP=$(wget -qO- ipv4.icanhazip.com)
read -p "Para continuar confirme o IP deste servidor: " -e -i $IP ipdovps
if [ -z "$ipdovps" ]
then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "" ; echo " VocÃª nÃ£o digitou o IP deste servidor. Tente novamente. " ; echo "" ; echo "" ; tput sgr0
	exit 1
fi
if [ -f "/root/usuarios.db" ]
then
tput setaf 6 ; tput bold ;	echo ""
	echo "Uma base de dados de usuÃ¡rios ('usuarios.db') foi encontrada!"
	echo "Deseja mantÃª-la (preservando o limite de conexÃµes simultÃ¢neas dos usuÃ¡rios)"
	echo "ou criar uma nova base de dados?"
	tput setaf 6 ; tput bold ;	echo ""
	echo "[1] Manter Base de Dados Atual"
	echo "[2] Criar uma Nova Base de Dados"
	echo "" ; tput sgr0
	read -p "OpÃ§Ã£o?: " -e -i 1 optiondb
else
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
echo ""
read -p "Deseja ativar a compressÃ£o SSH (pode aumentar o consumo de RAM)? [s/n]) " -e -i n sshcompression
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Aguarde a configuraÃ§Ã£o automÃ¡tica" ; echo "" ; tput sgr0
sleep 3
apt-get update -y
apt-get upgrade -y
rm /bin/criarusuario /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/ajuda > /dev/null
rm /root/ExpCleaner.sh /root/CriarUsuario.sh /root/sshlimiter.sh > /dev/null
apt-get install squid3 bc screen nano unzip dos2unix wget -y
killall apache2
apt-get purge apache2 -y
if [ -f "/usr/sbin/ufw" ] ; then
	ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp
fi
if [ -d "/etc/squid3/" ]
then
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/squid1.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/squid2.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid3/squid.conf
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/payload.txt -O /etc/squid3/payload.txt
	echo " " >> /etc/squid3/payload.txt
	grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 443" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/alterarsenha.sh -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/criarusuario2.sh -O /bin/criarusuario
	chmod +x /bin/criarusuario
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/expcleaner2.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/sshlimiter2.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/ajuda.sh -O /bin/ajuda
	chmod +x /bin/ajuda
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/sshmonitor2.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid3" ]
	then
		service squid3 reload > /dev/null
	else
		/etc/init.d/squid3 reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
if [ -d "/etc/squid/" ]
then
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/squid1.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/squid2.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid/squid.conf
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/payload.txt -O /etc/squid3/payload.txt
	echo " " >> /etc/squid/payload.txt
	grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 443" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/alterarsenha.sh -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/criarusuario2.sh -O /bin/criarusuario
	chmod +x /bin/criarusuario
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/expcleaner2.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/sshlimiter2.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/ajuda.sh -O /bin/ajuda
	chmod +x /bin/ajuda
	wget https://raw.githubusercontent.com/Alissongithub/squid33/master/sshmonitor2.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid" ]
	then
		service squid reload > /dev/null
	else
		/etc/init.d/squid reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Proxy Squid Instalado e rodando nas portas: 80, 3128, 8080 e 8799" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "OpenSSH rodando nas portas 22 e 443" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Scripts para gerenciamento de usuÃ¡rio instalados" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Leia a documentaÃ§Ã£o para evitar dÃºvidas e problemas!" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Para ver os comandos disponÃ­veis use o comando: ajuda" ; tput sgr0
echo ""
if [[ "$optiondb" = '2' ]]; then
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
if [[ "$sshcompression" = 's' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
	echo "Compression yes" >> /etc/ssh/sshd_config
fi
if [[ "$sshcompression" = 'n' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
fi
exit 1

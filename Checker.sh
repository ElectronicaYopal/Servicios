#!/bin/sh
#
# Script Name: Checker.sh
#
# Author: NeFa
# Date : 12.06.2021
#
# Description: Mantener servicio en linea.
#
# Run Information: Este script se ejecuta automáticamente cada 5 minutos.
#
# Standard Output: mensajes de salida en: output.log
#
# Error Log: mensajes de error en: errors.log
#

#exec 1>> ~/Scripts/Servicios/Checker_output.log
#exec 2>> ~/Scripts/Servicios/Checker_errors.log

# Script:

echo && echo "////////// Crontab Check ngrok: " $(date) "//////////"

PATH="/usr/local/bin:/usr/bin:/bin:/snap/bin"
ruta='/home/serverelectronica/Scripts/Servicios'

tunnelInfoNgrok () {
	ngrokJson=$(curl --silent --show-error http://127.0.0.1:4040/api/tunnels)
	if [ $ngrokJson ]
	then
		echo "Getting urls"
		addr_ssh=$(echo $ngrokJson | jq -r '.tunnels[] | select(.name == "ssh").public_url')
		addr_web80=$(echo $ngrokJson | jq -r '.tunnels[] | select(.name == "web80").public_url')
		addr_web8080=$(echo $ngrokJson | jq -r '.tunnels[] | select(.name == "web8080").public_url')
		addr_web3000=$(echo $ngrokJson | jq -r '.tunnels[] | select(.name == "web3000").public_url')


		sed -i "s#web80 = \".*\";#web80 = \"${addr_web80}\";#g" $ruta/index.html
		sed -i "s#web8080 = \".*\";#web8080 = \"${addr_web8080}\";#g" $ruta/index.html
		sed -i "s#web3000 = \".*\";#web3000 = \"${addr_web3000}\";#g" $ruta/index.html
		
		sed -i "s#ssh: .*#ssh: ${addr_ssh} #g" $ruta/tunneling.md
		sed -i "s#http80: .*#http80: ${addr_web80} #g" $ruta/tunneling.md
		sed -i "s#http8080: .*#http8080: ${addr_web8080} #g" $ruta/tunneling.md
		sed -i "s#http3000: .*#http3000: ${addr_web3000} #g" $ruta/tunneling.md
		
		existDiff=$(cd $ruta && git diff --name-only tunneling.md)
		
		if [ "$existDiff" = "tunneling.md" ]
		then 
			echo "pushing to github"
			(cd $ruta && git add . && git commit -m "update ngrok urls $(date)" && git push)
		else 
			echo "no need to push"
		fi
		
	else
		echo "Opss, Cant get tunnel Info"
	fi
}

(cd $ruta && git pull)

TheText="Hey buddy reboot ngrok, please!"

TheRequest=$(head -n 1 $ruta/Request.txt)

if [ "$TheText" = "$TheRequest" ]
then
	:> $ruta/Request.txt
	echo "Forced Restart from Github"
    	ngrok start -all > /dev/null &
	sleep 3s
	tunnelInfoNgrok
fi

if [ "$(pidof ngrok)" ]
then
	echo "Already running, check update anyway"
	tunnelInfoNgrok
else
	echo "Not running... setting up"
    	ngrok start -all > /dev/null &
	sleep 3s
	tunnelInfoNgrok
fi

echo "/////////////////////////////////////////////////////"

#! /bin/bash
# Update firewall Regeln wenn Dynamische IP sich ändert
# Autor: Henry Rausch
# Datum: 2020-05-01
# Version: 1.0

# Variablen
# alte IP aus Datei lesen
oldip=$(cat /root/ip.txt)
# neue IP auslesen
newip=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Prüfen ob sich die IP geändert hat
if [ "$oldip" != "$newip" ]; then
        # IP geändert
        echo "IP geändert"
        # alte IP in Datei schreiben
        echo $newip > /root/ip.txt
        # Firewall Regeln aktualisieren Postrausch.tech
        hcloud context use Postrausch.tech
        hcloud firewall delete-rule postrausch_firewall --description="SSH" --direction=in --port=22 --protocol=tcp --source-ips=$oldip/32
        hcloud firewall add-rule postrausch_firewall --description="SSH" --direction=in --port=22 --protocol=tcp --source-ips=$newip/32
        # Firewall Regeln aktualisieren femininempowerment.de
        hcloud context use femininempowerment.de
        hcloud firewall delete-rule firewall --description="SSH" --direction=in --port=22 --protocol=tcp --source-ips=$oldip/32
        hcloud firewall add-rule firewall --description="SSH" --direction=in --port=22 --protocol=tcp --source-ips=$newip/32
else
        # IP nicht geändert
        echo "IP nicht geändert"
fi

#! /bin/bash

if [ "$#" -ne 1 ]; then
	echo "Please give the name of the user in paramter"
	exit -1
fi

echo "Ajout de l'utilisateur $1"

adduser "$1"

#Permission


#Creation de l'id


#Enregistrement d'un listener sur son home



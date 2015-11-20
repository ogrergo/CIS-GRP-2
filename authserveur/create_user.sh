#! /bin/bash

if [ "$#" -ne 1 ]; then
	echo "Please give the name of the user in paramter"
	exit -1
fi

echo "Ajout de l'utilisateur $1"

adduser "$1"

#Permission


#Creation de l'id
if [ -e /etc/user_count ]
then
	INDEX=$(cat /etc/user_count)
else
	INDEX=0
fi

if [[ ! $INDEX =~ ^[0-9]+$ ]]
then
	INDEX=0
else
	INDEX=$(($INDEX + 1))
fi

echo -n "$INDEX" > /etc/user_count

echo "$1:$INDEX" >> /etc/user_map

#Enregistrement d'un listener sur son home



#!/bin/bash

#Script permettant d'uploader des documents sur transfer.sh via un navigateur de fichiers supportant les scripts bash.
#Limitation de l'envoi à 5Go (limite de transfer.sh)
#Auteur : Non0w
#http://chocolicornes.org/non0w/

# séparateur d'arguments = retour chariot
IFS='
'

#Au moins 1 fichier sélectionné
if [ -n "$*" ]; then
    
    #Itère sur tous les fichiers
    for arg
    do
	#Dossier ?
	if [ -d "$arg" ]; then
	    zenity --error --title="transfer.sh -- Échec de l'envoi" --text "L'envoi de dossier est impossible.\n\n($arg)"
	    
	#Existe ?	    
	elif [ -f "$arg" ]; then
	    maxsize=5000000000
	    filesize=$(stat -c%s "$arg")
	    
	    #Taille ?
	    if [ $filesize -gt $maxsize ]; then
		zenity --error --title="transfer.sh -- Échec de l'envoi" --text "L'envoi est limité à $maxsize octets.\n\n($arg  = $filesize octets)"
		
	    #Envoi
	    else
		
		#Si réussi
		link=$(curl --upload-file "$arg" "https://transfer.sh/$arg")
		if [ $link ]; then
		    zenity --info --title=transfer.sh --text "Envoi de $arg réussi, copiez ce lien afin de le partager :\n\n$link"
		    
		#Si échoué
		else
		    zenity --error --title="transfer.sh -- Échec de l'envoi" --text "Impossible d'accéder au fichier $arg ou à transfer.sh."
		fi
	    fi
	fi
    done
    
#Aucun fichier sélectionné
else
    zenity --error --title="transfer.sh -- Échec de l'envoi" --text "Aucun fichier sélectionné."
fi

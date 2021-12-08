#!/bin/bash

# Affichage de la liste des fichiers
cheminfichier="$(dirname $0)/fichierdebase/monfichier.dart"
cheminroute="$(dirname $0)/fichierdebase/nouvelleroute.dart"

#Ben Voyons !
touch hehe.dart
cat $cheminfichier > hehe.dart
# On lit le fichier + On enlève tous les retour à la ligne
# nouvelleroute=`cat $cheminroute | tr -d '\n'`
# nouvelleroute="$nouvelleroute //insert-route"
# sed -i -e "s~//insert-route~$nouvelleroute~g" hehe.dart
# sed -i -e "s~AZER~$1~g" hehe.dart
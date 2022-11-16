#!/bin/bash

#Fonctions
capitalize() {
    str=$1
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${str:0:1})${str:1}"
}

toUnderscore() {
    str=$1
    echo "${str//-/_}"
}

toSpace() {
    str=$1
    echo "${str//-/ }"
}

deleteSpace() {
    str=$1
    echo "${str// /}"
}

#Nom des fichiers
nomDossier=`toUnderscore $1`
nomFichier="$nomDossier.dart"
nomClasse=`toSpace $1`; nomClasse=$(for i in $nomClasse; do echo -n `capitalize $i`; done); 

#Vérifie s'il on a le nom de la page
echo "Nouvelle page en cour de création ... $nomClasse"
if [ $# -ne "1" ] && [ $# -ne "2" ]; then
    echo "/!\ Veuillez entrer le nom pour la page et le chemin"
    exit 1
fi

#AJOUT DU ROUTER
cheminFichierRef="$(dirname $0)/fichierdebase/nouvelleroute.dart"
cheminRouter="./lib/presentation/core/_core/router.dart"
codeRoute=`cat $cheminFichierRef | tr -d '\n'`
codeRoute="$codeRoute //insert-route"

#Vérifie qu'il y a le insert-route
he=`grep -c "//insert" $cheminRouter`
if [ $he -eq "0" ]; then
    echo "/!\ Echec ! Pas de insert-route dans $cheminRouter"
    exit 1
fi

#Vérifie que la route n'existe pas déjà
he=`grep -c $nomClasse $cheminRouter`
if [ $he -eq "0" ]; then
    #Ajout de la route
    sed -i -e "s~//insert-route~$codeRoute~g" $cheminRouter
    sed -i -e "s~AZER~$nomClasse~g" $cheminRouter
    sed -i -e "s~azer~$1~g" $cheminRouter
    echo "Ajout de la route"
fi



# CREATION DE LA PAGE DANS PRESENTATION
cheminPage="./lib/presentation/$2/$nomDossier"
if [ ! $2 ]; then
    cheminPage="./lib/presentation/$nomDossier"
fi
mkdir -vp $cheminPage
mkdir "$cheminPage/widget"
touch "$cheminPage/$nomFichier"
echo "Création des fichiers de la page"

cheminNouvellePageRef="$(dirname $0)/fichierdebase/nouvellepage.dart"

cat $cheminNouvellePageRef > "$cheminPage/$nomFichier"
sed -i -e "s~AZER~$nomClasse~g" "$cheminPage/$nomFichier"
sed -i -e "s~nouvelle-page~$nomClasse~g" "$cheminPage/$nomFichier"
echo "Ajout du code dans la page principale"

#Nettoyage
rm -f $cheminPage/*.dart-e
rm -f ./lib/presentation/core/*.dart-e
echo "Nettoyage des fichiers dart-e"

#flutter pub run build_runner build --delete-conflicting-outputs
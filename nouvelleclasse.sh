#!/bin/bash

#Fonctions
capitalize() {
    str=$1
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${str:0:1})${str:1}"
}

firtLetterMaj() {
    str=$1
    echo "$(tr '[:upper:]' '[:lower:]' <<< ${str:0:1})${str:1}"
}

to_lowercase() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

toUnderscore() {
    str=$1
    echo "${str//-/_}"
}

toSpace() {
    str=$1
    echo "${str//-/ }"
}

toSpaceFromUnderscore() {
    str=$1
    echo "${str//_/ }"
}

deleteSpace() {
    str=$1
    echo "${str// /}"
}

classeToDTOParam() {
    case $1 in
        "DateTime" | "int")
            echo "int"
            ;;
        *)
            echo "String"
            ;;
    esac
}

#Nom des fichiers
nomDossier=`toUnderscore $1`
nomDossier=`to_lowercase $nomDossier`
nomFichier="$nomDossier.dart"
nomClasse=`toSpace $1`; nomClasse=$(for i in $nomClasse; do echo -n `capitalize $i`; done);
nomObjet=`firtLetterMaj $nomClasse`

#Vérifie les paramètres
echo "Nouvelle objet en cours de création ..."
if [ $# -ne "1" ]; then
    echo "/!\ Veuillez entrer un nom pour la classe à Dallas"
    exit 1
fi

#Remplir les nom de la classe
echo "Ex : Nom-nom DateTime-datelimite String-surnom UniqueId-idParent"
param="a"
# listParams=(Nom-nom Nom-prenom DateTime-datedenaissance String-jesaispas UniqueId-proprio)
listParams=()
while [ ! $param = "x" ]
do
    read -p 'Entrez un paramètre (x pour arrêter): ' param
    if [ ! $param = "x" ]; then
        listParams+=($param)
    fi
done

printf '%s\n' "${listParams[@]}"





########     DOMAIN    #########

# [DOMAIN] CREATION DE LA CLASSE
cheminPageDomain="./lib/DOMAIN/$nomDossier"
mkdir -vp $cheminPageDomain
touch "$cheminPageDomain/$nomFichier"

cat $(dirname $0)/fichierdebase/objet.dart > "$cheminPageDomain/$nomFichier"
sed -i -e "s~AZER~$nomClasse~g" "$cheminPageDomain/$nomFichier"
sed -i -e "s~objet-freezed~$nomDossier~g" "$cheminPageDomain/$nomFichier"

codeParam=""
codeEmptyParam=""
for i in "${listParams[@]}"
do
    #Code Param
    parametre=`toSpace $i`
    codeParam+="required $parametre,"

    #Code Empty Param
    array=($parametre)
    typevariable=${array[0]}
    case $typevariable in 
        "String")
            typevariable="''"
            ;;
        "int")
            typevariable=0
            ;;
        "UniqueId")
            typevariable="$typevariable()"
            ;;
        "Nom" | "Description" | "EmailAddress" | "Password")
            typevariable="$typevariable('')"
            ;;
        "DateTime")
            typevariable="$typevariable.now()"
            ;;
        *)
            typevariable="$typevariable()"
            ;;
    esac
    codeEmptyParam+="${array[1]}: $typevariable,"
done
sed -i -e "s~//insert-default-params~$codeParam~g" "$cheminPageDomain/$nomFichier"
sed -i -e "s~//insert-object-params~$codeEmptyParam~g" "$cheminPageDomain/$nomFichier"
echo "Création de $cheminPageDomain/$nomFichier"

# [DOMAIN] CREATION CLASSE FAILURE
nomFichierFailure="${nomDossier}_failure.dart"
cheminPageDomain="./lib/DOMAIN/$nomDossier"
touch "$cheminPageDomain/$nomFichierFailure"

cat $(dirname $0)/fichierdebase/objet_failures.dart > "$cheminPageDomain/$nomFichierFailure"
sed -i -e "s~AZER~$nomClasse~g" "$cheminPageDomain/$nomFichierFailure"
sed -i -e "s~insert-freezed~$nomDossier~g" "$cheminPageDomain/$nomFichierFailure"
echo "Création de $cheminPageDomain/$nomFichierFailure"

# [DOMAIN] CREATION CLASSE VALUE_OBJECT
nomFichierFailure="value_objects.dart"
cheminPageDomain="./lib/DOMAIN/$nomDossier"
touch "$cheminPageDomain/$nomFichierFailure"



########     INFRASTRUCTURE    #########

# [INFRASTRUCTURE] CREATION DU DTO
cheminPageInfra="./lib/INFRASTRUCTURE/$nomDossier"
cheminFichierInfra="$cheminPageInfra/${nomDossier}_dtos.dart"
mkdir -vp $cheminPageInfra
touch $cheminFichierInfra

cat $(dirname $0)/fichierdebase/objet_dtos.dart > $cheminFichierInfra
sed -i -e "s~AZER~$nomClasse~g" $cheminFichierInfra
sed -i -e "s~objet-freezed-dtos~${nomDossier}_dtos~g" $cheminFichierInfra

codeParam=""
codeParamFromDomain=""
codeParamToDomain=""
for i in "${listParams[@]}"
do
    #Code Param
    parametre=`toSpace $i`
    array=($parametre)
    typevariabledto=`classeToDTOParam ${array[0]}`
    codeParam+="required $typevariabledto ${array[1]},"

    #Code Param From Domain
    objget="obj.variable.getOrCrash()"
    case ${array[0]} in
        "String" | "int" )
            objget="obj.${array[1]}"
            ;;
        "DateTime")
            objget="obj.${array[1]}.millisecondsSinceEpoch"
            ;;
        *)
            objget="obj.${array[1]}.getOrCrash()"
            ;;
    esac
    codeParamFromDomain+="${array[1]}: $objget,"
    
    #Code Param To Domain
    typevariable=${array[0]}
    case $typevariable in 
        "String" | "int")
            typevariable="${array[1]}"
            ;;
        "UniqueId")
            typevariable="UniqueId.fromUniqueString(${array[1]})"
            ;;
        "DateTime")
            typevariable="$typevariable.fromMillisecondsSinceEpoch(${array[1]})"
            ;;
        *)
            typevariable="$typevariable(${array[1]})"
            ;;
    esac
    codeParamToDomain+="${array[1]}: $typevariable,"
done
sed -i -e "s~nom_fichier~$nomDossier~g" "$cheminFichierInfra"
sed -i -e "s~//insert-param-dto~$codeParam~g" "$cheminFichierInfra"
sed -i -e "s~//insert-param-fromdomain~$codeParamFromDomain~g" "$cheminFichierInfra"
sed -i -e "s~//insert-param-todomain~$codeParamToDomain~g" "$cheminFichierInfra"
echo "Création de $cheminFichierInfra"

# [INFRASTRUCTURE] CREATION DU REPOSITORY
cheminFichierInfra="$cheminPageInfra/${nomDossier}_repository.dart"
touch $cheminFichierInfra

cat $(dirname $0)/fichierdebase/objet_repository.dart > $cheminFichierInfra
sed -i -e "s~AZER~$nomClasse~g" $cheminFichierInfra
sed -i -e "s~azer~$nomObjet~g" $cheminFichierInfra
sed -i -e "s~az_er~$nomDossier~g" $cheminFichierInfra

echo "Création de $cheminFichierInfra"

# [INFRASTRUCTURE] MIS A JOUR DE FIRESTORE_HELPER
chemin="./lib/INFRASTRUCTURE/core/firestore_helpers.dart"
#Vérifie qu'il y a le insert-collection
grep -q "//insert-collection" $chemin
if [ ! $? ]; then
    echo "/!\ Echec ! Pas de insert-collection dans $chemin"
else
    hee=`grep $nomObjet $chemin`
    echo "hee => ${#hee}"
    if [ ! ${#hee} -gt "1" ]
    then
        code="CollectionReference get ${nomObjet}Collection => collection('$nomObjet');\n//insert-collection"
        sed -i -e "s~//insert-collection~$code~g" $chemin
        echo "Mis à jour de $chemin"
    fi
fi






########     APPLICATION    #########

# [APPLICATION] CREATION FORMULAIRE AJOUT
read -p 'Voulez vous ajouter une page ? (y: oui) ' pageAjout
read -p 'Voulez vous ajouter un formulaire d ajout ? (y: oui) ' formulaireAjout

if [ $pageAjout = "y" ]; then
    if [ $formulaireAjout = "y" ]; then
        nomFichierAddObjetNotifier="add_${nomDossier}_form_notifier.dart"
        cheminPageApplication="./lib/APPLICATION/$nomDossier"
        mkdir -vp $cheminPageApplication
        touch "$cheminPageApplication/$nomFichierAddObjetNotifier"

        cat $(dirname $0)/fichierdebase/add_objet_form_notifier.dart > "$cheminPageApplication/$nomFichierAddObjetNotifier"
        sed -i -e "s~AZER~$nomClasse~g" "$cheminPageApplication/$nomFichierAddObjetNotifier"
        sed -i -e "s~azer~$nomObjet~g" "$cheminPageApplication/$nomFichierAddObjetNotifier"
        sed -i -e "s~az_er~$nomDossier~g" "$cheminPageApplication/$nomFichierAddObjetNotifier"
        sed -i -e "s~insert_freezed~$nomDossier~g" "$cheminPageApplication/$nomFichierAddObjetNotifier"


        # Ajout d'un système 
        for i in "${listParams[@]}"
        do
            #Code paramChanged(String param)
            parametre=`toSpace $i`
            array=($parametre)
            typevariableparametre=`classeToDTOParam ${array[0]}`
            valueChanged=${array[0]}
            case ${array[0]} in 
                "String" | "int")
                    valueChanged="param"
                    ;;
                "Nom" | "Description" | "EmailAddress" | "Password")
                    valueChanged="${array[0]}(param)"
                    ;;
                "UniqueId")
                    valueChanged="UniqueId.fromUniqueString(param)"
                    ;;
                "DateTime")
                    valueChanged="DateTime.fromMillisecondsSinceEpoch(param)"
                    ;;
                "State")
                    valueChanged="State.fromString(param)"
                    ;;
                *)
                    valueChanged="${array[0]}(param)"
                    ;;
            esac
            paramChanged="${array[1]}Changed($typevariableparametre param) {state = state.copyWith($nomObjet: state.$nomObjet.copyWith(${array[1]}: $valueChanged),authFailureOrSuccessOption: none());}\n//insert-changed"
            sed -i -e "s~//insert-changed~$paramChanged~g" "$cheminPageApplication/$nomFichierAddObjetNotifier"

            #final isTitreValid = state.maGazolina.titre.isValid();
            if [ ${array[0]} = "Nom" ] || [ ${array[0]} = "Description" ] || [ ${array[0]} = "EmailAddress" ] || [ ${array[0]} = "Password" ]; then
                codeParamValid="final is${array[1]}Valid = state.$nomObjet.${array[1]}.isValid();\n//insert-valid-params"
                codeCondition="/* insert-valid-condition */ || is${array[1]}Valid"
                sed -i -e "s~//insert-valid-params~$codeParamValid~g" "$cheminPageApplication/$nomFichierAddObjetNotifier"
                sed -i -e "s~/\* insert-valid-condition \*/~$codeCondition~g" "$cheminPageApplication/$nomFichierAddObjetNotifier"
            fi
        done

        echo "Creation de $cheminPageApplication/$nomFichierAddObjetNotifier"
    fi





    ########     PRESENTATION    #########

    mkdir $nomDossier
    # [PRESENTATION] FORM D'AJOUT
    if [ $formulaireAjout = "y" ]; then
        mkdir "$nomDossier/${nomDossier}_add"
        nouvellepage.sh "$1-add" "./$nomDossier"
        code="${nomClasse}FormProvider()"
        chemin="./lib/PRESENTATION/$nomDossier/${nomDossier}_add/${nomDossier}_add_page.dart"
        sed -i -e "s~Text('insert-code')~$code~g" $chemin
        echo "import 'widget/${nomDossier}_form.dart';" | cat - $chemin > temp && mv temp $chemin

        # Formulaire
        fichierForm="./lib/PRESENTATION/$nomDossier/${nomDossier}_add/widget/${nomDossier}_form.dart"
        touch $fichierForm
        cat $(dirname $0)/fichierdebase/objet_form.dart > $fichierForm
        for i in "${listParams[@]}"
        do
            #Code paramChanged(String param)
            parametre=`toSpace $i`
            array=($parametre)
            typevariableparametre=`classeToDTOParam ${array[0]}`

            case ${array[0]} in 
                "String" | "int" | "UniqueId" | "DateTime")
                    ;;
                *)
                    code=`cat $(dirname $0)/fichierdebase/objet_form_field.dart`
                    KEYWORD="//insert-field-complete"
                    ESCAPED_KEYWORD=$(printf '%s\n' "$KEYWORD" | sed -e 's/[]\/$*.^[]/\\&/g');
                    ESCAPED_REPLACE=$(printf '%s\n' "$code" | sed -e 's/[]\/$*.^[]/\\&/g');
                    ESCAPED_REPLACE="${ESCAPED_REPLACE//[$'\t\r\n']}"
                    sed -i -e "s/$ESCAPED_KEYWORD/$ESCAPED_REPLACE/g" $fichierForm
                    sed -i -e "s~insert-field-name~${array[1]}~g" $fichierForm
                    ;;
            esac
        done
        sed -i -e "s~AZER~$nomClasse~g" $fichierForm
        sed -i -e "s~azer~$nomObjet~g" $fichierForm
        sed -i -e "s~az_er~$nomDossier~g" $fichierForm

        echo "Creation de $fichierForm"
    fi

    # [PRESENTATION] AFFICHAGE LIST
    mkdir "$nomDossier/${nomDossier}_list"
    nouvellepage.sh "$1-list" "./$nomDossier"
    chemin="./lib/PRESENTATION/$nomDossier/${nomDossier}_list/${nomDossier}_list_page.dart"
    cat $(dirname $0)/fichierdebase/objet_list.dart > $chemin
    echo "import 'widget/panel_${nomDossier}_view.dart';" | cat - $chemin > temp && mv temp $chemin
    sed -i -e "s~AZER~$nomClasse~g" $chemin
    sed -i -e "s~azer~$nomObjet~g" $chemin
    sed -i -e "s~az_er~$nomDossier~g" $chemin

    # List
    fichierForm="./lib/PRESENTATION/$nomDossier/${nomDossier}_list/widget/panel_${nomDossier}_view.dart"
    touch $fichierForm
    cat $(dirname $0)/fichierdebase/panel_objet_view_compact.dart > $fichierForm

    for i in "${listParams[@]}"
    do
        parametre=`toSpace $i`
        array=($parametre)

        objget="variable.getOrCrash()"
        case ${array[0]} in
            "String" | "int" )
                objget="${array[1]}"
                ;;
            "DateTime")
                objget="${array[1]}.toString()"
                ;;
            *)
                objget="${array[1]}.getOrCrash()"
                ;;
        esac

        code="Text(\"${array[1]} : \$\{azer.${objget}\}\", style: Theme.of(context).textTheme.bodyMedium),\n//insert-info"
        sed -i -e "s~//insert-info~$code~g" $fichierForm
    done
    sed -i -e "s~AZER~$nomClasse~g" $fichierForm
    sed -i -e "s~azer~$nomObjet~g" $fichierForm
    sed -i -e "s~az_er~$nomDossier~g" $fichierForm

    # [PRESENTATION] AFFICHAGE DETAIL D'UN ELEMENT
    mkdir "$nomDossier/${nomDossier}_view"
    nouvellepage.sh "$1-view" "./$nomDossier"
    chemin="./lib/PRESENTATION/$nomDossier/${nomDossier}_view/${nomDossier}_view_page.dart"
    cat $(dirname $0)/fichierdebase/objet_view.dart > $chemin
    echo "import 'widget/panel_${nomDossier}_view.dart';" | cat - $chemin > temp && mv temp $chemin
    sed -i -e "s~AZER~$nomClasse~g" $chemin
    sed -i -e "s~azer~$nomObjet~g" $chemin
    sed -i -e "s~az_er~$nomDossier~g" $chemin

    # view
    fichierForm="./lib/PRESENTATION/$nomDossier/${nomDossier}_view/widget/panel_${nomDossier}_view.dart"
    touch $fichierForm
    cat $(dirname $0)/fichierdebase/panel_objet_view_detail.dart > $fichierForm

    for i in "${listParams[@]}"
    do
        parametre=`toSpace $i`
        array=($parametre)

        objget="variable.getOrCrash()"
        case ${array[0]} in
            "String" | "int" )
                objget="${array[1]}"
                ;;
            "DateTime")
                objget="${array[1]}.toString()"
                ;;
            *)
                objget="${array[1]}.getOrCrash()"
                ;;
        esac

        code="Text(\"${array[1]} : \$\{azer.${objget}\}\", style: Theme.of(context).textTheme.labelLarge),\n//insert-info"
        sed -i -e "s~//insert-info~$code~g" $fichierForm
    done
    sed -i -e "s~AZER~$nomClasse~g" $fichierForm
    sed -i -e "s~azer~$nomObjet~g" $fichierForm
    sed -i -e "s~az_er~$nomDossier~g" $fichierForm
fi

########     PROVIDER    #########
hee=`grep -c $nomObjet ./lib/providers.dart`
if [ $hee -eq "0" ]
then
    code="//$nomClasse \n\n //insert-provider"
    sed -i -e "s~//insert-provider~$code~g" "./lib/providers.dart"
    code="final ${nomObjet}RepositoryProvider = Provider<I${nomClasse}Repository>((ref) => getIt<I${nomClasse}Repository>()); \n\n //insert-provider"
    sed -i -e "s~//insert-provider~$code~g" "./lib/providers.dart"
    if [ $formulaireAjout = "y" ]; then
        code="final ${nomObjet}FormNotifierProvider = \nStateNotifierProvider.autoDispose<${nomClasse}FormNotifier, Add${nomClasse}FormData>(\n(ref) => ${nomClasse}FormNotifier(ref.watch(${nomObjet}RepositoryProvider)),\n);\n\n//insert-provider"
        sed -i -e "s~//insert-provider~$code~g" "./lib/providers.dart"
    fi
    code="final all${nomClasse}Provider = StreamProvider.autoDispose<Either<${nomClasse}Failure, List<${nomClasse}>>>((ref) => ref.watch(${nomObjet}RepositoryProvider).watch());\n\n//insert-provider"
    sed -i -e "s~//insert-provider~$code~g" "./lib/providers.dart"
    code="final one${nomClasse}Provider = FutureProvider.autoDispose.family<Either<${nomClasse}Failure, ${nomClasse}>, UniqueId>((ref, id) => ref.watch(${nomObjet}RepositoryProvider).watchWithId(id));\n\n//insert-provider"
    sed -i -e "s~//insert-provider~$code~g" "./lib/providers.dart"
fi

# Nettoyage
rm -f $cheminPageDomain/*.dart-e
rm -f $cheminPageInfra/*.dart-e
rm -f $cheminPageApplication/*.dart-e
rm -f ./lib/INFRASTRUCTURE/core/*.dart-e
rm -f ./lib/PRESENTATION/$nomDossier/*.dart-e
rm -f ./lib/PRESENTATION/$nomDossier/${nomDossier}_add/*.dart-e
rm -f ./lib/PRESENTATION/$nomDossier/${nomDossier}_add/widget/*.dart-e
rm -f ./lib/PRESENTATION/$nomDossier/${nomDossier}_list/*.dart-e
rm -f ./lib/PRESENTATION/$nomDossier/${nomDossier}_list/widget/*.dart-e
rm -f ./lib/PRESENTATION/$nomDossier/${nomDossier}_view/*.dart-e
rm -f ./lib/PRESENTATION/$nomDossier/${nomDossier}_view/widget/*.dart-e
rm -f ./lib/*.dart-e


echo "##################################################"
echo "1. Changez 'base_de_projet' par le nom du projet"
echo "2. Faire les imports dans provider"
echo "3. lancer la commande 'dart run'"
echo "4. Faire les imports dans presentation/core/_core/router"
echo "##################################################"

#flutter pub run build_runner build --delete-conflicting-outputs
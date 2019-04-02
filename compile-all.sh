#!/bin/bash

function help() {
	echo "Usage $0 [OPTIONS]"
	echo
	echo "Génère le mips dans generatedMips"
	echo
	echo "Options"
	echo -e "\t--quiet, -q   : N'affiche que le minimum, implique --test"
	echo -e "\t--test, -t    : Mode test, affiche les fichiers invalides et éxécute les fichiers valides"
	echo -e "\t--simple, -s  : N'éxécute pas le mips généré"
	echo -e "\t--verbose, -v : Affiche ce qu'il est en train de faire"
	echo -e "\t--timeout, -i val : Set le timeout de l'éxécution"
	echo -e "\t--help, -h    : Affiche cette aide"
	echo
	echo "Constantes à modifier dans le script"
	echo -e "\tdir : Expression régulière listant tous vos fichiers plic ou repertoire contenant vos fichiers plic"
	echo -e "\tmars : Chemin vers le jar Mars"
	echo -e "\trun_cmd : Commande à éxécuter pour lancer votre .jar"
	echo
	echo
}


 #Config
dir="sources/*.plic"
mars="Mars4_5.jar"
run_cmd="java -jar plic.jar"

test=0
quiet=0
verbose=0
simple=0
timeout=5

while [ $# -gt 0 ]
do
	arg=$1
	shift
	if [ $arg == --simple ] || [ $arg == -s ]
	then
		simple=1
	elif [ $arg == --quiet ] || [ $arg == -q ]
	then
		quiet=1
		test=1
	elif [ $arg == --test ] || [ $arg == -t ]
	then
		test=1
	elif [ $arg == --verbose ] || [ $arg == -v ]
	then
		verbose=1
	elif [ $arg == --help ] || [ $arg == -h ]
	then
		help
		exit 0
	elif [ $# -ge 1 ] && [ $arg == --timeout -o $arg == -i ]
	then
		timeout=$1
		shift
	else
		echo "Option inconnue : $arg"
		exit 1
	fi
done

passe=0
erreur=0
failed=0

if test ! -d generatedMips
then
	mkdir generatedMips
fi

i=0
nb=$(ls $dir|wc -l)
for file in $(ls $dir)
do
	i=$(($i+1))
	[ $quiet -eq 0 ] && echo -n "[ $i / $nb ]                   "
	[ $quiet -eq 0 ] && echo -ne "\r"

	[ $verbose -eq 1 ] && echo "Compilation de $(basename $file)"
	res=$($run_cmd $file|sed s/\\x00//g)
	outFile=generatedMips/$(basename $file .plic).mips

	if echo "$res"|grep -v "^ERREUR:">/dev/null
	then
		status=VALIDE
		passe=$(($passe + 1))
		echo "$res">$outFile
	else
		status=INVALIDE
		erreur=$(($erreur + 1))
	fi

	correct=ERREUR
	estTestFaux=$([ -n "$(echo $file|grep --ignore-case faux)" ] && echo 1)
	if [ $status != "INVALIDE" -o "$estTestFaux" == 1 ] && [ $status != "VALIDE" -o -z "$estTestFaux" ]
	then
		correct=PASSE
	else
		failed=$(($failed + 1))
	fi

	if [ $correct == PASSE ] && [ $status == VALIDE ] && [ $test -eq 1 ] && [ $simple -eq 0 ]
	then
		[ $verbose -eq 1 ] && echo "Évaluation de $(basename $outFile)"

		input=$(cat $file|sed s/\\x00//g|grep //INPUT:|sed 's/INPUT://g'|sed 's/\/\/ *//g')
		[ $verbose -eq 1 ] && echo "Input : $input"

		run=$(echo $input|timeout $timeout java -jar $mars nc $outFile|sed 's/\n//g')
		ret=$?
		check=$(cat $file|cut -d '}' -f $(($(grep -c '}' $file) + 1)) -z|sed s/\\x00//g|grep //|grep -v INPUT:|sed 's/\/\/ *//g')

		[ $verbose -eq 1 ] && echo Attendu : $check
		[ $verbose -eq 1 ] && echo Obtenu : $run

		if [ "$check" == "ERREUR" -a -n "$(echo $run|grep ERREUR:)" ]
		then
			erreurCorrect=1
		else
			erreurCorrect=0
		fi



		if [ "$run" != "$check" ] && [ $erreurCorrect -ne 1 ]
		then
			 failed=$(($failed + 1))
			 correct=ERREUR_EXEC
		fi
		if [ $ret -ne 0 ]
		then
			failed=$(($failed + 1))
			correct=ERREUR_TIMEOUT
		fi
	fi

	if [ $quiet -eq 0 ]
	then
		[ $test -eq 0 -o $correct != PASSE ] && echo $correct $status $file
		if [ $test -eq 0 ] || [ $correct == ERREUR -a $status == INVALIDE ]
		then
			$run_cmd $file
			echo
		fi
		if [ $correct == ERREUR_EXEC ]
		then
			echo Attendu : $check
			echo Obtenu : $run
		fi
	elif [ $correct != PASSE ]
	then
		echo $correct $file
	fi
done

echo $failed ERREURS, $passe COMPILENT, $erreur NE COMPILENT PAS

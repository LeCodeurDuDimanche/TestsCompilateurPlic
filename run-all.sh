#!/bin/bash

mars=Mars4_5.jar
sources=sources/

onlyOutput=0

if test $# -gt 0
then
	if test $1 == "--only-output"
	then
		onlyOutput=1
		shift
	fi
	if test $# -eq 0
	then
		echo "Usage $0 [--only-output filename|filenames]"
		exit 1
	fi 
	files=$*
else
	files=generatedMips/*.mips
fi

for file in $(ls $files)
do
	if test $onlyOutput -eq 0
	then
		nom=$(basename $file .mips)
		source=$sources$nom.plic

		echo
		echo $nom
		echo

		if test -f "$source"
		then
			cat $source
		else
			echo FICHIER INTROUVABLE
		fi
		echo
	fi

	java -jar $mars nc $file
done

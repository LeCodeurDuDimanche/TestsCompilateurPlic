#!/bin/bash
noms='-AD=Adrien Duval
-LC=Luc Cheng
-MG=Martine Gautier
-OL=Oscar Leclerc
-VC=Vincent Choquert
-VG=Vanessa Geny
'

for num in $(basename -a sources/*.plic|cut -f 1 -d _|uniq -c|sort -rn|tr -s ' ' '_')
do
	nom=$(echo $num|cut -d '_' -f 3)
	alias=$(echo $noms|tr -s '-' '\n'|grep $nom|cut -d '=' -f 2)
	num=$(echo $num|cut -d '_' -f 2)
	
	faux=$(ls sources/|grep $nom|grep -c --ignore-case faux) 
	if [ $num -gt 1 ] 
	then 
		s=s
	else 
		s=
	fi
	printf "%-20s: %d test%s écrit%s, donc %d test%s d'erreur\n" "$alias" "$num" "$s" "$s" "$faux" "$s"
done

num=$(ls sources/*.plic|wc -l)
faux=$(ls sources/*.plic|grep -c --ignore-case faux)

echo
echo "Au total $num tests écrits dont $faux tests d'erreur"
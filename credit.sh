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
	
	if [ $num -gt 1 ] 
	then 
		testEcrit='tests écrits'
	else 
		testEcrit='test écrit'
	fi
	printf '%-20s: %d %s\n' "$alias" "$num" "$testEcrit"
done

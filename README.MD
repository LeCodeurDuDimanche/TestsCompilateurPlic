Fichiers plics et scripts de test
---------------------------------

Les fichiers plics sont dans le repertoire sources/

Pour que les scripts de test marchent correctement :

- Ajouter faux dans le nom du fichier s'il contient des erreurs de compilation

- Ajouter en commentaires après le programme le résultat de l'éxécution s'il est censé
compilé

- Ça serait cool dans le nom ou et commentaire dans le fichier de dire pourquoi il ne
devrait pas compiler (si c'est le cas)



Le script bash compile-all.sh permet de compiler et de tester le compilateur

- Copier votre fichier plic.jar dans le repertoire (ou alors faites un lien)

- Lancer ./compile-all.sh -t pour lancer les tests (l'option --help affiche toutes les
options)

- Les fichier mips sont générés dans le répertoire generatedMips/



Le script run-all.sh permet d'éxécuter vos fichiers mips (il prend en argument des noms de fichier
à éxécuter, ou rien pour tout éxécuter)

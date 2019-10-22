# Tests automatisés pour un compilateur

Le compilateur compile du PLIC, langage inventé pour le projet, vers de l'assembleur MIPS.

Les fichiers de tests sont des fichiers PLIC valides ou invalides, écrits par plusieurs élèves de la classe (lancer `./credits.sh` pour plus d'informations).

Une version du compilateur que j'avais produit se trouve dans le dépôt afin de pouvoir faire marcher les tests.


## Utilisation

Fichiers plics et scripts de test
---------------------------------

Les fichiers plics sont dans le repertoire sources/

Pour que les scripts de test marchent correctement :

- Ajouter faux dans le nom du fichier s'il contient des erreurs de compilation

- Ajouter en commentaires après le programme le résultat de l'éxécution s'il est censé
compiler (ou ERREUR si le programme doit planter)

- Ajouter en commentaire les inputs du programme, dans l'ordre, précédés de INPUT: (peuvent être répartis un peu partout)

- Ça serait cool dans le nom ou et commentaire dans le fichier de dire pourquoi il ne
devrait pas compiler (si c'est le cas)



Le script bash compile-all.sh permet de compiler et de tester le compilateur

- Copier votre fichier plic.jar dans le repertoire (ou alors faites un lien)

- Lancer ./compile-all.sh -t pour lancer les tests (l'option --help affiche toutes les
options)

- Les fichier mips sont générés dans le répertoire generatedMips/


Lire le résultat d'un test :
[PASSE|ERREUR|ERREUR_EXEC|ERREUR_TIMEOUT] [VALIDE|INVALIDE] nomFichier

PASSE 		: Le test passe

ERREUR		: Le test ne passe pas (soit le fichier devrait compiler et ne compile pas, auquel cas l'erreur obtnue est affichée, soit le fichier compile mais ne devrait pas)

ERREUR_EXEC	: Le test ne passe pas à l'éxécution, les résultats obtenu et attendu sont affichés

ERREUR_TIMEOUT  : Le test ne passe pas à l'éxécution car le code génère une boucle infinie non
prévue



VALIDE 		: Le fichier compile avec votre compilateur

INVALIDE	: Le fichier ne compile pas avec votre compilateur

A la fin, le nombre de tests échouant est affichés (de plus le nombre de fichier passant la compilation ou non sont affichés, pour info seulement)

Le script run-all.sh permet d'éxécuter vos fichiers mips (il prend en argument des noms de fichier
à éxécuter, ou rien pour tout éxécuter), il affiche le fichier plic correspondant

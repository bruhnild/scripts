# Commandes git

## Commiter et pousser
```sh
$ git status
$ git add --all 
$ git commit -m "mon commentaire"
$ git push origin master
```

## Créer une branche
```sh
$ git pull (récupère toutes les modifications de la branches courante)
$ git checkout -b manouvellebranche (crée la nouvelle branche)
```

## Se positionner sur une nouvelle branche
```sh
$ git checkout manouvellenouvelle
```

## Rebaser une branche

```sh
$ git checkout manouvellebranche
$ git rebase master
$ git push --force origin manouvellebranche
```
## Récupérer les modifications sur une branche

```sh
$ git pull --rebase
```
## Remplacer la branche master par une autre branche

```sh
$ git checkout mabranche
$ git merge -s ours master
$ git checkout master
$ git merge mabranche  
```

## Supprimer branche distante
```sh
$ git push -d origin manouvellebranche
```
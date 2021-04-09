# Kubernetes - TP4 : Secrets et Déploiement d'application
> **Objectifs du TP** :
>- Manipulation des secrets dans Kubernetes
>- Déployer une application dans Kubernetes
>

## 1- Création d'un secret Kubernetes 

Supposons que certains pods doivent accéder à une base de données. Le nom d'utilisateur et le mot de passe que les pods doivent utiliser se trouvent dans les fichiers ./username.txt et ./password.txt sur votre machine locale.

```sh
$ echo -n 'admin' > ./username.txt
$ echo -n 'password' > ./password.txt
```

La commande `kubectl create secret` regroupe ces fichiers dans un secret et le crée.

```sh
$ kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt
secret "db-user-pass" created
```

Vérifiez ensuite l'existence du secret créé comme ceci:

```sh
$ kubectl get secrets
NAME                  TYPE                                  DATA      AGE
db-user-pass          Opaque                                2         51s
```

```sh
$ kubectl describe secrets/db-user-pass
Name:            db-user-pass
Namespace:       default
Labels:          <none>
Annotations:     <none>

Type:            Opaque

Data
====
password.txt:    12 bytes
username.txt:    5 bytes
```

Maintenant que l'on sait avoir créé le secret, il nous reste à l'utiliser rééelement. 

> **Exercices**
>- Mdifiez le fichier `deployment-kubernetes-app.yaml` afin de charger le secret que nous venons de créer en tant que variable d'environnement ayant comme nom $SECRET_BDD
>- Après avoir relancé le deploiement (cf. `kubectl replace`) trouvez une façon de pouvoir réaliser la commande suivante sur un *pod* en ayant comme résultat le secret renseigné initiallement : 

```sh
$ echo $SECRET_BDD
```
## 2- Clean up de votre cluster

Vus pouvez détruire le deployment kubernetes-app avec la commande suivante ce qui vous laissera un environnement presque comme vierge, car tout n'est pas supprimé par le deployment : 
```sh
$ kubectl delete -f deployment-kubernetess-app.yaml
```
## 3- A vous de jouer 

> **Exercice**
>- Créez un petit site faisant "Hello World from <votre Nom & Prenom> !" en `html & css` (création d'un Dockerfile et d'une image publique hébergée sur votre compte DockerHub) et déployez-le sur votre cluster minikube avec tout ce qu'on a vu en cours. 

>- Si vous voulez prendre un challenge en plus, remplacez <votre Nom & Prenom> par une variable d'environnement chargée depuis un SecretMap que vous avez créé. Attention il faudra du coup plus que du html&css pour réaliser cela, une simple appli `node, python ou autre` peut faire l'affaire tant qu'elle a la possibilité de loader des variables d'environnement, à vous de choisir. 

La réalisation de cet exercice au complet vous permettra de **gagner 1 point supplémentaire** sur la note du QCM.
Le challenge quant à lui rapportera **1 point** supplémentaire en plus de celui de l'exercice.
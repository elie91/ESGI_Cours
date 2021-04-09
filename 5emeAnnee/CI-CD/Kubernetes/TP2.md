# Kubernetes - TP2 : Contextes, namespaces et premières exécutions
> **Objectifs du TP** :
>- Manipuler les contextes `kubectl`
>- Manipuler la labellisation des objets
>- Apprendre à écrire des sélecteurs
>

## 1- Contexte d’utilisation

Lors du précédent TP, nous avons pu utiliser notre client `kubectl` et communiquer avec notre cluster, mais nous n’avons pas réellement compris par quelle magie cela a été possible.

Prenons quelques minutes pour regarder ça en détail. Nous allons commencer par chercher le fichier de configuration qui contient les informations pour se connecter au cluster Kubernetes. Si l’on part à la recherche de la variable d’environnement `$KUBECONFIG`, notre espoir est vite douché :

```sh
$ echo $KUBECONFIG

$
```

Pas de chance. Nous en concluons donc que `kubectl` se base sur le chemin par défaut pour trouver le fichier de configuration.

> **Questions**
> - Où se trouve le fichier de configuration ?
> - Dans quel format est-il écrit ?
> - Combien de contextes sont décrits dans le fichier de configuration ?

Même s’il y a plusieurs contextes, il est possible de demander à `kubectl` de n’afficher que celui qui est actif :

```sh
$ kubectl config view --minify
[...]
```
> **Questions**
>- Quelle est l’adresse IP sur laquelle se connecte notre client `kubectl` ? 
>- Dans quel ***namespace*** travaille votre contexte ?
>- Quel est le mode d’authentification utilisé pour se connecter au cluster ?

Je vous recommande d’installer et d’utiliser systématiquement l'outil `kube_ps1` , surtout si vous êtes amenés à fréquemment changer de contexte, de namespace, d’identité, de cluster Kubernetes... C’est un petit utilitaire qui va simplement modifier l’affichage dans votre console avec la commande kubeone :

```sh
$ kubeone
~(☸ |me@kube:me)$
```

## 2- Labellisation et sélecteurs

Nous allons créer des objets pour pouvoir manipuler des labels qui y sont associés. Dans un premier temps, peu importe leur utilité, ce qui nous intéresse n’est pas à quoi ils servent, mais bien la capacité de poser des labels sur n’importe quel type d’objets et de pourvoir les requêter par la suite. Dans cet exercice, nous allons simplement manipuler des ***configmap*** (***cm***).

```sh
$ kubectl create cm cm1
$ kubectl create cm cm2
$ kubectl create cm cm3
$ kubectl create cm cm4
$ kubectl create cm cm5
```

Nous allons à présent labelliser nos nouvelles ***cm*** :

```sh
$ kubectl label cm/cm1 version=1.0 country=fr
$ kubectl label cm/cm2 version=1.0 country=uk
$ kubectl label cm/cm3 version=1.1 country=de
$ kubectl label cm/cm4 version=1.1 country=fr
```

Le premier label `version` permet de simplement identifier les ***cm*** par leur version. Ils peuvent être retrouvés simplement grâce à un sélecteur :

```sh
$ kubectl get cm -l version=1.0
NAME   DATA   AGE
cm1    0      107s
cm2    0      100s
```

On voit que les autres ***cm*** sont absents de la liste, qu’ils aient le label `version` à une autre valeur que `1.0` ou que ce label soit absent.

> **Exercice**
> - Écrire un filtre permettant de ne sélectionner que les cm avec `country=fr`
> - Écrire un filtre permettant de ne sélectionner que les cm avec `version=1.1` **ET** `country=fr`
> - Écrire un filtre permettant de ne sélectionner que les cm qui n’ont pas le label version positionné

## 3- Labellisation des nœuds

Nous avons vu que les labels peuvent s’appliquer à n’importe quel type de ressources. Il faut savoir qu’il existe des ressources que l’on connaît déjà qui dispose par défaut de labels :


```sh
$ kubectl get no/minikube -o json | jq .metadata.labels
{
  "beta.kubernetes.io/arch": "amd64",
  "beta.kubernetes.io/os": "linux",
  "kubernetes.io/hostname": "minikube",
}
```

Dernier moyen de voir les labels des objets : utiliser l’option `--show-labels` lors de l’utilisation de la commande `kubectl get`.

```sh
$ kubectl get no minikube --show-labels
NAME                    STATUS   ROLES    AGE     VERSION   LABELS
minikube                Ready    master   4h17m   v1.19.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=minikube
```

Labelliser les nœuds est une opération classique que les administrateurs utilisent car elle permet de dédier des nœuds pour ne porter que certaines ressources et donc certains conteneurs spécifiques.

À titre d’exemple, il arrive de mettre des labels à certains nœuds d’un cluster K8s en DMZ pour qu’ils portent des types d’objets en particulier. Par exemple, cela peut servir à spécifier le type de disque dont dispose le nœud.

Un autre usage de la labellisation des nœuds intervient pour des clusters hybrides, c’est à dire s’il existe des nœuds de différentes architectures au sein d’un même cluster. Les conteneurs Docker n’étant pas portables d'une architecture à l'autre, il faut rigoureusement respecter l’adéquation entre l’architecture des conteneurs et celle des nœuds qui les exécutent.

> **Exercice**
>
> Après avoir trouvé les labels présents sur les nœuds, écrire un sélecteur pour lister tous les nœuds qui n’ont pas le **rôle** **`master`**
Etant donné qu'il n'y a qu'un seul noeud master sur votre minikube, l'idée est donc d'avoir un résultat vide.

## 4- Première exécution
Maintenant que tout est en place, nous allons commencer à réellement lancer des conteneurs !!

La commande magique `kubectl run` est là pour nous simplifier la vie :

```
$ kubectl run -ti --rm --restart=Never --image=busybox busybox
If you don't see a command prompt, try pressing enter.
/ # cat /etc/resolv.conf
nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
/ # exit
```

Nous venons de lancer un ***pod***, mais à l’instar d’une commande `docker container run --rm`, il n’avait pas vocation à persister.

D’ailleurs, si vous lancez la commande suivante, vous aurez la preuve que ce pod n’a eu une durée de vie très courte, puisque l’on n’en trouve plus la trace :

```sh
$ kubectl get po
No resources found.
```

## 5- Lancement de l’application kubernetes-application

Après avoir déployé nos premières ressources dans Kubernetes, il est temps de déployer une app "kubernetes-application".

Comme vous l’avez vu tout à l’heure en déployant votre premier pod dans Kubernetes via la commande `kubectl run`, vous z indiquer l’image du conteneur que vous souhaitez déployer. En l'occurrence, il s’agissait de l’image `busybox` que Kubernetes va aller chercher par défaut sur le docker hub.

Nous voilà enfin prêts à déployer notre application. Comme vous le savez désormais, déployer une application dans Kubernetes nécessite la création d’au moins 4 ressources :
1. Un ***deployment***
1. Un ***replicaset*** (créé par le ***deployment***)
1. Un ***pod*** (créé par le ***replicaset***)
1. Un ***service***

Les ressources Kubernetes peuvent être créées via la commande `kubectl run`, mais cela peut complexifier le suivi du cycle de vie de notre application. Une autre approche consiste à décrire l’attendu de nos ressources dans un fichier yaml ou json. C’est cette approche que nous allons privilégier.

Vous trouverez ci-dessous un exemple d’une ressource de type ***deployment***. Créez un fichier `deployment-kubernetes-app.yaml` (dans le dossier de votre choix) et copiez-y le code suivant :

```yaml
# deployment/deployment-kubernetes-app.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubernetes-app
  labels:
    app: kubernetes-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kubernetes-app
  template:
    metadata:
      labels:
        app: kubernetes-app
    spec:
      containers:
      - name: kubernetes-app
        image: samuelantunesocto/app:v0.1
        ports:
        - containerPort: 8000
          name: http
```

Pour que kubernetes puisse interpréter ce fichier, nous allons lui passer en utilisant le client `kubectl` :

```sh
$ kubectl apply -f deployment-kubernetes-app.yaml
```

> **Question**
>
>- Quelles ressources ont été créées suite à cette commande ?
>- Quelle commande "curl" devrais-je utiliser pour accéder à mon application déployée ? 
>- Essayez de comprendre la raison pour laquelle notre application n'est pas accessible. 
>- Proposez une solution permettant de rendre possible l'accès à l'application et mettez-la en oeuvre.

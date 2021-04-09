# Kubernetes - TP3 : Scaling
> **Objectifs du TP** :
>- Manipulation de scaling
>

### Pour réaliser le TP3 il faut préalablement avoir terminé le TP2

Si vous n'avez pas trouvé la solution rappelez-vous que le cluster minikube installé sur votre machine hôte n'est pas un réseau ouvert, au contraire il empêche les connexions entrantes de la même façon que Docker empêche l'accès à un conteneur si vous ne faites pas un bind de port... Maintent que cela est dit regardez du côté de la commande `port-forwarding` afin d'accéder à votre application. Dans un cas réel nous n'aurions bien évidemment pas utilisé ceci mais plutôt des règles d'ingress comme vu en cours. 

## 6- Scaling de l’application

L’application kubernetes-application que vous venez de déployer est une application dite stateless. Cela signifie qu’elle ne fait persister ni donnée, ni session. Cette caractéristique facilite grandement la possibilité de mise à l’échelle de cette application. Il s’agit de l’un des [12 factor app](https://12factor.net/fr/).

> **Question**
> Combien de pods ont été déployés dans le chapitre précédent ?

Dans le cas d’une montée en charge, vous aurez besoin d’ajouter des réplicas pour répondre à la demande (spoiler : il est même possible de les ajouter automatiquement mais nous verrons cela plus tard).

> **Exercices**
>- En utilisant la commande `kubectl scale`, passez à 3 réplicas l’application kubernetes-application.
>- Lancez une série de commande `curl` en ayant préalablement fait le nécessaire (voir fin TP2) pour valider que votre ***service*** est toujours joignable et fonctionnel.

> **Question**
>
> Quel indice vous montre que le ***service*** redirige vers nos deux pods ?
>
>  _(Describe est votre ami)_

Nous pouvons maintenant faire le test suivant pour prouver la résilience de notre architecture :

```sh
$ kubectl delete po --all
pod "kubernetes-app-5988675bdd-5g6jx" deleted
pod "kubernetes-app-5988675bdd-h7p55" deleted
pod "kubernetes-app-5988675bdd-z2lz7" deleted
```
> **Questions**
>- Que s’est-il passé ?
>- Quelle est la ressource logique de Kubernetes qui est à l’œuvre ?

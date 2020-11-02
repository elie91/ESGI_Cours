
/**
 
**Config globale: 
    git config --global "user.name"
    git config --global "user.email"

**Branches: 
    git checkout -b "branche"   => Crée la branche à la volée, et checkout dessus
    git branch -d "branche"     => Delete une branche
    

**Logs:
    git log --oneline

**Remote
    git fetch 
        => Récupére les modifs du remote de toutes les branches, ne modifie pas le repo locale
    
    git branch -a ou -r
        => liste toutes les branches, même celle du remote

    git pull "level" "branche" (origin master par défaut)
        => Récupère tous les commits d'une branche et modifie le repo locale

**Merge
    git merge branch => 

**Rebase
    Récupére tous les commits de la branche ciblé, et essaye de les appliquer à la branche courante
    Recrée les commits

**Référence
    git checkout HEAD~3 => remonte la branche courante de 3 commits parents du HEAD
    git branch -f master HEAD~3 => bouge (de force) la branche master à trois parents derrière HEAD.

**Stash
    git stash list 
    git stash pop => récupère le dernier stash

**Annuler 
    git reset => 
        annule des changements en déplaçant la référence en arrière dans le temps sur un commit plus ancien
        git reset HEAD~1

    git revert => 
        reset ne marche pas avec les branches remotes, alors que revert oui
        Crée un nouveau commit qui correspond aux annulations du commit précédent

**Bisect ??
    git bisect start
    git bisect bad
    git bisect good "hashcommit"
    cat bisect.txt

**Git Flow
    Voir le pdf
    Lorsqu'on merge une branche dans une autre, bien mettre l'option --no-ff

**Déplacer votre travail
    git cherry-pick <Commit1> <Commit2> <...>  =>  
        copier une série de commits en-dessous de notre emplacement actuel (HEAD)
        Très pratique lorsqu'on sait exactement quels commit on souhaite récupèrer

**Git Interactive Rebase
    Pratique quand on ne connais pas les identifiants des commits qu'on souhaire récupérer
    git rebase -i HEAD~4


**Sites Git
    https://learngitbranching.js.org/
    http://karma-runner.github.io/4.0/dev/git-commit-msg.html
    https://www.gitignore.io/
    https://git-school.github.io/visualizing-git/
    gitlab.com/lewis_mcfly/git-branches-practical-work


**Sites README
    https://github.com/api-platform/api-platform/blob/master/README.md
    https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
    https://gist.github.com/akashnimare/7b065c12d9750578de8e705fb4771d2f
    https://github.com/dbader/readme-template
    https://www.makeareadme.com/
    https://github.com/othneildrew/Best-README-Template
*/  
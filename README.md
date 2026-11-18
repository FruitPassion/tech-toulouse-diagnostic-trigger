# Cas de test du diagnostic du dépôt

Chaque branche de ce dépôt est un cas qui déclenche (ou non) des alertes du diagnostic du dépôt de la plateforme,
avant déploiement. `main` ne contient que ce mode d'emploi, le script et les sources des cas (`cas/`).

## Utilisation

Dans le formulaire « Nouveau projet », saisir l'adresse de ce dépôt, choisir la branche du cas et la pile indiquée,
puis lire le diagnostic à la dernière étape. Il est informatif : « Créer le projet » reste cliquable. Le même
diagnostic est disponible ensuite avec « Tester le dépôt » sur la page du projet et, côté admin, sur la fiche projet.

Un dépôt GitHub public fonctionne sans token, dans la limite de 60 requêtes par heure et par IP. Un dépôt privé du
GitLab de l'IUT demande un token.

## Cas

| Branche | Pile à choisir | Contenu | Résultat attendu |
|---|---|---|---|
| `statique-ok` | Statique | `index.html` | tout est ok (témoin) |
| `statique-sans-index` | Statique | `page.html`, `.gitmodules` | avertissement `index.html`, avertissement `.gitmodules` (récupérés au clonage s'ils sont publics) |
| `spa-incomplet` | SPA | `package.json`, `node_modules/` | erreur `package-lock.json`, avertissement `node_modules/` |
| `ssg-hugo-sans-config` | Générateur : Hugo | `content/_index.md` | erreur configuration Hugo |
| `ssg-mkdocs-sans-config` | Générateur : MkDocs | `docs/index.md` | erreur `mkdocs.yml` |
| `ssg-jekyll-sans-lock` | Générateur : Jekyll | `Gemfile`, `.gitmodules` | erreur `Gemfile.lock`, avertissement `.gitmodules` (non récupérés : le build ne les exporte pas) |
| `laravel-incomplet` | PHP + Laravel | `composer.json`, `vendor/` | erreurs `composer.lock`, `public/`, `artisan`, avertissement `vendor/` |
| `symfony-sans-console` | PHP + Symfony | `composer.json`, `composer.lock`, `public/`, `bin/README` | erreur `bin/console` seule |
| `php-vendor-ok` | PHP sans framework | `index.php`, `vendor/` | tout est ok : sans framework, rien ne lance composer et `vendor/` est attendu |
| `python-incomplet` | Python + Flask, point d'entrée `app:app` | `main.py` | erreurs dépendances Python et point d'entrée |
| `python-module-pointe` | Python + FastAPI, point d'entrée `monapp.web:app` | `requirements.txt`, `monapp/__init__.py` | erreur point d'entrée (`monapp/web.py` absent) |

La taille reste sous la limite de 100 Mo dans tous les cas.

## Régénérer les branches

```bash
./creer-branches.sh
git push origin main
git push --force origin $(ls cas)
```

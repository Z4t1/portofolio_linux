# 🚀 Mon Portfolio Linux Automatisé

Ce projet est un serveur web tournant sous **Apache2** qui affiche des informations système en temps réel.

## 🛠️ Fonctionnement
- **Automatisation :** Un script Bash s'exécute chaque minute via une tâche **Cron**.
- **Données affichées :** Heure précise, adresse IP du serveur, espace disque restant et version du Kernel.
- **Déploiement :** Le script génère un fichier HTML et le déplace dans le répertoire `/var/www/html/`.

## 📦 Installation
Le script principal se trouve dans `update_site.sh`.

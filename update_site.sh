#!/bin/bash

# --- VARIABLES ---
# On force la date en Français et on récupère les infos
DATE_MAJ=$(date '+%d %B %Y à %H:%M:%S')
IP=$(hostname -I | awk '{print $1}')
DISK=$(df -h / | awk 'NR==2 {print $4}')
USER=$(whoami)
KERNEL=$(uname -r)

# --- GÉNÉRATION HTML ---
cat <<EOF > /home/admin-user/portfolio_dorian/index.html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Portfolio Auto | Dorian</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #1a1a1a; color: white; font-family: sans-serif; padding-top: 50px; }
        .card { background-color: #333; border: 1px solid #444; padding: 20px; border-radius: 10px; }
        .highlight { color: #00d2ff; font-weight: bold; }
        .footer { margin-top: 20px; border-top: 1px solid #555; padding-top: 10px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <h2 class="text-center mb-4">Admin Système : Dorian</h2>
                    <p>IP Serveur : <span class="highlight">$IP</span></p>
                    <p>Disque Libre : <span class="highlight">$DISK</span></p>
                    <p>Kernel : <span class="highlight">$KERNEL</span></p>
                    <p>Utilisateur Script : <span class="highlight">$USER</span></p>
                    
                    <div class="footer">
                        <small>Dernière mise à jour auto :</small><br>
                        <span style="font-size: 1.2em; color: #00d2ff;">$DATE_MAJ</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOF

# --- COPIE DU FICHIER (SANS SUDO) ---
cp /home/admin-user/portfolio_dorian/index.html /var/www/html/index.html

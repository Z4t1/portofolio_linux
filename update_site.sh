#!/bin/bash

# Variables
FICHIER_HTML="/var/www/html/index.html"
HEURE=$(date "+%H:%M:%S")
DATE=$(date "+%d/%m/%Y")
IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p)
KERNEL=$(uname -r)
DISK=$(df -h / | awk 'NR==2 {print $4}')

# Génération du HTML avec Style CSS
cat <<EOF > $FICHIER_HTML
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard de Dorian</title>
    <style>
        body {
            background-color: #0d1117;
            color: #00ff41;
            font-family: 'Courier New', Courier, monospace;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        h1 { border-bottom: 2px solid #00ff41; padding-bottom: 10px; }
        .container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-top: 20px;
        }
        .card {
            background: #161b22;
            border: 1px solid #00ff41;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            min-width: 200px;
        }
        .label { color: #8b949e; font-size: 0.8em; text-transform: uppercase; }
        .value { font-size: 1.2em; font-weight: bold; margin-top: 5px; }
        .footer { margin-top: 30px; font-size: 0.7em; color: #58a6ff; }
    </style>
</head>
<body>
    <h1>📟 SERVER_STATUS: ONLINE</h1>
    
    <div class="container">
        <div class="card">
            <div class="label">Date & Heure</div>
            <div class="value">$DATE - $HEURE</div>
        </div>
        <div class="card">
            <div class="label">Adresse IP</div>
            <div class="value">$IP</div>
        </div>
        <div class="card">
            <div class="label">Espace Libre</div>
            <div class="value">$DISK</div>
        </div>
        <div class="card">
            <div class="label">Uptime</div>
            <div class="value">$UPTIME</div>
        </div>
    </div>

    <div class="footer">
        Système: $KERNEL | Mis à jour automatiquement par Cron
    </div>
</body>
</html>
EOF

#!/bin/bash

# 1. Préparation des données du serveur
FICHIER_HTML="/var/www/html/index.html"
IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p)
KERNEL=$(uname -r)
DISK=$(df -h / | awk 'NR==2 {print $4}')

# 2. Génération du fichier HTML
cat <<EOF > $FICHIER_HTML
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard de Dorian</title>
    <style>
        body { background-color: #0d1117; color: #00ff41; font-family: monospace; display: flex; flex-direction: column; align-items: center; padding: 20px; }
        .container { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-top: 20px; }
        .card { background: #161b22; border: 1px solid #00ff41; padding: 15px; border-radius: 8px; text-align: center; min-width: 220px; }
        .horloge { font-size: 1.4em; color: #00ff41; }
        .footer { margin-top: 30px; font-size: 0.8em; color: #58a6ff; }
    </style>
</head>
<body>
    <h1>📟 SYSTEM MONITOR: ONLINE</h1>
    
    <div class="container">
        <div class="card">
            <div style="color: #8b949e;">TEMPS RÉEL</div>
            <div id="horloge">Initialisation...</div>
        </div>
        <div class="card">
            <div style="color: #8b949e;">ADRESSE IP</div>
            <div>$IP</div>
        </div>
        <div class="card">
            <div style="color: #8b949e;">ESPACE DISQUE</div>
            <div>$DISK libre</div>
        </div>
        <div class="card">
            <div style="color: #8b949e;">UPTIME</div>
            <div>$UPTIME</div>
        </div>
    </div>

    <div class="footer">Kernel: $KERNEL</div>

    <script>
        function mettreAJourHeure() {
            const maintenant = new Date();
            const h = maintenant.getHours().toString().padStart(2, '0');
            const m = maintenant.getMinutes().toString().padStart(2, '0');
            const s = maintenant.getSeconds().toString().padStart(2, '0');
            document.getElementById('horloge').innerText = h + ":" + m + ":" + s;
        }
        setInterval(mettreAJourHeure, 1000); // Répète toutes les 1000ms (1s)
        mettreAJourHeure(); // Lance tout de suite au chargement
    </script>
</body>
</html>
EOF

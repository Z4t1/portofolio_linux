#!/bin/bash

# ====================================================================
# PORTFOLIO DORIAN - RAM live + Disque qui marchent
# ====================================================================
LOG_FILE="/home/admin-user/portfolio_dorian/deploy.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$DATE] Mise à jour effectuée par $USER" >> $LOG_FILE
IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p)
DISK=$(df -h / | awk 'NR==2 {print $4}')
DISK_USED_PERCENT=$(df / | awk 'NR==2 {print int($5)}')

echo "📊 Génération avec :"
echo "   IP: $IP"
echo "   Uptime: $UPTIME"
echo "   Disque: $DISK ($DISK_USED_PERCENT%)"

# Créer le fichier PHP
cat > /var/www/html/stats.php <<'PHPEND'
<?php
header('Content-Type: application/json');

$uptime = shell_exec("uptime -p");
$memInfo = shell_exec("free | grep Mem");
preg_match('/\s+(\d+)\s+(\d+)/', $memInfo, $matches);
$total = $matches[1];
$used = $matches[2];
$ramPercent = round(($used / $total) * 100);

echo json_encode([
    'uptime' => trim($uptime),
    'ram' => $ramPercent
]);
?>
PHPEND

chmod 644 /var/www/html/stats.php
chmod 644 /var/www/html/index.html
# Générer le HTML avec des marqueurs uniques
cat > /var/www/html/index.html <<'HTMLEND'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dorian | Cabinet de Curiosités</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Cinzel:wght@400;600;900&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --bg-dark: #0d0a12;
            --text-primary: #f5f5ff;
            --text-secondary: #b8b3c4;
            --text-muted: #6b6575;
            --accent-gold: #d4af37;
            --accent-purple: #a855f7;
            --font-display: 'Cinzel', serif;
            --font-body: 'Inter', sans-serif;
        }
      body {
            font-family: var(--font-body);
            background: var(--bg-dark);
            color: var(--text-primary);
            overflow-x: hidden;
        }
        #navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            padding: 1.2rem 3rem;
            background: rgba(13, 10, 18, 0.9);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.3);
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-family: var(--font-display);
            font-size: 1.5rem;
            font-weight: 900;
            color: var(--accent-gold);
            letter-spacing: 0.1em;
        }
        .nav-links { display: flex; gap: 2rem; }
        .btn-menu {
            cursor: pointer;
            padding: 0.5rem 1rem;
            color: var(--text-secondary);
            font-size: 0.9rem;
            background: transparent;
            border: none;
            transition: color 0.3s ease;
        }
        .btn-menu:hover { color: var(--accent-gold); }
        .hero-immersive {
            position: relative;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #000;
        }
        #hero-video-canvas {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            opacity: 0.7;
        }
        .hero-overlay {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle, transparent 0%, rgba(0,0,0,0.5) 100%);
        }
        .hero-content-immersive {
            position: relative;
            z-index: 10;
            text-align: center;
            padding: 2rem;
        }
        .hero-tagline-top {
            font-size: 0.9rem;
            letter-spacing: 0.3em;
            color: var(--accent-gold);
            text-transform: uppercase;
            margin-bottom: 2rem;
        }
        .hero-title-ornate {
            font-family: var(--font-display);
            font-size: clamp(3rem, 10vw, 8rem);
            font-weight: 900;
            letter-spacing: 0.15em;
            color: var(--accent-gold);
            text-shadow: 0 0 30px rgba(212, 175, 55, 0.5);
            position: relative;
            display: inline-block;
        }
        .hero-title-ornate::before,
        .hero-title-ornate::after {
            content: '∿';
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            font-size: 3rem;
            color: var(--accent-gold);
        }
        .hero-title-ornate::before { left: -4rem; }
        .hero-title-ornate::after { right: -4rem; transform: translateY(-50%) scaleX(-1); }
        .hero-subtitle-immersive {
            font-family: var(--font-title);
            font-size: 1.5rem;
            color: var(--text-secondary);
            margin: 1.5rem 0 3rem;
            font-style: italic;
        }
        .btn-hero {
            padding: 1rem 2.5rem;
            margin: 0 0.75rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            border: 2px solid var(--accent-gold);
            background: transparent;
            color: var(--accent-gold);
            cursor: pointer;
            transition: all 0.4s ease;
        }
        .btn-hero:hover {
            background: var(--accent-gold);
            color: #000;
        }
        .gallery-section {
            min-height: 100vh;
            padding: 8rem 3rem 6rem;
            background: var(--bg-dark);
        }
        .gallery-container { max-width: 1400px; margin: 0 auto; }
        .gallery-title {
            font-family: var(--font-display);
            font-size: 3rem;
            text-align: center;
            margin-bottom: 4rem;
            color: var(--accent-gold);
        }
        .paintings-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 3rem;
        }
        .frame-container {
            cursor: pointer;
            transition: transform 0.4s ease;
        }
        .frame-container:hover { transform: translateY(-15px); }
        .vintage-frame {
            padding: 25px;
            background: linear-gradient(135deg, #3d2817, #5c3d2e);
            border-radius: 5px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
            position: relative;
        }
        .vintage-frame::before,
        .vintage-frame::after {
            content: '';
            position: absolute;
            width: 15px;
            height: 15px;
            border: 2px solid var(--accent-gold);
        }
        .vintage-frame::before {
            top: 5px;
            left: 5px;
            border-right: none;
            border-bottom: none;
        }
        .vintage-frame::after {
            bottom: 5px;
            right: 5px;
            border-left: none;
            border-top: none;
        }
        .painting-canvas {
            width: 100%;
            aspect-ratio: 4/3;
            display: block;
            background: #000;
            border: 3px solid rgba(0, 0, 0, 0.8);
        }
        .painting-label { margin-top: 1rem; text-align: center; }
        .painting-title {
            font-family: var(--font-display);
            font-size: 1.2rem;
            color: var(--accent-gold);
        }
        .painting-description {
            font-size: 0.85rem;
            color: var(--text-secondary);
            font-style: italic;
        }
        .dropdown {
            position: fixed;
            top: 80px;
            left: 0;
            right: 0;
            background: rgba(13, 10, 18, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.3);
            z-index: 999;
            max-height: 0;
            overflow-y: auto;
            transition: max-height 0.4s ease, opacity 0.3s ease;
            opacity: 0;
        }
        .dropdown.active { max-height: 80vh; opacity: 1; }
        .dropdown-content { padding: 3rem; max-width: 1000px; margin: 0 auto; }
        .dropdown h2 {
            font-family: var(--font-display);
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            color: var(--accent-gold);
        }
        .dropdown p { color: var(--text-secondary); line-height: 1.8; margin-bottom: 1rem; }
        .dropdown strong { color: var(--accent-purple); }
        .sys-info-item {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            margin-bottom: 1rem;
            font-size: 1.05rem;
        }
        .stat-bar-container { margin: 1.5rem 0; }
        .stat-bar-bg {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            height: 12px;
            border: 1px solid rgba(212,175,55,0.3);
            margin-top: 0.5rem;
        }
        .stat-bar-fill {
            height: 100%;
            border-radius: 10px;
            transition: width 0.8s ease, background 0.3s ease;
            width: 0%;
        }
        .dropdown-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.7);
            z-index: 998;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }
        .dropdown-overlay.active { opacity: 1; visibility: visible; }
        @media (max-width: 1024px) {
            .paintings-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            #navbar { padding: 1rem 1.5rem; }
            .paintings-grid { grid-template-columns: 1fr; }
            .hero-title-ornate::before,
            .hero-title-ornate::after { display: none; }
        }
    </style>
</head>
<body>
    <nav id="navbar">
        <div class="logo">DORIAN</div>
        <div class="nav-links">
            <button class="btn-menu" onclick="scrollToTop()">Accueil</button>
            <button class="btn-menu" onclick="scrollToGallery()">Galerie</button>
            <button class="btn-menu" onclick="openDropdown('drop-contacts')">Contact</button>
        </div>
    </nav>

    <section class="hero-immersive">
        <canvas id="hero-video-canvas"></canvas>
        <div class="hero-overlay"></div>
        <div class="hero-content-immersive">
            <p class="hero-tagline-top">Entrez dans le</p>
            <h1 class="hero-title-ornate">DORIAN</h1>
            <p class="hero-subtitle-immersive">Cabinet de Curiosités Numériques</p>
            <div>
                <button class="btn-hero" onclick="scrollToGallery()">Explorer</button>
                <button class="btn-hero" onclick="openDropdown('drop-contacts')">Contact</button>
            </div>
        </div>
    </section>

    <section class="gallery-section" id="gallery">
        <div class="gallery-container">
            <h2 class="gallery-title">🖼️ Collection Macabre 🖼️</h2>
            <div class="paintings-grid">
                <div class="frame-container" onclick="openDropdown('drop-sys')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-sys"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Système</h3>
                        <p class="painting-description">Les Rouages</p>
                    </div>
                </div>
                <div class="frame-container" onclick="openDropdown('drop-projets')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-projets"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Œuvres</h3>
                        <p class="painting-description">Créations</p>
                    </div>
                </div>
                <div class="frame-container" onclick="openDropdown('drop-about')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-about"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">À Propos</h3>
                        <p class="painting-description">L'Artisan</p>
                    </div>
                </div>
                <div class="frame-container" onclick="openDropdown('drop-skills')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-skills"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Compétences</h3>
                        <p class="painting-description">Arsenal</p>
                    </div>
                </div>
                <div class="frame-container" onclick="openDropdown('drop-contacts')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-contacts"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Contact</h3>
                        <p class="painting-description">Invocations</p>
                    </div>
                </div>
                <div class="frame-container" onclick="openDropdown('drop-blog')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-blog"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Journal</h3>
                        <p class="painting-description">Chroniques</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div id="drop-sys" class="dropdown">
        <div class="dropdown-content">
            <h2>⚙️ Système</h2>
            
            <div class="sys-info-item">
                <span>🕐</span>
                <strong>Heure :</strong> 
                <span id="sys-time" style="color: var(--accent-gold);">--:--:--</span>
            </div>
            
            <div class="sys-info-item">
                <span>🌐</span>
                <strong>IP :</strong> <span>___IP___</span>
            </div>
            
            <div class="sys-info-item">
                <span>⏱️</span>
                <strong>Uptime :</strong> <span id="live-uptime">___UPTIME___</span>
            </div>
            
            <div class="stat-bar-container">
                <p><strong>💾 RAM : <span id="live-ram">--</span>%</strong></p>
                <div class="stat-bar-bg">
                    <div id="ram-bar" class="stat-bar-fill"></div>
                </div>
            </div>

            <div class="stat-bar-container">
                <p><strong>📊 Disque : ___DISK___ (<span id="disk-percent-text">___DISK_PERCENT___</span>%)</strong></p>
                <div class="stat-bar-bg">
                    <div id="disk-bar" class="stat-bar-fill"></div>
                </div>
            </div>

            <div class="sys-info-item" style="margin-top: 1rem;">
                <span>🖥️</span>
                <strong>OS :</strong> <span>Ubuntu 24.04 LTS</span>
            </div>
            
            <p style="margin-top: 2rem; font-size: 0.85rem; color: var(--text-muted); font-style: italic;">
                Dernière mise à jour : <span id="last-update">--</span>
            </p>
        </div>
    </div>

    <div id="drop-projets" class="dropdown">
        <div class="dropdown-content">
            <h2>✨ Mes Œuvres</h2>
            <p>Développement d'applications web avec animations 3D.</p>
        </div>
    </div>

    <div id="drop-about" class="dropdown">
        <div class="dropdown-content">
            <h2>👤 À Propos</h2>
            <p>Développeur inspiré par l'esthétique Burton.</p>
        </div>
    </div>

    <div id="drop-skills" class="dropdown">
        <div class="dropdown-content">
            <h2>🎯 Compétences</h2>
            <p><strong>Frontend :</strong> React, Vue.js, Three.js</p>
            <p><strong>Backend :</strong> Node.js, Python</p>
        </div>
    </div>

    <div id="drop-contacts" class="dropdown">
        <div class="dropdown-content">
            <h2>📧 Contact</h2>
            <p><strong>Email :</strong> dorianroullet@hotmail.com</p>
        </div>
    </div>

    <div id="drop-blog" class="dropdown">
        <div class="dropdown-content">
            <h2>📝 Journal</h2>
            <p>Prochainement...</p>
        </div>
    </div>
<div id="loading-screen" style="position:fixed; top:0; left:0; width:100%; height:100%; background:#0d0a12; color:#a855f7; z-index:9999; display:flex; flex-direction:column; justify-content:center; align-items:center; font-family:monospace; padding:20px;">
    <div id="loader-text" style="width:100%; max-width:600px; line-height:1.5;"></div>
</div>

<script>
const SERVER_DATA = {
    // On ajoute des guillemets : si sed n'est pas passé, 
    // JS voit du texte et non une variable inexistante.
    diskPercent: parseFloat("___DISK_PERCENT___") || 0 
};
        let currentDropdown = null;
        const overlay = document.createElement('div');
        overlay.className = 'dropdown-overlay';
        document.body.appendChild(overlay);

        // 2. HERO BACKGROUND (ANIMATION PARTICULES)
        const hc = document.getElementById('hero-video-canvas');
        if (hc) {
            const hctx = hc.getContext('2d');
            hc.width = window.innerWidth;
            hc.height = window.innerHeight;
            const particles = [];
            for(let i = 0; i < 80; i++) {
                particles.push({
                    x: Math.random() * hc.width,
                    y: Math.random() * hc.height,
                    vx: (Math.random() - 0.5) * 0.5,
                    vy: Math.random() * 0.5 + 0.2,
                    radius: Math.random() * 50 + 15,
                    opacity: Math.random() * 0.25 + 0.1
                });
            }
            function animateHero() {
                const g = hctx.createRadialGradient(hc.width/2, hc.height/2, 0, hc.width/2, hc.height/2, hc.width/2);
                g.addColorStop(0, '#1a1520');
                g.addColorStop(1, '#0d0a12');
                hctx.fillStyle = g;
                hctx.fillRect(0, 0, hc.width, hc.height);
                particles.forEach(function(p) {
                    p.x += p.vx; p.y += p.vy;
                    if(p.y > hc.height + 100) { p.y = -100; p.x = Math.random() * hc.width; }
                    if(p.x < -100 || p.x > hc.width + 100) p.vx *= -1;
                    const pg = hctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, p.radius);
                    pg.addColorStop(0, 'rgba(168, 85, 247, ' + p.opacity + ')');
                    pg.addColorStop(1, 'rgba(168, 85, 247, 0)');
                    hctx.fillStyle = pg;
                    hctx.beginPath();
                    hctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
                    hctx.fill();
                });
                requestAnimationFrame(animateHero);
            }
            animateHero();
        }

        // 3. CANVAS TABLEAUX
        function initCanvas(id, color) {
            const c = document.getElementById(id); if(!c) return;
            const ctx = c.getContext('2d');
            c.width = c.offsetWidth;
            c.height = c.offsetHeight;
            let angle = 0;
            function animate() {
                ctx.fillStyle = 'rgba(0,0,0,0.1)';
                ctx.fillRect(0, 0, c.width, c.height);
                angle += 0.02;
                ctx.save();
                ctx.translate(c.width/2, c.height/2);
                ctx.rotate(angle);
                ctx.strokeStyle = color;
                ctx.lineWidth = 2;
                ctx.strokeRect(-40, -40, 80, 80);
                ctx.restore();
                requestAnimationFrame(animate);
            }
            animate();
        }

        window.addEventListener('load', function() {
            initCanvas('canvas-sys', '#d4af37');
            initCanvas('canvas-projets', '#a855f7');
            initCanvas('canvas-about', '#60a5fa');
            initCanvas('canvas-skills', '#0f0');
            initCanvas('canvas-contacts', '#a855f7');
            initCanvas('canvas-blog', '#8b0000');
        });

        // 4. SYSTÈME ET STATS
        function updateClock() {
            const now = new Date();
            const timeStr = now.toLocaleTimeString('fr-FR');
            const el = document.getElementById('sys-time');
            if(el) el.textContent = timeStr;
            const upd = document.getElementById('last-update');
            if(upd) upd.textContent = now.toLocaleDateString('fr-FR') + ' ' + timeStr;
        }
        setInterval(updateClock, 1000);

        function fetchLiveStats() {
            fetch('stats.php').then(r => r.json()).then(data => {
                const uptimeEl = document.getElementById('live-uptime');
                const ramEl = document.getElementById('live-ram');
                const ramBar = document.getElementById('ram-bar');
                if(uptimeEl) uptimeEl.textContent = data.uptime;
                if(ramEl) ramEl.textContent = data.ram;
                if(ramBar) {
                    ramBar.style.width = data.ram + '%';
                    ramBar.style.background = data.ram > 80 ? '#8b0000' : (data.ram > 60 ? '#d4af37' : '#a855f7');
                }
            }).catch(e => console.error("Stats error", e));
        }
        setInterval(fetchLiveStats, 2000);

        // 5. NAVIGATION
        function closeAllDropdowns() {
            document.querySelectorAll('.dropdown').forEach(d => d.classList.remove('active'));
            overlay.classList.remove('active');
            currentDropdown = null;
        }

        function openDropdown(id) {
            const dd = document.getElementById(id);
            if(!dd) return;
            if(currentDropdown === dd) { closeAllDropdowns(); return; }
            closeAllDropdowns();
            dd.classList.add('active');
            overlay.classList.add('active');
            currentDropdown = dd;
        }

        overlay.addEventListener('click', closeAllDropdowns);
        function scrollToGallery() { 
            closeAllDropdowns();
            document.getElementById('gallery').scrollIntoView({ behavior: 'smooth' }); 
        }
        function scrollToTop() {
            closeAllDropdowns();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
const steps = [
    "> Initialisation du Cabinet de Curiosités...",
    "> Vérification de l'intégrité des rouages...",
    "> Chargement de l'âme de l'Artisan...",
    "> Accès sécurisé : DORIAN_ADMIN",
    "> Bienvenue dans le Cabinet des Curiosités."
];

let stepIndex = 0;
const loaderText = document.getElementById('loader-text');

function typeStep() {
    if (stepIndex < steps.length) {
        let p = document.createElement('p');
        p.textContent = steps[stepIndex];
        p.style.margin = "5px 0";
        loaderText.appendChild(p);
        stepIndex++;
        setTimeout(typeStep, 600); // Vitesse entre chaque ligne
    } else {
        setTimeout(() => {
            document.getElementById('loading-screen').style.opacity = '0';
            setTimeout(() => {
                document.getElementById('loading-screen').style.display = 'none';
            }, 500);
        }, 800);
    }
}

window.addEventListener('load', typeStep);
   
  </script>
</body>
</html>
HTMLEND
if [ $? -eq 0 ]; then
    # Liste de messages variés
    MESSAGES=("Le Cabinet est ouvert au public !" "Les curiosités sont en ligne." "Déploiement réussi, l'Artisan." "L'ombre de Dorian plane sur le Web.")
    # Choix aléatoire
    SELECTED=${MESSAGES[$RANDOM % ${#MESSAGES[@]}]}
    
    echo "[$DATE] SUCCÈS : $SELECTED" >> $LOG_FILE
    echo "✅ $SELECTED"
else
    echo "[$DATE] ERREUR : Le mécanisme s'est enrayé." >> $LOG_FILE
fi
# Remplacement avec des marqueurs uniques
sed -i "s/___IP___/$IP/g" /var/www/html/index.html
sed -i "s/___UPTIME___/$UPTIME/g" /var/www/html/index.html
sed -i "s/___DISK___/$DISK/g" /var/www/html/index.html
sed -i "s/___DISK_PERCENT___/$DISK_USED_PERCENT/g" /var/www/html/index.html


chmod 644 /var/www/html/index.html

echo "✅ Portfolio généré avec succès !"
echo "📊 IP: $IP"
echo "📊 Uptime: $UPTIME"
echo "📊 Disque: $DISK ($DISK_USED_PERCENT%)"
echo "💾 Barre RAM: Live (via PHP)"
echo "💾 Barre Disque: Statique ($DISK_USED_PERCENT%)"
echo "🚀 http://localhost"


#!/bin/bash

# ====================================================================
# PORTFOLIO DORIAN - HERO IMMERSIF STYLE IRONHILL
# Video background + Ornements gothiques + Galerie de tableaux
# ====================================================================
IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p)
DISK=$(df -h / | awk 'NR==2 {print $4}')
DISK_USED_PERCENT=$(df / | awk 'NR==2 {print int($5)}')

cat <<'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dorian | Cabinet de Curiosités</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Cinzel:wght@400;600;900&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --bg-dark: #0d0a12;
            --bg-surface: #1a1520;
            --bg-card: #13101a;
            
            --text-primary: #f5f5ff;
            --text-secondary: #b8b3c4;
            
            --accent-purple: #a855f7;
            --accent-gold: #d4af37;
            --accent-blood: #8b0000;
            
            --wood-dark: #3d2817;
            --wood-light: #5c3d2e;
            
            --gradient-gold: linear-gradient(135deg, #d4af37 0%, #b8960d 100%);
            
            --font-display: 'Cinzel', serif;
            --font-title: 'Playfair Display', serif;
            --font-body: 'Inter', sans-serif;
            
            --ease-burton: cubic-bezier(0.68, -0.55, 0.265, 1.55);
            --ease-apple: cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        body {
            font-family: var(--font-body);
            background: var(--bg-dark);
            color: var(--text-primary);
            overflow-x: hidden;
        }

        /* ================================================================
           NAVBAR MINIMALISTE
           ================================================================ */
        
        #navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            padding: 1.5rem 3rem;
            background: transparent;
            backdrop-filter: blur(0px);
            z-index: 1000;
            transition: all 0.4s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        #navbar.scrolled {
            background: rgba(13, 10, 18, 0.85);
            backdrop-filter: saturate(180%) blur(20px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.2);
            padding: 1rem 3rem;
        }

        .logo {
            font-family: var(--font-display);
            font-size: 1.3rem;
            font-weight: 900;
            color: var(--accent-gold);
            letter-spacing: 0.1em;
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        #navbar.scrolled .logo {
            opacity: 1;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        #navbar.scrolled .nav-links {
            opacity: 1;
        }

        .btn-menu {
            font-family: var(--font-body);
            cursor: pointer;
            padding: 0.5rem 0;
            color: var(--text-secondary);
            font-size: 0.9rem;
            background: transparent;
            border: none;
            position: relative;
            transition: color 0.3s ease;
        }

        .btn-menu:hover {
            color: var(--accent-gold);
        }

        .btn-menu::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 0;
            height: 2px;
            background: var(--accent-gold);
            transition: width 0.3s ease;
        }

        .btn-menu:hover::after {
            width: 80%;
        }

        /* ================================================================
           HERO IMMERSIF STYLE IRONHILL
           ================================================================ */
        
        .hero-immersive {
            position: relative;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background: #000;
        }

        /* Canvas vidéo background */
        #hero-video-canvas {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.7;
        }

        /* Overlay sombre pour le contraste */
        .hero-overlay {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at center, transparent 0%, rgba(0,0,0,0.5) 100%);
            z-index: 1;
        }

        /* Contenu du hero */
        .hero-content-immersive {
            position: relative;
            z-index: 10;
            text-align: center;
            padding: 2rem;
            animation: fadeInUp 1.5s ease forwards;
            opacity: 0;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Tagline du haut */
        .hero-tagline-top {
            font-family: var(--font-body);
            font-size: 0.9rem;
            letter-spacing: 0.3em;
            color: var(--accent-gold);
            text-transform: uppercase;
            margin-bottom: 2rem;
            opacity: 0.8;
        }

        /* Titre principal avec ornements */
        .hero-title-ornate {
            font-family: var(--font-display);
            font-size: clamp(3rem, 10vw, 8rem);
            font-weight: 900;
            letter-spacing: 0.15em;
            color: var(--accent-gold);
            text-shadow: 
                0 0 30px rgba(212, 175, 55, 0.5),
                0 0 60px rgba(212, 175, 55, 0.3);
            margin: 0;
            position: relative;
            display: inline-block;
        }

        /* Ornements gothiques autour du titre */
        .hero-title-ornate::before,
        .hero-title-ornate::after {
            content: '∿';
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            font-size: 3rem;
            color: var(--accent-gold);
            opacity: 0.6;
        }

        .hero-title-ornate::before {
            left: -4rem;
        }

        .hero-title-ornate::after {
            right: -4rem;
            transform: translateY(-50%) scaleX(-1);
        }

        /* Sous-titre */
        .hero-subtitle-immersive {
            font-family: var(--font-title);
            font-size: clamp(1rem, 2vw, 1.5rem);
            color: var(--text-secondary);
            margin-top: 1.5rem;
            margin-bottom: 3rem;
            font-style: italic;
            letter-spacing: 0.05em;
        }

        /* Boutons CTA */
        .hero-cta-buttons {
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            margin-top: 3rem;
        }

        .btn-hero {
            font-family: var(--font-body);
            padding: 1rem 2.5rem;
            font-size: 0.95rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            border: 2px solid var(--accent-gold);
            background: transparent;
            color: var(--accent-gold);
            cursor: pointer;
            transition: all 0.4s var(--ease-burton);
            position: relative;
            overflow: hidden;
        }

        .btn-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: var(--accent-gold);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s var(--ease-burton);
            z-index: -1;
        }

        .btn-hero:hover::before {
            transform: scaleX(1);
        }

        .btn-hero:hover {
            color: #000;
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.5);
        }

        .btn-hero-primary {
            background: var(--accent-gold);
            color: #000;
        }

        .btn-hero-primary::before {
            background: transparent;
        }

        .btn-hero-primary:hover {
            background: transparent;
            color: var(--accent-gold);
        }

        /* Scroll indicator */
        .scroll-indicator-immersive {
            position: absolute;
            bottom: 3rem;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
            color: var(--accent-gold);
            font-size: 0.8rem;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            animation: bounce 2s infinite;
            z-index: 10;
            opacity: 0.7;
        }

        @keyframes bounce {
            0%, 100% { transform: translateX(-50%) translateY(0); }
            50% { transform: translateX(-50%) translateY(10px); }
        }

        .scroll-indicator-immersive::after {
            content: '';
            width: 2px;
            height: 40px;
            background: linear-gradient(to bottom, var(--accent-gold), transparent);
        }

        /* ================================================================
           GALERIE (même style qu'avant)
           ================================================================ */
        
        .gallery-section {
            position: relative;
            z-index: 10;
            min-height: 100vh;
            padding: 6rem 3rem;
            background: var(--bg-dark);
            background-image: repeating-linear-gradient(
                45deg,
                transparent,
                transparent 10px,
                rgba(168, 85, 247, 0.02) 10px,
                rgba(168, 85, 247, 0.02) 20px
            );
        }

        .gallery-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .gallery-title {
            font-family: var(--font-display);
            font-size: clamp(2rem, 4vw, 3rem);
            text-align: center;
            margin-bottom: 4rem;
            background: var(--gradient-gold);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .paintings-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 3rem;
        }

        .frame-container {
            position: relative;
            cursor: pointer;
            transition: all 0.4s var(--ease-burton);
        }

        .frame-container:hover {
            transform: translateY(-15px) scale(1.02);
        }

        .vintage-frame {
            position: relative;
            padding: 25px;
            background: linear-gradient(135deg, var(--wood-dark) 0%, var(--wood-light) 100%);
            border-radius: 5px;
            box-shadow: 
                0 10px 40px rgba(0, 0, 0, 0.6),
                inset 0 2px 5px rgba(212, 175, 55, 0.2);
            background-image: 
                repeating-linear-gradient(
                    90deg,
                    transparent,
                    transparent 2px,
                    rgba(0, 0, 0, 0.1) 2px,
                    rgba(0, 0, 0, 0.1) 4px
                ),
                linear-gradient(135deg, var(--wood-dark) 0%, var(--wood-light) 100%);
        }

        .vintage-frame::before,
        .vintage-frame::after {
            content: '';
            position: absolute;
            width: 15px;
            height: 15px;
            border: 2px solid var(--accent-gold);
            transition: all 0.3s ease;
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

        .frame-container:hover .vintage-frame::before,
        .frame-container:hover .vintage-frame::after {
            width: 25px;
            height: 25px;
            border-color: var(--accent-blood);
        }

        .painting-canvas {
            width: 100%;
            aspect-ratio: 4/3;
            display: block;
            background: #000;
            border: 3px solid rgba(0, 0, 0, 0.8);
        }

        .frame-container:hover .painting-canvas {
            filter: saturate(2) hue-rotate(20deg) contrast(1.2);
            animation: glitchShake 0.3s infinite;
        }

        @keyframes glitchShake {
            0%, 100% { transform: translate(0, 0); }
            25% { transform: translate(-2px, 2px); }
            50% { transform: translate(2px, -1px); }
            75% { transform: translate(-1px, -2px); }
        }

        .painting-label {
            margin-top: 1rem;
            text-align: center;
        }

        .painting-title {
            font-family: var(--font-display);
            font-size: 1.2rem;
            color: var(--accent-gold);
            margin-bottom: 0.3rem;
        }

        .painting-description {
            font-size: 0.85rem;
            color: var(--text-secondary);
            font-style: italic;
        }

        /* Dropdowns */
        .dropdown {
            position: fixed;
            top: 72px;
            left: 0;
            right: 0;
            background: rgba(13, 10, 18, 0.95);
            backdrop-filter: saturate(180%) blur(20px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.3);
            z-index: 999;
            max-height: 0;
            overflow-y: auto;
            transition: max-height 0.4s ease, opacity 0.3s ease;
            opacity: 0;
        }

        .dropdown.active {
            max-height: 80vh;
            opacity: 1;
        }

        .dropdown-content {
            padding: 3rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .dropdown h2 {
            font-family: var(--font-display);
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            color: var(--accent-gold);
        }

        .dropdown p {
            color: var(--text-secondary);
            line-height: 1.8;
            margin-bottom: 1rem;
        }

        .dropdown strong {
            color: var(--accent-purple);
        }

        .project-item {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .dropdown h3 {
            font-family: var(--font-display);
            font-size: 1.5rem;
            color: var(--accent-gold);
            margin-bottom: 0.5rem;
        }

        .dropdown-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 998;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .dropdown-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .paintings-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .hero-title-ornate::before,
            .hero-title-ornate::after {
                font-size: 2rem;
            }
            
            .hero-title-ornate::before {
                left: -2.5rem;
            }
            
            .hero-title-ornate::after {
                right: -2.5rem;
            }
        }

        @media (max-width: 768px) {
            #navbar {
                padding: 1rem 1.5rem;
            }
            
            .paintings-grid {
                grid-template-columns: 1fr;
            }

            .hero-cta-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn-hero {
                width: 100%;
                max-width: 300px;
            }
            
            .hero-title-ornate::before,
            .hero-title-ornate::after {
                display: none;
            }
        }

        .fade-in {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s ease;
        }

        .fade-in.visible {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav id="navbar">
        <div class="logo">DORIAN</div>
        <div class="nav-links">
            <button class="btn-menu" onclick="scrollToSection('gallery')">Galerie</button>
            <button class="btn-menu" onclick="scrollToSection('gallery')">Contact</button>
        </div>
    </nav>

    <!-- Hero Immersif Style IRONHILL -->
    <section class="hero-immersive">
        <!-- Canvas vidéo background -->
        <canvas id="hero-video-canvas"></canvas>
        
        <!-- Overlay -->
        <div class="hero-overlay"></div>
        
        <!-- Contenu -->
        <div class="hero-content-immersive">
            <p class="hero-tagline-top">Entrez dans le</p>
            <h1 class="hero-title-ornate">DORIAN</h1>
            <p class="hero-subtitle-immersive">Cabinet de Curiosités Numériques</p>
            
            <div class="hero-cta-buttons">
                <button class="btn-hero btn-hero-primary" onclick="scrollToSection('gallery')">Explorer</button>
                <button class="btn-hero" onclick="toggleDropdown('drop-contacts')">Contact</button>
            </div>
        </div>
        
        <!-- Scroll indicator -->
        <div class="scroll-indicator-immersive">
            Scroll
        </div>
    </section>

    <!-- Galerie de Tableaux -->
    <section class="gallery-section" id="gallery">
        <div class="gallery-container">
            <h2 class="gallery-title fade-in">🖼️ Collection Macabre 🖼️</h2>
            
            <div class="paintings-grid">
                <div class="frame-container fade-in" onclick="toggleDropdown('drop-sys')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-sys"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Système</h3>
                        <p class="painting-description">Les Rouages</p>
                    </div>
                </div>

                <div class="frame-container fade-in" onclick="toggleDropdown('drop-projets')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-projets"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Œuvres</h3>
                        <p class="painting-description">Créations</p>
                    </div>
                </div>

                <div class="frame-container fade-in" onclick="toggleDropdown('drop-about')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-about"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">À Propos</h3>
                        <p class="painting-description">L'Artisan</p>
                    </div>
                </div>

                <div class="frame-container fade-in" onclick="toggleDropdown('drop-skills')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-skills"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Compétences</h3>
                        <p class="painting-description">Arsenal</p>
                    </div>
                </div>

                <div class="frame-container fade-in" onclick="toggleDropdown('drop-contacts')">
                    <div class="vintage-frame">
                        <canvas class="painting-canvas" id="canvas-contacts"></canvas>
                    </div>
                    <div class="painting-label">
                        <h3 class="painting-title">Contact</h3>
                        <p class="painting-description">Invocations</p>
                    </div>
                </div>

                <div class="frame-container fade-in" onclick="toggleDropdown('drop-blog')">
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

    <!-- Dropdowns (même contenu qu'avant) -->
<div id="drop-sys" class="dropdown">
    <div class="dropdown-content">
        <h2>⚙️ Système</h2>

        <!-- Horloge en temps réel -->
        <p>
            <strong>🕐 Heure :</strong> 
            <span id="sys-time" style="color: var(--accent-gold);">--:--:--</span>
        </p>

        <!-- Infos statiques du bash -->
             <p><strong>🌐 IP :</strong> $IP</p>
             <p><strong>⏱️ Uptime :</strong> <span id="live-uptime">Chargement...</span></p>
    <div class="stat-item" style="margin-bottom: 20px;">
    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
        <strong>💾 Utilisation RAM</strong>
        <span id="ram-text" style="color: #d4af37; font-weight: bold;">0%</span>
    </div>
    
    <div style="width: 100%; background: rgba(255,255,255,0.1); height: 12px; border-radius: 6px; overflow: hidden; border: 1px solid rgba(212, 175, 55, 0.3);">
        <div id="ram-bar" style="width: 0%; height: 100%; background: linear-gradient(90deg, #d4af37, #f2d06b); transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1); shadow: 0 0 10px rgba(212,175,55,0.5);"></div>
    </div>
    
    <small id="ram-details" style="color: #888; font-size: 0.8em;">Calcul des données...</small>
</div>
        <!-- Barre de disque visuelle -->
        <div style="margin-top: 1.5rem;">
            <p style="margin-bottom: 0.5rem;">
                <strong>📊 Utilisation Disque :</strong>
            </p>
            <div style="
                background: rgba(255,255,255,0.1);
                border-radius: 10px;
                height: 10px;
                overflow: hidden;
                border: 1px solid rgba(212,175,55,0.3);
            ">
                <div id="disk-bar" style="
                    height: 100%;
                    background: var(--gradient-gold);
                    width: 0%;
                    border-radius: 10px;
                    transition: width 1s ease;
                "></div>
            </div>
            <p id="disk-percent" style="
                font-size: 0.8rem;
                color: var(--text-secondary);
                margin-top: 0.3rem;
            ">Calcul...</p>
        </div>

        <!-- Système d'exploitation -->
        <p style="margin-top: 1rem;">
            <strong>🖥️ OS :</strong> Ubuntu 24.04 LTS
        </p>

        <!-- Dernière mise à jour -->
        <p style="
            margin-top: 2rem;
            font-size: 0.8rem;
            color: var(--text-muted);
            font-style: italic;
        ">
            Dernière mise à jour : 
            <span id="last-update">--</span>
        </p>
    </div>
</div>
    <div id="drop-projets" class="dropdown">
        <div class="dropdown-content">
            <h2>✨ Œuvres</h2>
            <div class="project-item">
                <h3>Application Web Sombre</h3>
                <p>Plateforme interactive avec animations 3D.</p>
            </div>
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

    <script>
        // ================================================================
        // HERO VIDEO BACKGROUND (Particules animées style forêt sombre)
        // ================================================================
        
        const heroCanvas = document.getElementById('hero-video-canvas');
        const heroCtx = heroCanvas.getContext('2d');
        
        heroCanvas.width = window.innerWidth;
        heroCanvas.height = window.innerHeight;
        
        // Particules de brume
        const particles = [];
        for(let i = 0; i < 100; i++) {
            particles.push({
                x: Math.random() * heroCanvas.width,
                y: Math.random() * heroCanvas.height,
                vx: (Math.random() - 0.5) * 0.5,
                vy: Math.random() * 0.5 + 0.2,
                radius: Math.random() * 60 + 20,
                opacity: Math.random() * 0.3 + 0.1
            });
        }
        
        function animateHeroBackground() {
            // Fond sombre avec gradient
            const gradient = heroCtx.createRadialGradient(
                heroCanvas.width / 2, heroCanvas.height / 2, 0,
                heroCanvas.width / 2, heroCanvas.height / 2, heroCanvas.width / 2
            );
            gradient.addColorStop(0, '#1a1520');
            gradient.addColorStop(1, '#0d0a12');
            heroCtx.fillStyle = gradient;
            heroCtx.fillRect(0, 0, heroCanvas.width, heroCanvas.height);
            
            // Dessiner les particules de brume
            particles.forEach(p => {
                p.x += p.vx;
                p.y += p.vy;
                
                // Reset si hors écran
                if(p.y > heroCanvas.height + 100) {
                    p.y = -100;
                    p.x = Math.random() * heroCanvas.width;
                }
                if(p.x < -100 || p.x > heroCanvas.width + 100) {
                    p.vx *= -1;
                }
                
                // Dessiner particule
                const particleGradient = heroCtx.createRadialGradient(p.x, p.y, 0, p.x, p.y, p.radius);
                particleGradient.addColorStop(0, `rgba(168, 85, 247, ${p.opacity})`);
                particleGradient.addColorStop(0.5, `rgba(168, 85, 247, ${p.opacity * 0.5})`);
                particleGradient.addColorStop(1, 'rgba(168, 85, 247, 0)');
                
                heroCtx.fillStyle = particleGradient;
                heroCtx.beginPath();
                heroCtx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
                heroCtx.fill();
            });
            
            requestAnimationFrame(animateHeroBackground);
        }
        
        animateHeroBackground();
        
        // Resize
        window.addEventListener('resize', () => {
            heroCanvas.width = window.innerWidth;
            heroCanvas.height = window.innerHeight;
        });

        // ================================================================
        // CANVAS TABLEAUX (même code qu'avant)
        // ================================================================
        
        function initGearsCanvas() {
            const canvas = document.getElementById('canvas-sys');
            const ctx = canvas.getContext('2d');
            canvas.width = canvas.offsetWidth;
            canvas.height = canvas.offsetHeight;
            
            let angle = 0;
            
            function drawGear(x, y, radius, teeth, rotation) {
                ctx.save();
                ctx.translate(x, y);
                ctx.rotate(rotation);
                
                ctx.beginPath();
                for(let i = 0; i < teeth * 2; i++) {
                    const angle = (i * Math.PI) / teeth;
                    const r = i % 2 === 0 ? radius : radius * 0.8;
                    const px = Math.cos(angle) * r;
                    const py = Math.sin(angle) * r;
                    if(i === 0) ctx.moveTo(px, py);
                    else ctx.lineTo(px, py);
                }
                ctx.closePath();
                ctx.strokeStyle = '#d4af37';
                ctx.lineWidth = 2;
                ctx.stroke();
                ctx.restore();
            }
            
            function animate() {
                ctx.fillStyle = 'rgba(0, 0, 0, 0.1)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                
                angle += 0.02;
                drawGear(canvas.width * 0.3, canvas.height * 0.4, 40, 8, angle);
                drawGear(canvas.width * 0.7, canvas.height * 0.6, 50, 10, -angle * 0.8);
                drawGear(canvas.width * 0.5, canvas.height * 0.5, 30, 6, angle * 1.2);
                
                requestAnimationFrame(animate);
            }
            animate();
        }

        function initParticlesCanvas() {
            const canvas = document.getElementById('canvas-projets');
            const ctx = canvas.getContext('2d');
            canvas.width = canvas.offsetWidth;
            canvas.height = canvas.offsetHeight;
            
            const particles = [];
            for(let i = 0; i < 50; i++) {
                particles.push({
                    x: Math.random() * canvas.width,
                    y: Math.random() * canvas.height,
                    vx: (Math.random() - 0.5) * 2,
                    vy: (Math.random() - 0.5) * 2,
                    radius: Math.random() * 2 + 1
                });
            }
            
            function animate() {
                ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                
                particles.forEach(p => {
                    p.x += p.vx;
                    p.y += p.vy;
                    if(p.x < 0 || p.x > canvas.width) p.vx *= -1;
                    if(p.y < 0 || p.y > canvas.height) p.vy *= -1;
                    
                    ctx.beginPath();
                    ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
                    ctx.fillStyle = '#a855f7';
                    ctx.fill();
                });
                
                requestAnimationFrame(animate);
            }
            animate();
        }

        function initSpiralCanvas() {
            const canvas = document.getElementById('canvas-about');
            const ctx = canvas.getContext('2d');
            canvas.width = canvas.offsetWidth;
            canvas.height = canvas.offsetHeight;
            
            let angle = 0;
            
            function animate() {
                ctx.fillStyle = 'rgba(0, 0, 0, 0.1)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                
                angle += 0.05;
                ctx.beginPath();
                for(let i = 0; i < 100; i++) {
                    const a = angle + i * 0.1;
                    const r = i * 2;
                    const x = canvas.width / 2 + Math.cos(a) * r;
                    const y = canvas.height / 2 + Math.sin(a) * r;
                    if(i === 0) ctx.moveTo(x, y);
                    else ctx.lineTo(x, y);
                }
                ctx.strokeStyle = '#60a5fa';
                ctx.lineWidth = 2;
                ctx.stroke();
                
                requestAnimationFrame(animate);
            }
            animate();
        }

        function initMatrixCanvas() {
            const canvas = document.getElementById('canvas-skills');
            const ctx = canvas.getContext('2d');
            canvas.width = canvas.offsetWidth;
            canvas.height = canvas.offsetHeight;
            
            const chars = '01アイウエオ';
            const columns = Math.floor(canvas.width / 20);
            const drops = Array(columns).fill(0);
            
            function animate() {
                ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                
                ctx.fillStyle = '#0f0';
                ctx.font = '15px monospace';
                
                drops.forEach((y, i) => {
                    const text = chars[Math.floor(Math.random() * chars.length)];
                    ctx.fillText(text, i * 20, y * 20);
                    if(y * 20 > canvas.height && Math.random() > 0.95) drops[i] = 0;
                    drops[i]++;
                });
                
                setTimeout(() => requestAnimationFrame(animate), 50);
            }
            animate();
        }

        function initWavesCanvas() {
            const canvas = document.getElementById('canvas-contacts');
            const ctx = canvas.getContext('2d');
            canvas.width = canvas.offsetWidth;
            canvas.height = canvas.offsetHeight;
            
            let time = 0;
            
            function animate() {
                ctx.fillStyle = 'rgba(0, 0, 0, 0.1)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                
                time += 0.05;
                for(let i = 0; i < 5; i++) {
                    ctx.beginPath();
                    for(let x = 0; x < canvas.width; x += 5) {
                        const y = canvas.height / 2 + Math.sin(x * 0.01 + time + i) * 30;
                        if(x === 0) ctx.moveTo(x, y);
                        else ctx.lineTo(x, y);
                    }
                    ctx.strokeStyle = `rgba(168, 85, 247, ${0.8 - i * 0.15})`;
                    ctx.lineWidth = 2;
                    ctx.stroke();
                }
                
                requestAnimationFrame(animate);
            }
            animate();
        }

        function initInkCanvas() {
            const canvas = document.getElementById('canvas-blog');
            const ctx = canvas.getContext('2d');
            canvas.width = canvas.offsetWidth;
            canvas.height = canvas.offsetHeight;
            
            const drops = [];
            
            function animate() {
                ctx.fillStyle = 'rgba(0, 0, 0, 0.02)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                
                if(Math.random() > 0.95) {
                    drops.push({
                        x: Math.random() * canvas.width,
                        y: 0,
                        speed: Math.random() * 3 + 2,
                        size: Math.random() * 20 + 10
                    });
                }
                
                drops.forEach((drop, i) => {
                    drop.y += drop.speed;
                    ctx.beginPath();
                    ctx.arc(drop.x, drop.y, drop.size, 0, Math.PI * 2);
                    ctx.fillStyle = 'rgba(139, 0, 0, 0.3)';
                    ctx.fill();
                    if(drop.y > canvas.height) drops.splice(i, 1);
                });
                
                requestAnimationFrame(animate);
            }
            animate();
        }

        window.addEventListener('load', () => {
            initGearsCanvas();
            initParticlesCanvas();
            initSpiralCanvas();
            initMatrixCanvas();
            initWavesCanvas();
            initInkCanvas();
        });
// ================================================================
// SYSTÈME - INFOS EN TEMPS RÉEL
// ================================================================

function updateSystemInfo() {
    // Horloge en temps réel
    const now = new Date();
    
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');
    
    const timeEl = document.getElementById('sys-time');
    if(timeEl) {
        timeEl.textContent = `${hours}:${minutes}:${seconds}`;
    }
    
    // Dernière mise à jour
    const updateEl = document.getElementById('last-update');
    if(updateEl) {
        const day = String(now.getDate()).padStart(2, '0');
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const year = now.getFullYear();
        updateEl.textContent = `${day}/${month}/${year} ${hours}:${minutes}:${seconds}`;
    }
}

// Barre de disque visuelle
function initDiskBar() {
    const diskText = '$DISK';  // Valeur du bash (ex: "50G")
    
    // Calculer le pourcentage utilisé
    const diskUsedPercent = parseInt('$DISK_USED_PERCENT') || 65;
    
    setTimeout(() => {
        const bar = document.getElementById('disk-bar');
        const label = document.getElementById('disk-percent');
        
        if(bar) {
            bar.style.width = diskUsedPercent + '%';
            
            // Couleur selon l'utilisation
            if(diskUsedPercent > 80) {
                bar.style.background = '#8b0000';  // Rouge si plein
            } else if(diskUsedPercent > 60) {
                bar.style.background = '#d4af37';  // Or si moyen
            } else {
                bar.style.background = 'linear-gradient(135deg, #a855f7, #60a5fa)';  // Violet si ok
            }
        }
        
        if(label) {
            label.textContent = `${diskUsedPercent}% utilisé - $DISK disponible`;
        }
    }, 500);
}

// Démarrer l'horloge
setInterval(updateSystemInfo, 1000);
updateSystemInfo();
initDiskBar();

        // ================================================================
        // INTERACTIONS
        // ================================================================
        
        const navbar = document.getElementById('navbar');

        window.addEventListener('scroll', () => {
            if (window.pageYOffset > 100) navbar.classList.add('scrolled');
            else navbar.classList.remove('scrolled');
        });

        const overlay = document.createElement('div');
        overlay.className = 'dropdown-overlay';
        document.body.appendChild(overlay);

        let currentDropdown = null;

        function toggleDropdown(id) {
            const dropdown = document.getElementById(id);
            if (currentDropdown === dropdown && dropdown.classList.contains('active')) {
                closeAllDropdowns();
                return;
            }
            closeAllDropdowns();
            dropdown.classList.add('active');
            overlay.classList.add('active');
            currentDropdown = dropdown;
        }

        function closeAllDropdowns() {
            document.querySelectorAll('.dropdown').forEach(d => d.classList.remove('active'));
            overlay.classList.remove('active');
            currentDropdown = null;
        }

        overlay.addEventListener('click', closeAllDropdowns);
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') closeAllDropdowns();
        });

        function scrollToSection(id) {
            document.getElementById(id).scrollIntoView({ behavior: 'smooth' });
        }

        const observer = new IntersectionObserver((entries) => {
            entries.forEach((entry, i) => {
                if (entry.isIntersecting) {
                    setTimeout(() => entry.target.classList.add('visible'), i * 150);
                }
            });
        }, { threshold: 0.15 });

        document.querySelectorAll('.fade-in').forEach(el => observer.observe(el));
function fetchLiveStats() {
    fetch('stats.php')
        .then(response => response.json())
        .then(data => {
            // Met à jour l'uptime et la RAM en direct
            const uptimeEl = document.getElementById('live-uptime');
            const ramEl = document.getElementById('live-ram');
            
            if(uptimeEl) uptimeEl.textContent = data.uptime;
            if(ramEl) ramEl.textContent = data.ram;
        })
        .catch(err => console.error("Erreur de stats:", err));
}

// Lancement de la boucle temps réel
setInterval(fetchLiveStats, 2000);
fetchLiveStats();
    
     </script>

</body>
</html>
EOF

echo "✅ Portfolio avec Hero Immersif IRONHILL généré !"
echo "🎬 Video background avec particules"
echo "🦇 Ornements gothiques Burton"
echo "🚀 Ouvrez http://localhost"

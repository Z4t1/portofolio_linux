#!/bin/bash

FICHIER_HTML="/var/www/html/index.html"
IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p)
DISK=$(df -h / | awk 'NR==2 {print $4}')

cat <<EOF > $FICHIER_HTML
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Les Chroniques de Dorian</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Almendra:wght@700&family=Metamorphous&display=swap');

        body {
            margin: 0; overflow: hidden; background: #0a0e14;
            color: #d4af37; font-family: 'Metamorphous', serif;
            display: flex; justify-content: center; align-items: center; height: 100vh;
        }
        #canvas3d { position: fixed; top: 0; left: 0; z-index: -1; }

        /* Style Gothique/Féerique */
        .grimoire {
            background: rgba(15, 20, 25, 0.85);
            backdrop-filter: blur(8px);
            border: 2px solid #5d4037;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 0 30px rgba(0,0,0,0.9), inset 0 0 20px rgba(212, 175, 55, 0.1);
            border-image: radial-gradient(#d4af37, #5d4037) 1;
            text-align: center; z-index: 1;
            max-width: 600px;
        }

        h1 { font-family: 'Almendra', serif; font-size: 2.5em; color: #d4af37; text-shadow: 2px 2px 10px rgba(0,0,0,0.5); margin-bottom: 10px; }
        
        .container { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 25px; }
        
        .artefact {
            background: rgba(45, 30, 20, 0.4);
            border: 1px solid #d4af37;
            padding: 15px; border-radius: 10px;
            transition: 0.3s;
        }
        .artefact:hover { transform: scale(1.05); box-shadow: 0 0 15px #d4af37; }

        .label { font-size: 0.7em; letter-spacing: 2px; color: #8d6e63; text-transform: uppercase; }
        .value { font-size: 1.1em; color: #e0e0e0; }
        
        #horloge { font-size: 2.2em; color: #d4af37; margin: 15px 0; font-family: 'Almendra', serif; }
    </style>
</head>
<body>

    <canvas id="canvas3d"></canvas>

    <div class="grimoire">
        <h1>Les Chroniques de Dorian</h1>
        <div id="horloge">--:--:--</div>
        
        <div class="container">
            <div class="artefact">
                <div class="label">Miroir des Mondes</div>
                <div class="value">$IP</div>
            </div>
            <div class="artefact">
                <div class="label">Reliquaire</div>
                <div class="value">$DISK Libre</div>
            </div>
            <div class="artefact" style="grid-column: span 2;">
                <div class="label">Éveil du Serveur</div>
                <div class="value">$UPTIME</div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script>
        // --- Animation 3D (Lucioles/Poussière d'étoiles) ---
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('canvas3d'), alpha: true });
        renderer.setSize(window.innerWidth, window.innerHeight);

        const particlesGeom = new THREE.BufferGeometry();
        const count = 800;
        const posArray = new Float32Array(count * 3);

        for(let i = 0; i < count * 3; i++) {
            posArray[i] = (Math.random() - 0.5) * 10;
        }
        particlesGeom.setAttribute('position', new THREE.BufferAttribute(posArray, 3));

        const material = new THREE.PointsMaterial({
            size: 0.015,
            color: '#d4af37',
            transparent: true,
            opacity: 0.6
        });

        const particlesMesh = new THREE.Points(particlesGeom, material);
        scene.add(particlesMesh);
        camera.position.z = 3;

        function animate() {
            requestAnimationFrame(animate);
            particlesMesh.rotation.y += 0.001;
            particlesMesh.rotation.x += 0.0005;
            renderer.render(scene, camera);
        }
        animate();

        // Horloge temps réel
        setInterval(() => {
            const d = new Date();
            document.getElementById('horloge').innerText = d.toLocaleTimeString('fr-FR');
        }, 1000);
    </script>
</body>
</html>
EOF

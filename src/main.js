// Three.js'i CDN üzerinden, Skypack kullanarak içe aktar
import * as THREE from 'https://cdn.skypack.dev/three@0.136.0';

// --- Sahne Kurulumu ---
const scene = new THREE.Scene();
scene.background = new THREE.Color(0x0a0a0a);
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

camera.position.z = 15;

// --- Temel Işıklandırma ---
const ambientLight = new THREE.AmbientLight(0xffffff, 0.2);
scene.add(ambientLight);
const pointLight = new THREE.PointLight(0xffffff, 0.8);
camera.add(pointLight);
scene.add(camera);

// --- Zemin (Grid) ---
const gridHelper = new THREE.GridHelper(100, 100, 0x880088, 0x444444);
scene.add(gridHelper);

// --- Oyun Nesneleri ---
const geometry = new THREE.BoxGeometry();
const material = new THREE.MeshStandardMaterial({ color: 0x00ff00 });
const player = new THREE.Mesh(geometry, material);
player.position.y = 0.5;
scene.add(player);

// --- Kontroller ve Savaş Mekaniği ---
let isAttacking = false;
const originalPlayerColor = player.material.color.clone();
const originalPlayerPosition = player.position.clone();

function attack() {
    if (isAttacking) return;
    isAttacking = true;

    player.material.color.set(0xff0000); // Kırmızıya dön

    // Basit bir ileri atılma ve geri dönme animasyonu
    const forwardPosition = new THREE.Vector3(player.position.x, player.position.y, player.position.z - 2);

    // Animasyon süresi
    const duration = 150; // ms

    // İleri hareket
    new TWEEN.Tween(player.position)
        .to(forwardPosition, duration / 2)
        .easing(TWEEN.Easing.Quadratic.Out)
        .onComplete(() => {
            // Geri hareket
            new TWEEN.Tween(player.position)
                .to(originalPlayerPosition, duration / 2)
                .easing(TWEEN.Easing.Quadratic.In)
                .onComplete(() => {
                    player.material.color.copy(originalPlayerColor); // Rengi geri al
                    isAttacking = false;
                })
                .start();
        })
        .start();
}

// Tween.js'i de CDN'den import etmemiz gerekiyor. Onu script'e ekliyorum.
const tweenScript = document.createElement('script');
tweenScript.src = "https://cdn.skypack.dev/@tweenjs/tween.js@18.6.4/dist/tween.umd.js";
document.body.appendChild(tweenScript);


window.addEventListener('keydown', (event) => {
    if (event.code === 'Space') {
        attack();
    }
});

// --- Oyun Döngüsü ---
function animate() {
    requestAnimationFrame(animate);

    // Tween'i güncelle
    if (window.TWEEN) {
        TWEEN.update();
    }

    renderer.render(scene, camera);
}

// --- Pencere Boyutlandırma ---
window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});

animate();

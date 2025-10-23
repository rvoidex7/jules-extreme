// Three.js'i CDN üzerinden, Skypack kullanarak içe aktar
import * as THREE from 'https://cdn.skypack.dev/three@0.136.0';

console.log("Bağımlılıklar CDN üzerinden yüklendi. Synthwave Samurai motoru başlatılıyor...");

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
const playerGeometry = new THREE.BoxGeometry();
const playerMaterial = new THREE.MeshStandardMaterial({ color: 0x00ff00 });
const player = new THREE.Mesh(playerGeometry, playerMaterial);
player.position.set(0, 0.5, 0);
scene.add(player);

const npcGeometry = new THREE.BoxGeometry();
const npcMaterial = new THREE.MeshStandardMaterial({ color: 0x0000ff }); // NPC'nin rengi mavi
const npc = new THREE.Mesh(npcGeometry, npcMaterial);
npc.position.set(5, 0.5, 0); // NPC'nin pozisyonu
scene.add(npc);

console.log("Oyuncu ve NPC sahneye eklendi.");

// --- Diyalog Sistemi ---
const dialogueBox = document.getElementById('dialogue-box');
const interactionDistance = 3; // Etkileşim mesafesi

function checkInteraction() {
    const distance = player.position.distanceTo(npc.position);
    if (distance <= interactionDistance) {
        dialogueBox.style.display = 'block';
    } else {
        dialogueBox.style.display = 'none';
    }
}

// --- Kontroller (Basit Oyuncu Hareketi) ---
const moveSpeed = 0.1;
const keys = {};
window.addEventListener('keydown', (event) => keys[event.code] = true);
window.addEventListener('keyup', (event) => keys[event.code] = false);

function handleControls() {
    if (keys['ArrowUp']) player.position.z -= moveSpeed;
    if (keys['ArrowDown']) player.position.z += moveSpeed;
    if (keys['ArrowLeft']) player.position.x -= moveSpeed;
    if (keys['ArrowRight']) player.position.x += moveSpeed;
}

console.log("Kontroller hazır. Oyuncuyu ok tuşlarıyla hareket ettirin.");

// --- Oyun Döngüsü ---
function animate() {
    requestAnimationFrame(animate);

    handleControls(); // Oyuncu hareketini işle
    checkInteraction(); // NPC ile etkileşimi kontrol et

    renderer.render(scene, camera);
}

// --- Pencere Boyutlandırma ---
window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});

console.log("Oyun döngüsü başlatıldı.");
animate();

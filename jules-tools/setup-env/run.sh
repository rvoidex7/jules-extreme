#!/bin/bash

# --- Setup Environment Tool ---
# This script prepares the development environment from scratch.
# It should be customized to fit the specific needs of the project.

echo "🚀 Geliştirme ortamı kurulumu başlıyor..."
echo "--------------------------------------------------"

# Adım 1: Bağımlılıkların Kurulumu
# Projenizin paket yöneticisine göre bu kısmı düzenleyin (npm, pip, vs.).
echo "📦 Bağımlılıklar kuruluyor..."
if [ -f "package.json" ]; then
    echo "Node.js projesi algılandı. npm install çalıştırılıyor..."
    # npm install
elif [ -f "requirements.txt" ]; then
    echo "Python projesi algılandı. pip install çalıştırılıyor..."
    # pip install -r requirements.txt
else
    echo "⚠️ Proje tipi anlaşılamadı. Bağımlılık kurulumu atlanıyor."
fi
echo "--------------------------------------------------"


# Adım 2: Veritabanı Kurulumu (Gerekirse)
# Eğer projeniz Docker veya başka bir veritabanı kullanıyorsa, ilgili komutları buraya ekleyin.
echo "🗃️ Veritabanı kontrol ediliyor..."
if [ -f "docker-compose.yml" ]; then
    echo "docker-compose.yml algılandı. Konteynerler başlatılıyor..."
    # docker-compose up -d
    echo "Veritabanı migration/seeding işlemleri yapılıyor..."
    # npx sequelize-cli db:migrate
    # npx sequelize-cli db:seed:all
else
    echo "Veritabanı kurulum adımı atlanıyor."
fi
echo "--------------------------------------------------"


# Adım 3: Yapılandırma Dosyaları
# .env dosyası gibi yapılandırma dosyalarını oluşturmak için bu bölümü kullanın.
echo "⚙️ Yapılandırma dosyaları oluşturuluyor..."
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    echo ".env.example dosyasından .env oluşturuluyor..."
    # cp .env.example .env
else
    echo "Yapılandırma dosyası adımı atlanıyor."
fi
echo "--------------------------------------------------"

echo "✅ Geliştirme ortamı başarıyla kuruldu ve hazır."
echo "Jules şimdi göreve başlayabilir."

# Not: Bu betikteki komutlar, projenize uyacak şekilde aktif edilmelidir (yorum satırları kaldırılmalıdır).

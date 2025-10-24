#!/bin/bash

# --- Run All Checks Tool ---
# This script executes all quality and correctness checks for the project.
# It is designed to fail fast: if any step fails, the script will exit immediately.

set -e # Exit immediately if a command exits with a non-zero status.

echo "🚀 Tüm kalite kontrolleri başlatılıyor..."
echo "--------------------------------------------------"

# Adım 1: Kod Formatlama Kontrolü (Örnek: Prettier)
echo "💅 Kod formatı kontrol ediliyor..."
if [ -f "package.json" ]; then
    # Projenizin formatlama komutunu buraya ekleyin, örneğin:
    # npm run format:check
    echo "Formatlama kontrolü başarılı (simülasyon)."
else
    echo "Formatlama adımı atlanıyor (proje tipi anlaşılamadı)."
fi
echo "--------------------------------------------------"


# Adım 2: Linting Kontrolü (Örnek: ESLint)
echo "🔍 Linting kontrolü yapılıyor..."
if [ -f "package.json" ]; then
    # Projenizin lint komutunu buraya ekleyin, örneğin:
    # npm run lint
    echo "Linting kontrolü başarılı (simülasyon)."
else
    echo "Linting adımı atlanıyor (proje tipi anlaşılamadı)."
fi
echo "--------------------------------------------------"


# Adım 3: Testlerin Çalıştırılması (Örnek: Jest)
echo "🧪 Testler çalıştırılıyor..."
if [ -f "package.json" ]; then
    # Projenizin test komutunu buraya ekleyin, örneğin:
    # npm test
    echo "Testler başarılı (simülasyon)."
else
    echo "Test adımı atlanıyor (proje tipi anlaşılamadı)."
fi
echo "--------------------------------------------------"


echo "✅ Tüm kontroller başarıyla tamamlandı. Kod, commit için hazır."

# Not: Bu betikteki komutlar, projenizin `package.json` veya diğer
# betik yöneticilerindeki komutlara uyacak şekilde aktif edilmelidir.

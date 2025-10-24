#!/bin/bash
set -e

echo "🛠️  Geliştirme ortamı bağımlılıkları kuruluyor..."

# Bu ortamda NPM tabanlı kurulumlar yapılamamaktadır.
# Bu betik, Python tabanlı araçların gerektirdiği bağımlılıkları kurmaya odaklanmıştır.

REQUIREMENTS_FILE="jules-tools/generate-art/requirements.txt"

if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "  -> Python bağımlılıkları '$REQUIREMENTS_FILE' dosyasından kuruluyor..."
    pip install -r "$REQUIREMENTS_FILE"
    echo "  ✅ Python bağımlılıkları başarıyla kuruldu."
else
    echo "  ⚠️  Uyarı: '$REQUIREMENTS_FILE' bulunamadı. Python bağımlılıkları kurulmadı."
fi

echo "✅ Ortam kurulumu tamamlandı."

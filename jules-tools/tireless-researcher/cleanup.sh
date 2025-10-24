#!/bin/bash
set -e

# --- Aracın bulunduğu dizini al ---
TOOL_DIR=$(dirname "$0")

# --- Girdi Doğrulaması ---
if [ -z "$1" ]; then
    echo "Hata: Temizlenecek bir görev ID'si sağlamalısınız."
    echo "Kullanım: $0 <görev_id>"
    exit 1
fi

TASK_ID="$1"
TASK_DIR="${TOOL_DIR}/tasks/${TASK_ID}"
VARIANT_DIR="${TOOL_DIR}/variants/${TASK_ID}"

echo "Aşağıdaki dizinler ve içerikleri kalıcı olarak silinecek:"
FOUND_PATHS=false

if [ -d "$TASK_DIR" ]; then
    echo "  - Günlük Dizini: ${TASK_DIR}"
    FOUND_PATHS=true
fi

if [ -d "$VARIANT_DIR" ]; then
    echo "  - Varyant Dizini: ${VARIANT_DIR}"
    FOUND_PATHS=true
fi

if ! $FOUND_PATHS ; then
    echo "Uyarı: '${TASK_ID}' görevine ait hiçbir dizin bulunamadı. Zaten temizlenmiş olabilir."
    exit 0
fi

# --- Onay İstemi ---
read -p "Bu işlemi onaylıyor musunuz? (e/h): " a
if [[ "$a" != "e" && "$a" != "E" ]]; then
    echo "İşlem iptal edildi."
    exit 1
fi

# --- Silme Mantığı ---
echo "Temizleme işlemi başlatılıyor..."

if [ -d "$TASK_DIR" ]; then
    rm -rf "$TASK_DIR"
    echo "  -> '${TASK_DIR}' silindi."
fi

if [ -d "$VARIANT_DIR" ]; then
    rm -rf "$VARIANT_DIR"
    echo "  -> '${VARIANT_DIR}' silindi."
fi

echo "✅ Temizleme işlemi başarıyla tamamlandı."

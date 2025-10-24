#!/bin/bash
set -e

# --- Parametreleri Ayrıştırma ---
PROMPT=""
DEADLINE=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --prompt) PROMPT="$2"; shift ;;
        --deadline) DEADLINE="$2"; shift ;;
        *) echo "Bilinmeyen parametre: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$PROMPT" ] || [ -z "$DEADLINE" ]; then
    echo "Kullanım: $0 --prompt \"görev tanımı\" --deadline \"<süre>h\""
    exit 1
fi

# --- Görev Altyapısını Hazırlama ---
TOOL_DIR=$(dirname "$0")
TASK_ID=$(date +%Y%m%d-%H%M%S)-$(uuidgen | cut -d'-' -f1)
TASK_DIR="${TOOL_DIR}/tasks/${TASK_ID}"
LOG_FILE="${TASK_DIR}/progress.log"
WORKER_SCRIPT="${TOOL_DIR}/worker.sh"

mkdir -p "$TASK_DIR"

# --- Çalışan Betiği (Worker) Arka Plana Atama ---
echo "--- YORULMAZ ARAŞTIRMACI v2.0 ---" > "$LOG_FILE"
echo "Görev ID: ${TASK_ID}" | tee -a "$LOG_FILE"
echo "Başlangıç Zamanı: $(date)" | tee -a "$LOG_FILE"
echo "Verilen Görev: ${PROMPT}" | tee -a "$LOG_FILE"
echo "Bitiş Zamanı (Deadline): ${DEADLINE} sonra" | tee -a "$LOG_FILE"
echo "------------------------------------" | tee -a "$LOG_FILE"

# Worker betiğini, tüm değişkenleri aktararak arka planda çalıştır
PROMPT="$PROMPT" DEADLINE="$DEADLINE" TASK_ID="$TASK_ID" bash "$WORKER_SCRIPT" >> "$LOG_FILE" 2>&1 &

# --- Kullanıcıya Anında Geri Bildirim ---
echo "✅ Otonom görev başarıyla arka planda başlatıldı."
echo "   Görev ID: ${TASK_ID}"
echo "   İlerlemeyi takip etmek için:"
echo "   tail -f ${LOG_FILE}"
echo ""
exit 0

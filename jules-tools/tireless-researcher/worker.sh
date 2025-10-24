#!/bin/bash
set -e

# --- Loglama Yardımcı Fonksiyonu ---
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$1] $2"
}

# --- Görev Başlangıcı ---
log "INFO" "Worker süreci başlatıldı. Görev ID: ${TASK_ID}"
START_TIME_SECONDS=$(date +%s)

TOOL_DIR=$(dirname "$0")
VARIANTS_DIR="${TOOL_DIR}/variants/${TASK_ID}"
PROJECT_ROOT="./" # Kopyalanacak projenin kök dizini

log "INFO" "Varyantlar için ana dizin oluşturuluyor: ${VARIANTS_DIR}"
mkdir -p "$VARIANTS_DIR"

# --- Otonom Görev Mantığı ---
# Bu kısım, Jules'un kendi planını oluşturup uygulayacağı yerdir.
# Şimdilik, bu test için önceden tanımlanmış bir planı simüle edeceğiz.

# --- VARYANT A: Savaş Sistemi Geliştirme ---
(
    VARIANT_A_DIR="${VARIANTS_DIR}/variant-A-CombatSystem"
    log "INFO" "Varyant A başlatılıyor. Kopyalanıyor: ${VARIANT_A_DIR}"
    # Projenin temiz bir kopyasını oluştur (logları ve görevleri hariç tut)
    rsync -av --progress "${PROJECT_ROOT}" "${VARIANT_A_DIR}" --exclude "jules-tools/tireless-researcher/tasks" --exclude "jules-tools/tireless-researcher/variants"

    log "INFO" "[Varyant A] Proje ortamı kuruluyor..."
    # Bu varyant için gerekli adımlar burada çalıştırılır.
    # Örneğin: cp jules-tools/templates/combat_system.js "${VARIANT_A_DIR}/projects/synthwave-samurai/src/main.js"
    # Şimdilik sadece bir bekleme süresi ekleyerek iş simüle ediyoruz.
    sleep 10
    log "SUCCESS" "[Varyant A] Savaş sistemi prototipi başarıyla tamamlandı."
)

# --- VARYANT B: Diyalog Sistemi Geliştirme ---
(
    VARIANT_B_DIR="${VARIANTS_DIR}/variant-B-DialogueSystem"
    log "INFO" "Varyant B başlatılıyor. Kopyalanıyor: ${VARIANT_B_DIR}"
    rsync -av --progress "${PROJECT_ROOT}" "${VARIANT_B_DIR}" --exclude "jules-tools/tireless-researcher/tasks" --exclude "jules-tools/tireless-researcher/variants"

    log "INFO" "[Varyant B] Proje ortamı kuruluyor..."
    sleep 10
    log "SUCCESS" "[Varyant B] Diyalog sistemi prototipi başarıyla tamamlandı."
)

# --- Görev Sonu ve Zamanlama Analizi ---
END_TIME_SECONDS=$(date +%s)
ELAPSED_SECONDS=$((END_TIME_SECONDS - START_TIME_SECONDS))

# Deadline'ı saniyeye çevir (örneğin "2h" -> 7200)
DEADLINE_HOURS=$(echo "$DEADLINE" | sed 's/h//')
DEADLINE_SECONDS=$((DEADLINE_HOURS * 3600))

log "INFO" "Tüm varyantlar tamamlandı."
log "INFO" "Geçen Süre: ${ELAPSED_SECONDS} saniye."
log "INFO" "Verilen Süre: ${DEADLINE_SECONDS} saniye."

if [ "$ELAPSED_SECONDS" -gt "$DEADLINE_SECONDS" ]; then
    log "WARNING" "Görev, verilen süreyi aştı!"
else
    log "INFO" "Görev, verilen süre içinde başarıyla tamamlandı."
fi

log "INFO" "Worker süreci sonlandırıldı."
exit 0

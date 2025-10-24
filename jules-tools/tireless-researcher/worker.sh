#!/bin/bash
set -e

# --- Loglama Yardımcı Fonksiyonu ---
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$1] $2"
}

# --- Proje Kopyalama Fonksiyonu ---
copy_project() {
    local dest_dir="$1"
    log "INFO" "Proje, '$dest_dir' dizinine kopyalanıyor..."
    mkdir -p "$dest_dir"
    # Kök dizindeki her şeyi, 'jules-tools' hariç, kopyala.
    # Bu, 'cp: cannot copy a directory into itself' hatasını önler.
    find . -mindepth 1 -maxdepth 1 -not -path './jules-tools' -exec cp -r '{}' "$dest_dir" \;
    log "INFO" "Proje kopyalama tamamlandı."
}

# --- Görev Başlangıcı ---
log "INFO" "Worker süreci başlatıldı. Görev ID: ${TASK_ID}"
START_TIME_SECONDS=$(date +%s)

TOOL_DIR=$(dirname "$0")
VARIANTS_DIR="${TOOL_DIR}/variants/${TASK_ID}"

log "INFO" "Varyantlar için ana dizin oluşturuluyor: ${VARIANTS_DIR}"
mkdir -p "$VARIANTS_DIR"

# --- Otonom Görev Mantığı v1.2 ---
# Hatalı 'cp' komutu, 'find' kullanan daha güvenli bir fonksiyonla değiştirildi.

log "INFO" "Görev analizi: '${PROMPT}'"

# Basit bir anahtar kelime analizi
if [[ "$PROMPT" == *"component"* ]]; then
    log "INFO" "'component' anahtar kelimesi algılandı. Component oluşturma varyantları başlatılıyor."

    # --- VARYANT A: Standart Component ---
    (
        VARIANT_A_DIR="${VARIANTS_DIR}/variant-A-StandardComponent"
        copy_project "$VARIANT_A_DIR"

        log "INFO" "[Varyant A] Yeni component dosyası oluşturuluyor..."
        # Varyant klasöründe 'projects' dizini olmayabilir, bu yüzden oluştur.
        mkdir -p "${VARIANT_A_DIR}/projects/synthwave-samurai/src"
        OUTPUT_FILE="${VARIANT_A_DIR}/projects/synthwave-samurai/src/StandardComponent.js"
        echo "// Variant A: Standard Component created by Jules" > "$OUTPUT_FILE"
        log "SUCCESS" "[Varyant A] Component başarıyla oluşturuldu: ${OUTPUT_FILE}"
    ) &

    # --- VARYANT B: Class-based Component ---
    (
        VARIANT_B_DIR="${VARIANTS_DIR}/variant-B-ClassComponent"
        copy_project "$VARIANT_B_DIR"

        log "INFO" "[Varyant B] Class-based component dosyası oluşturuluyor..."
        mkdir -p "${VARIANT_B_DIR}/projects/synthwave-samurai/src"
        OUTPUT_FILE="${VARIANT_B_DIR}/projects/synthwave-samurai/src/ClassComponent.js"
        echo "// Variant B: Class-based Component created by Jules" > "$OUTPUT_FILE"
        log "SUCCESS" "[Varyant B] Component başarıyla oluşturuldu: ${OUTPUT_FILE}"
    ) &

else
    log "WARNING" "Prompt için tanımlanmış bir eylem bulunamadı. Basit bir dosya oluşturulacak."
    # --- Varsayılan Varyant ---
    (
        VARIANT_DEFAULT_DIR="${VARIANTS_DIR}/variant-Default"
        copy_project "$VARIANT_DEFAULT_DIR"

        log "INFO" "[Varsayılan Varyant] Bir test dosyası oluşturuluyor..."
        OUTPUT_FILE="${VARIANT_DEFAULT_DIR}/test_output.txt"
        echo "Jules was here. Prompt: ${PROMPT}" > "$OUTPUT_FILE"
        log "SUCCESS" "[Varsayılan Varyant] Test dosyası oluşturuldu: ${OUTPUT_FILE}"
    ) &
fi

# Tüm arka plan işlemlerinin bitmesini bekle
wait
log "INFO" "Tüm varyant geliştirme süreçleri tamamlandı."


# --- Görev Sonu ve Zamanlama Analizi ---
END_TIME_SECONDS=$(date +%s)
ELAPSED_SECONDS=$((END_TIME_SECONDS - START_TIME_SECONDS))

DEADLINE_HOURS=$(echo "$DEADLINE" | sed 's/h//')
DEADLINE_SECONDS=$((DEADLINE_HOURS * 3600))

log "INFO" "Geçen Süre: ${ELAPSED_SECONDS} saniye."
log "INFO" "Verilen Süre: ${DEADLINE_SECONDS} saniye."

if [ "$ELAPSED_SECONDS" -gt "$DEADLINE_SECONDS" ]; then
    log "WARNING" "Görev, verilen süreyi aştı!"
else
    log "INFO" "Görev, verilen süre içinde başarıyla tamamlandı."
fi

log "INFO" "Worker süreci sonlandırıldı."
exit 0

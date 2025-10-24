# Yorulmaz Araştırmacı Modu (Tireless Researcher) v2.0

Bu araç, Jules'a verilen karmaşık ve uzun süreli görevleri, kullanıcı müdahalesi olmadan, otonom bir şekilde yürütmesi için bir çerçeve sağlar. Geleneksel "sıra tabanlı" etkileşim modelinin dışına çıkarak, görevleri arka plan süreçleri olarak yönetir.

## Temel Felsefe
- **Otonomi:** Jules, bir görev verildiğinde durup onay beklemez. Belirlenen süre (deadline) içinde en iyi sonuca ulaşmak için otonom olarak çalışır.
- **Varyant Keşfi:** Bir sorunu çözmek için birden fazla yaklaşım varsa, Jules bu yaklaşımları paralel "varyantlar" olarak dener. Bu sürüm, `git` yerine **klasör tabanlı varyant yönetimini** kullanır.
- **Sürekli Gözlem:** Tüm ilerleme, anlık olarak bir log dosyasına kaydedilir. Bu sayede görev devam ederken süreci "fırının camından" izlemek mümkündür.

## Kullanım

Araç, `run.sh` betiği aracılığıyla çalıştırılır ve iki zorunlu parametre alır:

```bash
./jules-tools/tireless-researcher/run.sh --prompt "görev tanımı" --deadline "<süre>h"
```

- `--prompt`: Jules'un üzerinde çalışacağı görevin net ve detaylı açıklaması.
- `--deadline`: Görevin tamamlanması için verilen maksimum süre (saat cinsinden, örn: "2h", "24h").

### Örnek Çalıştırma

```bash
./jules-tools/tireless-researcher/run.sh \
  --prompt "Synthwave Samurai projesi için hem savaş hem de diyalog mekaniklerini içeren iki farklı prototip geliştir ve sonuçlarını karşılaştır." \
  --deadline "4h"
```

## Çalışma Mekanizması

1.  **Başlatıcı (`run.sh`):**
    - Komutu aldığında, `tasks/` altında benzersiz bir **Görev ID'si** (`<task_id>`) ile yeni bir görev klasörü oluşturur.
    - Görevin tüm çıktılarının kaydedileceği bir `progress.log` dosyası yaratır.
    - Asıl işi yapacak olan `worker.sh` betiğini, gerekli tüm bilgilerle birlikte bir **arka plan sürecine (`&`)** atar.
    - Kullanıcıya anında görev ID'sini ve log dosyasının yolunu bildirerek kontrolü geri verir.

2.  **Çalışan (`worker.sh`):**
    - Arka planda sessizce çalışır.
    - Yaptığı her önemli adımı (`Varyant A başlatıldı`, `Adım 1 tamamlandı` vb.) zaman damgasıyla `progress.log` dosyasına yazar.
    - Her bir varyant için, projenin o anki temiz bir kopyasını `variants/<task_id>/<variant_adı>/` klasörüne oluşturur. Tüm çalışmalar bu izole klasörler içinde yapılır.
    - Görev tamamlandığında veya süre dolduğunda, toplam harcanan süreyi hesaplar ve son bir raporla log dosyasını güncelleyerek sürecini sonlandırır.

## İlerlemeyi Takip Etme

Bir görev başlatıldıktan sonra, ilerlemesini anlık olarak takip etmek için `tail` komutunu kullanabilirsiniz:

```bash
tail -f jules-tools/tireless-researcher/tasks/<görev_id_buraya_gelecek>/progress.log
```

## Görev Sonrası Temizlik

Araç, her görev için geçici çalışma dizinleri (`tasks/` ve `variants/` altında) oluşturur. Bir görev tamamlandıktan ve sonuçları incelendikten sonra, bu ara dosyaları `cleanup.sh` betiği ile güvenli bir şekilde silebilirsiniz.

```bash
./jules-tools/tireless-researcher/cleanup.sh <görev_id_buraya_gelecek>
```

- `<görev_id>`: (Zorunlu) `run.sh` komutunun size verdiği, temizlenecek görevin kimliği.

Betik, yanlışlıkla veri kaybını önlemek için silme işleminden önce sizden onay isteyecektir.

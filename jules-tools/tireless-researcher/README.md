# Jules Tool: Tireless Researcher Mode

## 1. Amaç

Bu araç, Jules'a verilen bir görevi, belirtilen bir süre boyunca otonom olarak araştırma ve geliştirme yaparak mümkün olan en iyi çözümü bulması için görevlendirir.

Bu mod, basit bir "görevi tamamla" komutundan ziyade, Jules'u proaktif bir Ar-Ge asistanına dönüştürür. Jules, farklı algoritmaları, kodlama desenlerini, dilleri ve yaklaşımları deneyerek bir dizi "varyant" üretir. Süre sonunda, bu varyantları objektif olarak karşılaştırır ve en iyi çözümü bir raporla birlikte sunar.

## 2. Kullanım

Bu araç, `run.sh` betiği aracılığıyla kullanılır. Betik, aşağıdaki parametreleri alacak şekilde tasarlanacaktır:

```bash
./run.sh --task-prompt "Buraya görevin detaylı açıklaması yazılır" --deadline "YYYY-MM-DD HH:MM:SS" --optimization-goal "performans"
```

- `--task-prompt`: (Zorunlu) Jules'un üzerinde çalışacağı görevin net ve detaylı açıklaması.
- `--deadline`: (Zorunlu) Jules'un çalışmayı durduracağı kesin bitiş zamanı (UTC formatında).
- `--optimization-goal`: (İsteğe Bağlı, Varsayılan: `performans`) Optimizasyonun ana hedefini belirtir. Olası değerler: `performans`, `okunabilirlik`, `güvenlik`, `kod-kisaligi`, `bagimliliklari-azaltma`.

## 3. Çalışma Mekanizması ve Varyant Yönetimi

Bu araç, kod varyantlarını yönetmek için **hibrit bir model** kullanır:

- **Kod ve Geçmiş Git Branch'lerinde Yaşar:** Her bir varyant, `jules-variant/<varyant-adi>` adlandırma kuralına uygun ayrı bir yerel Git branch'inde geliştirilir. Bu, kod karşılaştırması (`git diff`) ve geçmiş takibi (`git log`) için maksimum esneklik sağlar.

- **Özetler ve Raporlar Klasörlerde Saklanır:**
    - `variants/`: Bu klasör, her bir Git branch'i için bir alt klasör içerir. Her alt klasörde, o varyantın ne denediğini, hangi yaklaşımları kullandığını ve önemli bulguları özetleyen kısa bir `README.md` bulunur. Bu, tüm denemelere dair yüksek seviyeli bir bakış açısı sunar.
    - `reports/`: Süre sonunda, tüm varyantların karşılaştırmalı analizini içeren `evaluation_report.md` gibi raporlar bu klasörde saklanır.

Bu yapı, Git'in güçlü kod yönetimi yetenekleri ile basit klasör yapısının keşfedilebilirlik avantajını birleştirir.

## 4. Çıktılar

Süre dolduğunda, Jules aşağıdaki çıktıları sağlayacaktır:
1.  **Tavsiye Edilen Çözüm:** Belirtilen optimizasyon hedefine en uygun olan kod varyantı.
2.  **Karşılaştırma Raporu:** Tüm varyantların objektif metriklerle (performans, kod kalitesi vb.) karşılaştırıldığı bir rapor.
3.  **Varyant Özetleri:** Her bir denemenin ne olduğunu açıklayan özet dosyaları.
4.  **Git Branch'leri:** Tüm kod varyantlarını içeren, incelenebilir ve birleştirilebilir yerel Git branch'leri.

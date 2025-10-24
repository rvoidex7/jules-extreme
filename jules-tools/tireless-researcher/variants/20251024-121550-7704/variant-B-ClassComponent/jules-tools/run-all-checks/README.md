# Jules Tool: Run All Checks

## 1. Amaç

Bu araç, projenin kod kalitesini, doğruluğunu ve tutarlılığını sağlamak için tanımlanmış tüm kontrol adımlarını (formatlama, linting, testler, vb.) tek bir komutla çalıştırır.

Bu, Jules'un `commit` öncesi doğrulama adımlarını otomatize eder ve tüm değişikliklerin projenin kalite standartlarına uygun olduğundan emin olmasını sağlar.

## 2. Kullanım

Bu araç, `run.sh` betiği aracılığıyla kullanılır ve genellikle herhangi bir argüman almaz.

```bash
./run.sh
```

## 3. Tipik Görevleri

Bu betik, bir projenin `package.json` dosyasında veya diğer yapılandırma dosyalarında tanımlanmış olan kontrol betiklerini sırayla ve güvenli bir şekilde çalıştırır.

- **Kod Formatlama:** Projenin kod stili kurallarına uymayan dosyaları düzeltir (`prettier --write .`).
- **Linting:** Potansiyel hataları ve "code smell"leri tespit eder (`eslint .`).
- **Birim Testleri:** Kodun bireysel birimlerinin doğru çalıştığını doğrular (`npm test` veya `jest`).
- **Entegrasyon Testleri:** Farklı modüllerin birlikte uyum içinde çalıştığını kontrol eder.
- **Tip Kontrolü:** (TypeScript gibi diller için) Tip hatalarını kontrol eder (`tsc --noEmit`).

Betiğin en önemli özelliklerinden biri, adımlardan herhangi biri başarısız olduğunda (örneğin, bir test patladığında) `-e` seçeneği sayesinde çalışmayı hemen durdurmasıdır. Bu, hatalı kodun `commit` edilmesini engeller.

## 4. Çıktılar

Tüm kontroller başarıyla tamamlandığında, betik terminalde "✅ Tüm kontroller başarıyla tamamlandı. Kod, commit için hazır." gibi bir onay mesajı gösterir. Herhangi bir adım başarısız olursa, o adımdan gelen hata mesajını gösterir ve sıfır olmayan bir çıkış koduyla sonlanır.

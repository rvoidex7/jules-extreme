# Jules Tool: Generate Lo-Fi Wireframe

## 1. Amaç

Bu araç, bir kullanıcı arayüzü (UI) görevi için hızla düşük kaliteli (lo-fi) bir kroki (wireframe) oluşturur. Bu aracın amacı estetik değildir; tam tersine, renk, gölge, yazı tipi gibi stilistik unsurları kasıtlı olarak yok sayarak, sadece **yapı, yerleşim ve fonksiyonel bileşen seçimi** üzerine odaklanmayı sağlar.

Bu, geliştirme sürecinin en başında, Jules'un UI yaklaşımının kullanıcı tarafından hızla doğrulanmasını veya reddedilmesini sağlayarak, yanlış bir tasarım yolunda harcanacak zamanı önler.

## 2. Kullanım

Bu araç, `run.sh` betiği aracılığıyla kullanılır. Genellikle Jules tarafından oluşturulan geçici bir HTML dosyasını ve çıktı alınacak resmin adını parametre olarak alır.

```bash
./run.sh --html-file /tmp/temp_ui.html --output wireframe_A.png
```

- `--html-file`: (Zorunlu) Jules'un oluşturduğu, stile sahip olmayan veya temel HTML yapısı.
- `--output`: (Zorunlu) Oluşturulacak wireframe resminin dosya adı.

## 3. Çalışma Mekanizması

`run.sh` betiği, verilen HTML dosyasını alır ve bu klasörde bulunan `wireframe.css` stil dosyasını ona zorla uygular. Bu özel CSS dosyası, aşağıdaki gibi "anti-tasarım" kuralları içerir:
- Tüm renkleri kaldırır (siyah, beyaz, gri tonları).
- Kenar yuvarlaklıklarını (`border-radius`) sıfırlar.
- Gölgeleri (`box-shadow`) kaldırır.
- Tüm metinler için standart, tek aralıklı bir yazı tipi (`monospace`) kullanır.
- Tüm bileşenlerin sınırlarını belirgin hale getirmek için net kenarlıklar (`border`) ekler.

Sonrasında, bu stile sahip HTML'i bir headless browser (Playwright) aracılığıyla açar ve ekran görüntüsünü alır.

## 4. Çıktılar

Çıktı, sanki bir teknik çizim gibi görünen, fonksiyonelliği ve yapıyı ön plana çıkaran, estetikten tamamen arındırılmış bir `.png` dosyasıdır.

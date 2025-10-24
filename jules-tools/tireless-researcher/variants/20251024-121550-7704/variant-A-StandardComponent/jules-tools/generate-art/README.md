# Jules Tool: Generate Art (Jules's Generative Canvas)

## 1. Amaç

Bu araç, metin tabanlı yaratıcı prompt'ları, programatik olarak **Scalable Vector Graphics (SVG)** formatında sanatsal görsellere dönüştürür.

Bu araç, popüler difüzyon modelleri gibi piksel tahmini yapmak yerine, Jules'un temel yeteneklerini (mantıksal çıkarım, kodlama, internet erişimi) kullanarak bir görüntüyü temel geometrik şekiller, yollar, desenler ve filtrelerle **"inşa eder"**. Bu, onu bir "ressam" yerine bir **"teknik sanatçı"** veya **"üretken zanaatkar"** yapar.

## 2. Vizyon ve Çalışma Mekanizması

Bu araç, **hibrit bir üretim modeli** kullanır:

1.  **Programatik Çizim (Çekirdek):** `run.py` betiği, "mavi gözlü, mor saçlı karakter" gibi bir prompt'u, `{type: 'eye', color: 'blue'}` gibi yapısal bileşenlere ayırır. Ardından, `svgwrite` gibi bir kütüphane kullanarak bu bileşenleri SVG olarak kodlar.

2.  **Harici Kaynak Entegrasyonu (API Destekli):** Araç, daha zengin ve estetik sonuçlar elde etmek için çeşitli harici API'lerden "kuvvet alır":
    - **Renk Paletleri:** `colormind.io` gibi servislerden uyumlu renk şemaları çeker.
    - **Dokular ve Desenler:** `Unsplash`, `Pexels` gibi sitelerden doku resimleri indirip SVG desenleri olarak kullanır.
    - **İkonlar ve Şekiller:** `Noun Project` gibi kaynaklardan temel vektörel şekiller alabilir.

Bu yaklaşım, sonuçların tamamen düzenlenebilir, ölçeklenebilir ve programatik olarak kontrol edilebilir olmasını sağlar.

## 3. Kullanım

Aracın temel kullanımı, ana Python betiğini bir prompt ile çalıştırmak olacaktır. Bir `run.sh` sarmalayıcı betiği, SVG'yi PNG'ye dönüştürme gibi ek adımları otomatize edecektir.

```bash
# Örnek kullanım (gelecekteki hedef)
./run.sh --prompt "Mor saçlı, mavi gözlü, gülümseyen bir anime karakteri" --output my-character
```

- `--prompt`: (Zorunlu) Oluşturulacak görselin metin tabanlı açıklaması.
- `--output`: (Zorunlu, uzantısız) Çıktı dosyalarının adı. `my-character.svg` ve `my-character.png` olarak iki dosya üretecektir.

## 4. Çıktılar

- **Bir `.svg` dosyası:** Ham, düzenlenebilir, vektörel sanat eseri.
- **Bir `.png` dosyası:** SVG'nin kolayca görüntülenebilen rasterleştirilmiş versiyonu.

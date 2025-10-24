# Jules Tool: Apply Design System to Mockup

## 1. Amaç

Bu araç, yapısal olarak onaylanmış bir HTML'e (genellikle bir `wireframe` sürecinden sonra) projenin mevcut **tasarım sistemini (design system)** veya ana stil dosyasını uygulayarak yüksek kaliteli (hi-fi) bir görsel taslak (mockup) oluşturur.

Bu aracın amacı, Jules tarafından oluşturulan yeni arayüzlerin, projenin geri kalanıyla görsel olarak tutarlı olmasını sağlamaktır. Renkler, yazı tipleri, gölgeler ve bileşen stilleri gibi estetik unsurları projenin merkezi stil rehberinden alır.

## 2. Kullanım

Bu araç, `run.sh` betiği aracılığıyla kullanılır. Stil uygulanacak HTML dosyasını, projenin ana CSS dosyasını ve çıktı alınacak resmin adını parametre olarak alır.

```bash
./run.sh --html-file /tmp/approved_ui.html --css-file src/styles/main.css --output mockup.png
```

- `--html-file`: (Zorunlu) Jules'un oluşturduğu ve yapısal olarak onaylanmış HTML dosyası.
- `--css-file`: (Zorunlu) Projenin genel stilini ve tasarım sistemini içeren ana CSS dosyası.
- `--output`: (Zorunlu) Oluşturulacak yüksek kaliteli mockup resminin dosya adı.

## 3. Çalışma Mekanizması

`run.sh` betiği, `--html-file` ile belirtilen HTML dosyasını alır ve `<head>` bölümüne `--css-file` ile belirtilen stil dosyasını bir `<link>` etiketi olarak ekler.

Eğer proje TailwindCSS gibi bir yapı kullanıyorsa, bu betik HTML'deki class'ların işe yaraması için önce projenin build adımını tetikleyebilir.

Sonrasında, bu stile sahip HTML'i bir headless browser (Playwright) aracılığıyla açar ve nihai, stile sahip arayüzün ekran görüntüsünü alır.

## 4. Çıktılar

Çıktı, projenin mevcut tasarım diliyle tamamen tutarlı, renkli, stilli ve sanki uygulamanın bir parçasıymış gibi görünen, piksel-mükemmel bir `.png` dosyasıdır. Bu, kodlamaya başlamadan önce nihai görsel onayı almak için kullanılır.

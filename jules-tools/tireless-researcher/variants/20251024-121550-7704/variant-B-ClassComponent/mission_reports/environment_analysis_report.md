# Detaylı Ortam Analizi Raporu

## 1. Giriş

Bu rapor, "Jules'un Büyük Testi" görevi sırasında karşılaşılan ve geliştirme sürecini temelden etkileyen teknik kısıtlamaları ve anomalileri belgelemektedir. Bu bulgular, gelecekte bu veya benzeri bir ortamda çalışacak herhangi bir geliştirici veya yapay zeka asistanı için kritik öneme sahiptir.

## 2. Kök Neden Analizi: Karşılaşılan Sorunlar

İki ana kategori altında üç temel sorun tespit edilmiştir:

### Kategori A: Git İşlevsellik Anormallisi

**1. Belirti: `git commit` Komutunun Etkisizliği**
- **Açıklama:** Çalışma dizininde dosyalar oluşturulmasına veya değiştirilmesine rağmen, `git add` komutundan sonra çalıştırılan `git status` komutu "nothing to commit, working tree clean" (işlenecek bir değişiklik yok, çalışma ağacı temiz) mesajını döndürmekteydi. Sonuç olarak, `git commit` komutu hiçbir değişikliği kaydetmedi.
- **Etkileri:**
    - Geliştirme geçmişi oluşturulamadı.
    - Branch'ler arasında geçiş yapıldığında, kaydedilmemiş tüm değişiklikler kayboldu. Bu durum, "Savaş Sistemi" ve "Diyalog Sistemi" prototiplerinin aynı anda var olmasını engelledi.
    - `submit` aracı, değişiklikleri kalıcı hale getirmenin tek yolu haline geldi, ancak bu da kendi risklerini (bkz: `jules-tools` silinmesi) beraberinde getirdi.
- **Olası Neden:** Bu durum, standart bir Git davranışı değildir. Ortamın sanallaştırma katmanında veya dosya sistemi izleme mekanizmasında, Git'in dosya değişikliklerini doğru bir şekilde algılamasını engelleyen bir anomali veya kasıtlı bir kısıtlama olabilir.

### Kategori B: Dosya Sistemi ve Bağımlılık Yönetimi Kısıtlamaları

**2. Belirti: Tek İşlemde Maksimum Dosya Sayısı Limiti**
- **Açıklama:** `npm install` gibi, tek seferde çok sayıda dosya (örn: `node_modules`) oluşturan veya `git add --force .` gibi çok sayıda dosyayı etkileyen komutlar, "The command affected too many files in the repo" hatasıyla başarısız oldu.
- **Etkileri:**
    - `npm`, `yarn` gibi standart paket yöneticilerinin kullanımı imkansız hale geldi.
    - Vite, React gibi modern JavaScript araç zincirleri kurulamadı.
    - `jules-tools` içindeki `playwright` gibi `npm` bağımlılığı olan araçlar çalışmadı.
- **Olası Neden:** Bu, ortamın kötüye kullanımı (örneğin, sonsuz döngüde dosya oluşturma) önlemek veya kaynakları sınırlamak için konulmuş kasıtlı bir güvenlik önlemidir.

**3. Belirti: Dosya Sistemi Tutarsızlığı (`ls` vs. `mv`/`cp`/`rm`)**
- **Açıklama:** `ls` komutu bir dosyanın varlığını listelerken, `mv`, `cp` ve hatta `rm` komutları aynı dosya için "No such file or directory" (böyle bir dosya veya dizin yok) hatası verdi.
- **Etkileri:** Dosyaları güvenilir bir şekilde taşımayı veya silmeyi engelledi.
- **Olası Neden:** Bu, genellikle bir tür önbellekleme sorunu veya dosya sistemi durumunun farklı araçlara tutarsız bir şekilde yansıtıldığına işaret eder. Bu, ortamın en kararsız ve endişe verici anomalisidir.

## 3. Geliştirilen Çözümler ve Gelecek İçin Öneriler

Bu sorunlara karşı aşağıdaki pragmatik çözümler geliştirilmiş ve gelecekteki çalışmalar için standart hale getirilmesi önerilmektedir:

**1. Kural: "Sıfır Yerel Bağımlılık" Politikası**
- **Açıklama:** `npm` ve `node_modules` tamamen terk edilmelidir. Tüm harici kütüphaneler (Three.js, TWEEN.js vb.) güvenilir CDN'ler (örn: Skack, jsDelivr) üzerinden, doğrudan HTML içinde `<script type="module">` etiketleriyle içe aktarılmalıdır.
- **Gerekçe:** Bu, "Maksimum Dosya Sayısı" limitini aşmanın tek yoludur.

**2. Kural: "Python ile Basit Sunucu"**
- **Açıklama:** Geliştirme sunucusu ihtiyacı için, harici bağımlılık gerektirmeyen `python3 -m http.server` komutu kullanılmalıdır.
- **Gerekçe:** `npm` tabanlı sunucular (Vite, live-server) kurulamadığı için en güvenilir alternatiftir.

**3. Kural: "Commit Yerine Submit" İş Akışı**
- **Açıklama:** Bu ortamda `git commit` güvenilir değildir. Geliştirme, tek bir görev odağında tamamlanmalı ve tüm değişiklikler tek seferde `submit` aracıyla gönderilmelidir.
- **DİKKAT:** `submit` komutu çalıştırılmadan önce, çalışma dizininin projenin **tam ve eksiksiz** halini içerdiğinden emin olunmalıdır. Aksi takdirde, eksik dosyalar (`jules-tools` örneğinde olduğu gibi) hedef depoda silinmeye neden olabilir.

**4. Kural: "Taşıma Değil, Yeniden Oluştur"**
- **Açıklama:** Dosya sistemi tutarsızlığı nedeniyle, dosyaları taşımak (`mv`) veya kopyalamak (`cp`) yerine, hedef konumda yeniden oluşturmak (`overwrite_file_with_block`) ve ardından (başarısız olsa bile) eski konumu silmeyi denemek (`rm -rf`) daha güvenilirdir.

## 4. Sonuç

Bu ortam, standart geliştirme pratiklerinin birçoğunu engelleyen ciddi kısıtlamalara sahiptir. Ancak, bu kısıtlamalar anlaşıldığında ve yukarıdaki kurallara uyulduğunda, geliştirme yapmak mümkündür. Bu rapor, gelecekteki görevlerin bu engellere takılmadan daha verimli bir şekilde yürütülmesi için bir yol haritası sunmaktadır.

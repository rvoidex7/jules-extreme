# Jules Tool: Setup Environment

## 1. Amaç

Bu araç, projenin geliştirme ortamını tek bir komutla, sıfırdan çalışmaya hazır hale getirir. Jules'un bir göreve başlamadan önce projeyi manuel olarak analiz etme ve kurma ihtiyacını ortadan kaldırarak zamandan tasarruf sağlar ve tutarlılığı garanti eder.

## 2. Kullanım

Bu araç, `run.sh` betiği aracılığıyla kullanılır. Genellikle herhangi bir argüman almaz.

```bash
./run.sh
```

## 3. Tipik Görevleri

Bu betik, bir projenin ihtiyaçlarına göre aşağıdaki gibi görevleri yerine getirecek şekilde özelleştirilmelidir:

- **Bağımlılıkların Kurulumu:**
  - `npm install`, `pip install -r requirements.txt`, `bundle install` gibi komutları çalıştırır.
- **Veritabanı Kurulumu:**
  - Gerekirse bir Docker konteyneri başlatır (`docker-compose up -d`).
  - Veritabanı şemasını oluşturur (migration'ları çalıştırır).
  - Veritabanını test verileriyle doldurur (seeding).
- **Yapılandırma Dosyalarının Oluşturulması:**
  - `.env.example` dosyasından `.env` dosyası oluşturur.
- **Geliştirme Sunucusunun Başlatılması:**
  - Projeyi arka planda çalıştırarak Jules'un hemen çalışmaya başlamasını sağlar.

## 4. Çıktılar

Bu betik başarıyla tamamlandığında, terminalde "✅ Geliştirme ortamı başarıyla kuruldu ve hazır." gibi bir onay mesajı göstermelidir.

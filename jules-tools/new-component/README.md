# Jules Tool: New Component Scaffolder

## 1. Amaç

Bu araç, bir projeye yeni bir bileşen, modül, sayfa veya başka bir standart kod birimi ekleme sürecini otomatize eder. Projenin kodlama standartlarına ve dosya yapısı kurallarına uygun olarak gerekli tüm dosyaları (örneğin, `.jsx`, `.css`, `.test.js`) ve temel şablon (boilerplate) içeriğini tek bir komutla oluşturur.

Bu, tutarlılığı sağlar ve Jules'un yeni birimler oluştururken harcadığı zamanı önemli ölçüde azaltır.

## 2. Kullanım

Bu araç, `run.sh` betiği aracılığıyla kullanılır ve genellikle oluşturulacak birimin adını ve tipini parametre olarak alır.

```bash
# Örnek: Bir React bileşeni oluşturma
./run.sh --type react-component --name Button
```

- `--type`: (Zorunlu) Oluşturulacak kod biriminin tipi. Örneğin: `react-component`, `vue-page`, `express-route`.
- `--name`: (Zorunlu) Oluşturulacak birimin adı (PascalCase veya kebab-case formatında).

## 3. Şablon Yönetimi

Bu aracın gücü, içindeki şablonlardan gelir. `templates/` adında bir alt klasör, farklı `type`'lar için şablonlar içerir.

Örneğin yapı şöyle olabilir:
```
new-component/
├── templates/
│   ├── react-component/
│   │   ├── {{ComponentName}}.jsx.template
│   │   ├── {{ComponentName}}.module.css.template
│   │   └── {{ComponentName}}.test.js.template
│   └── vue-page/
│       ├── {{PageName}}.vue.template
│       └── index.js.template
├── run.sh
└── README.md
```

`run.sh` betiği, belirtilen `type`'a göre ilgili şablon klasörünü bulur, `--name` argümanını kullanarak dosya ve içeriklerdeki `{{ComponentName}}` gibi yer tutucuları değiştirir ve dosyaları projenin doğru dizinine (örneğin, `src/components/`) kopyalar.

## 4. Çıktılar

Betiğin başarılı bir şekilde çalışması sonucunda, projenin ilgili dizinine yeni birimin dosyaları eklenir ve terminalde "✅ 'Button' bileşeni src/components/Button altına başarıyla oluşturuldu." gibi bir onay mesajı gösterilir.

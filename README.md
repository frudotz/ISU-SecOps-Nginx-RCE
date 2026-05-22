# ⚡ ISU-SecOps — CVE-2026-0211

## Eğitim Amaçlı Saldırı Laboratuvarı

> **Pre-Auth RCE via Nginx QUIC `dcid_len` Heap Buffer Overflow**
> CVSS 9.8 — Critical

```text
┌─────────────────────────────────────────────────────────────────┐
│  Crafted UDP Packet → Nginx QUIC Parser → dcid_len Manipulation│
│  → Misaligned Address Dereference / Heap Buffer Overflow       │
│  → FULL SERVER COMPROMISE / DENIAL OF SERVICE                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## ⚠️ YASAL UYARI / DISCLAIMER

> **🔴 Bu proje yalnızca EĞİTİM ve ARAŞTIRMA amaçlıdır.**
>
> - Buradaki araçlar **yalnızca kendi kontrol ettiğiniz sistemlerde** kullanılmalıdır
> - Yetkisiz sistemlere saldırı **Türk Ceza Kanunu madde 243-245** kapsamında suçtur
> - Proje sahipleri araçların kötüye kullanımından **sorumluluk kabul etmez**
> - Tüm testler izole docker (bridge network) ortamında yapılmalıdır

---

## 📋 CVE Bilgileri

| Alan | Detay |
|------|-------|
| **CVE** | CVE-2026-0211 (Hipotetik) |
| **CVSS** | 9.8 / Critical |
| **Tür** | Heap Buffer Overflow / Out-of-bounds Write |
| **Kimlik Doğrulama** | Gerekmez (Pre-Auth) |
| **Etkilenen** | Nginx 1.25.3 (HTTP/3 QUIC modülü aktifken) |
| **Yamalı** | Özel C-Patch (`CVE-2026-0211-defense.patch`) |
| **Hedef Platform** | Linux / Docker |

---

## 📁 Proje Yapısı

```text
ISU-SecOps/
│
├── 📄 README.md               # Bu dosya
├── 📄 docker-compose.yml      # Laboratuvar ağ topolojisi
│
├── 📂 hedef/                  # 🎯 Savunmasız Hedef Sistem
│   ├── nginx/
│   │   ├── Dockerfile         # Nginx derleme ve yama adımları
│   │   └── nginx.conf         # QUIC & HTTP/3 yapılandırması
│   └── website/               # Mock "ISU SecOps" Kurumsal Web Sitesi
│       ├── index.html
│       └── style.css
│
├── 📂 saldiri/                # 🗡️ Saldırı Araçları (Python)
│   ├── 01_recon.py            # Keşif ve HTTP/3 tespit scripti
│   ├── 03_dos.py              # Denial of Service (DoS) scripti
│   └── payloads/              # RCE ve DoS için JSON şablonları
│       ├── flight_dos.json
│       └── flight_rce.json
│
├── 📂 savunma/                # 🛡️ Savunma & Yama
│   ├── CVE-2026-0211-defense.patch # Orijinal Nginx C-Yaması
│   └── patch_guide.md         # Yamanın analizi
│
├── 📂 dokumantasyon/          # 📚 Akademik Raporlar
│   ├── 01_tehdit_analizi.md
│   ├── 02_fuzzing_metodolojisi.md
│   ├── 03_crash_triage.md
│   ├── 04_mitigation_stratejileri.md
│   └── 05_performans_analizi.md
│
└── 📂 .github/                # 🤖 CI/CD DevOps
    └── workflows/
        └── security_test.yml  # Otomatik ASAN/UBSAN güvenlik testi
```

---

## 🚀 Hızlı Başlangıç

### Gereksinimler

| Araç | Amaç |
|------|------|
| Docker & Docker Compose | Hedef ve Fuzzer ağını kurmak |
| Python 3.x | Saldırı araçlarını çalıştırmak |
| Git | Repoyu klonlamak |

### 1. Laboratuvarı Kur ve Çalıştır

```bash
# Projeyi klonla
git clone https://github.com/frudotz/ISU-SecOps-Nginx-RCE.git
cd ISU-SecOps-Nginx-RCE

# İzole ağı (10.13.37.0/24) ve sistemleri ayağa kaldır
docker compose up -d --build
```

### 2. Saldırı Aracını Çalıştır (DoS)

```bash
# Recon aracı ile HTTP/3 kontrolü yap
python3 saldiri/01_recon.py 10.13.37.10 443

# DoS saldırısını başlat
python3 saldiri/03_dos.py 10.13.37.10 443 10
```

### 3. Logları ve Crash'i İncele

```bash
# Nginx ASAN loglarına bak
docker exec target_nginx cat /var/log/nginx/asan.7
```

---

## 🗡️ Saldırı Zinciri

### Aşama 1: Keşif (Reconnaissance)
- Hedef Nginx'in UDP 443 portunda HTTP/3 (QUIC) dinleyip dinlemediği kontrol edilir.
- Fuzzer tabanlı ağ testleri ile açık port onaylanır (`01_recon.py`).

### Aşama 2: Zafiyet Tetikleme & Crash Triage
- Nginx `ngx_event_quic_transport.c` dosyasındaki eksik kontrol sebebiyle malformed `dcid_len=255` UDP paketi gönderilir (`03_dos.py`).
- C dilindeki `uint32_t` tip dönüşümünden kaynaklanan "Misaligned Address Dereference" veya Memory Corruption tetiklenir.

---

## 🛡️ Savunma Rehberi

### Acil Eylemler
Zafiyetli `ngx_quic_parse_packet` fonksiyonuna katı `Bounds Checking` (sınır kontrolü) eklenmelidir. Bu işlem `savunma/CVE-2026-0211-defense.patch` ile derleme sırasında uygulanmıştır.

### Gelişmiş Sertleştirme (Defense in Depth)
- ✅ eBPF (XDP) ile Kernel seviyesinde malformed paket düşürme (Dokümanlara bakınız).
- ✅ QUIC paket başlıklarını analiz eden WAF (ModSecurity) entegrasyonu.
- ✅ ASAN/UBSAN derlemeleriyle CI/CD otomasyonu üzerinden sürekli güvenlik testi (Bkz: `security_test.yml`).

---

## 🗺️ Akademik Raporlar

Detaylı teknik analiz ve performans sonuçları için `dokumantasyon/` klasöründeki dosyaları inceleyebilirsiniz:
1. Tehdit Analizi
2. Fuzzing Metodolojisi
3. Crash Triage & Kök Neden (Root Cause)
4. Mitigasyon Stratejileri
5. Performans ve Benchmarking Analizi (O(1) Overhead)

---

## 📄 Lisans

Bu proje akademik ve eğitim amaçlıdır.

---
*ISU SecOps Lab — Nginx QUIC RCE Eğitim Ortamı — 2026*
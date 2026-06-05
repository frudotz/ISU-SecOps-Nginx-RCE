# Savunma ve Yama (Defense) Modülü

## Amaç

Nginx C kaynak kodundaki QUIC protokol ayrıştırıcısına (parser) sınır kontrolleri (bounds checking) ekleyerek Heap Buffer Overflow (CVE-2026-0211) zafiyetini engellemek.

## Nasıl Çalışır

Adım adım çalışma prensibi:
1. Nginx `src/event/quic/ngx_event_quic_transport.c` dosyasındaki paket okuma fonksiyonu incelenir.
2. C koduna `idlen > NGX_QUIC_CID_LEN_MAX` veya `idlen == 0xFF` kontrolü eklenir.
3. Ek olarak `(size_t)(end - p) < idlen` denetimiyle okunan uzunluğun, ayrılan belleği taşıp taşmadığı kontrol edilir (Memory Alignment Verification).
4. Eğer kural dışı bir uzunluk tespit edilirse `ngx_log_error` ile log düşülür ve `NGX_ERROR` döndürülerek bağlantı sonlandırılır, parser taşmadan engellenmiş olur.

## Kullanım

```bash
# Yamayı Nginx kaynak koduna uygulamak için:
cd nginx-1.25.3/
patch -p0 < ../src/savunma/CVE-2026-0211-defense.patch
make && make install
```

## Çıktı

Yama başarıyla derlendikten sonra, saldırgan malformed payload yollasa bile Nginx error log'larına `quic: invalid dcid length detected (possible CVE-2026-0211 exploit attempt)` şeklinde bir hata düşecek ancak sunucu çökmeyecektir.

## Bilinen Kısıtlamalar

- Yamanın sadece spesifik `dcid_len` zafiyetini giderdiği ve QUIC standardındaki diğer olası state machine açıklarına karşı tam bir garanti sağlamadığı unutulmamalıdır.

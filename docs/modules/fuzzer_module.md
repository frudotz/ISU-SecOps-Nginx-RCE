# QUIC Fuzzer Modülü

## Amaç

CVE-2026-0211 simülasyonu kapsamında, Nginx HTTP/3 QUIC implementasyonunda Heap Buffer Overflow zafiyetini (DCID Length parsing) tetiklemek.

## Nasıl Çalışır

Adım adım çalışma prensibi:
1. Python ve Scapy kütüphanesi kullanılarak bir QUIC Initial pakedi manuel olarak (struct) inşa edilir.
2. Zafiyetin temeli olan `dcid_len` değeri, normal sınırların (örn: 20 byte) çok ötesine, kasıtlı olarak `0xFF` (255) olarak ayarlanır.
3. 255 byte uzunluğunda 'A' karakterinden oluşan çöp (junk) data payload içine yerleştirilir.
4. Paket, hedef Nginx sunucusuna fırlatılır. Nginx bu veriyi parse ederken `dcid_len` kontrolü yapmadığı için buffer dışına taşarak Heap corruption oluşturur.

## Kullanım

```bash
python3 src/saldiri/fuzzer.py
```

## Çıktı

Konsol üzerinde gönderilen paketin yapısı ve büyüklüğü özetlenir. Başarılı olması durumunda hedef sistemdeki Nginx sunucusu ASAN (AddressSanitizer) crash logları (`asan.7` vb.) üretir.

## Bilinen Kısıtlamalar

- Hardcoded hedef IP adresi (`10.13.37.10`) ve port (`443`) kullanır.
- Gerçek bir fuzzer döngüsü (farklı byte mutasyonları) barındırmaz, doğrudan tespit edilen RCE/Crash zafiyetine yönelik bir reproducer betiği (exploit proof of concept) gibi çalışır.

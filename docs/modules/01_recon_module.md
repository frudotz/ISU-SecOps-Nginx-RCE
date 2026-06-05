# Keşif (Recon) Modülü

## Amaç

Hedef sunucunun HTTP/3 ve QUIC protokolünü destekleyip desteklemediğini tespit etmek.

## Nasıl Çalışır

Adım adım çalışma prensibi:
1. Temel bir QUIC Initial pakedi (dummy) oluşturulur (`c30000000108000000000000000000000000`).
2. Hazırlanan payload, hedefin belirtilen UDP portuna (genelde 443) gönderilir.
3. Soket üzerinden 2 saniyelik bir zaman aşımı (timeout) ile cevap dinlenir.
4. Hedef sunucudan veri dönerse QUIC protokolünün aktif olduğu raporlanır.

## Kullanım

```bash
python3 src/saldiri/01_recon.py <target_ip> <target_port>

# Örnek:
python3 src/saldiri/01_recon.py 10.13.37.10 443
```

## Çıktı

İşlem sonucunda konsolda şu tarz bir çıktı elde edilir:
`[+] Target responded! QUIC protocol is likely supported.`
`[>] Received 1250 bytes from target.`

## Bilinen Kısıtlamalar

- Yalnızca UDP bağlantı noktasına gönderilen pakete verilen basit yanıtı analiz eder, karmaşık QUIC el sıkışma aşamasını (handshake) gerçekleştirmez.

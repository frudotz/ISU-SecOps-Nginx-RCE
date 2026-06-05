# DoS (Hizmet Reddi) Modülü

## Amaç

Nginx sunucusunun QUIC parser modülündeki zafiyeti kullanarak hedef sistemi çok sayıda hatalı paketle meşgul etmek ve hizmet dışı bırakmak (DoS).

## Nasıl Çalışır

Adım adım çalışma prensibi:
1. `\xff` (255) değerinde malformed bir `dcid_len` (Destination Connection ID length) barındıran sabit bir QUIC payload'u tanımlanır.
2. Belirtilen sayıda iş parçacığı (thread) ayağa kaldırılır.
3. Her bir thread, `while True` döngüsü içinde hedef UDP portuna sürekli olarak bu zafiyetli paketi gönderir.
4. Hedef sistemin memory veya CPU limitleri tükenene kadar asimetrik asenkron istekler devam eder.

## Kullanım

```bash
python3 src/saldiri/03_dos.py <target_ip> <target_port> <threads>

# Örnek:
python3 src/saldiri/03_dos.py 10.13.37.10 443 10
```

## Çıktı

Script çalıştırıldığında thread sayısına göre eşzamanlı bir paket seli başlatılır. Betik tarafında ek bir paket çıktı onayı bulunmaz; başarı durumu hedef sunucunun çökmesiyle doğrulanır.

## Bilinen Kısıtlamalar

- UDP spoofing (kaynak IP sahtekarlığı) barındırmadığından, firewall tarafında hızlıca banlanabilir. Sadece yerel laboratuvar ağında (10.13.37.0/24) test edilmesi önerilir.

# Araştırma ve Geliştirme Yol Haritası (ROADMAP)

> [!NOTE]
> "Önce anla, sonra kodla." Her problemi küçük, sıralı parçalara böl. Bir dedektif gibi düşün: gözlemle, ham veriyi çevir, desenleri tespit et, raporla.

## Faz 0: Yazmadan Önce Anla
- [ ] Tehdit analizi ve zafiyet teorisinin kavranması (Nginx QUIC dcid_len parsing)
- [ ] Heap-buffer-overflow ve memory corruption temellerinin incelenmesi
- [ ] Savunma (mitigation) ve patch geliştirme konseptlerinin araştırılması

## Faz 1: Araştırma ve Keşif
*Not: Tüm araştırma notları ve çıktılar `docs/research/` dizininde toplanmıştır.*
- [ ] Wireshark veya mevcut araçlarla geçerli QUIC Initial, Handshake paketlerinin incelenmesi
- [ ] Fuzzing metodolojisi ve LibFuzzer/AFL++ kavramlarının araştırılması
- [ ] Crash triage adımlarının detaylandırılması

## Faz 2: Ortam Kurulumu
- [ ] Docker topolojisinin inşası: Victim (Nginx), Attacker (Fuzzer) ve Monitor node'ları
- [ ] Dışa kapalı (air-gapped) bridge ağ kurulumu (10.13.37.0/24)
- [ ] Nginx kaynak kodunun indirilmesi ve ASAN/UBSAN ile derlenmesi
- [ ] tcpdump ve Valgrind gibi gözlem araçlarının hazırlanması

## Faz 3: Uygulama
- [ ] Modül 1: Fuzzer/Harness geliştirme ve Nginx ağ beslemesinin entegrasyonu
- [ ] Modül 2: Fuzzing kampanyası başlatılarak hatalı (malformed) paketlerin hedefe gönderilmesi
- [ ] Modül 3: Python ve Scapy kullanılarak zafiyeti tetikleyen crash reproducer betiğinin yazılması
- [ ] Modül 4: Nginx `ngx_event_quic.c` dosyasına `dcid_len` için katı bounds checking yamasının uygulanması

## Faz 4: Test ve Raporlama
- [ ] GDB ve ASAN çıktıları ile hafıza analizinin gerçekleştirilmesi
- [ ] Fuzzer'ın bulduğu tüm crash payload'larının yamalı sisteme gönderilmesi (Regression Testing)
- [ ] Eklenen bounds-check kontrollerinin Nginx performansına etkisinin ölçülmesi (Benchmarking)
- [ ] Metriklerin toplanıp bulguların analiz edilerek raporlanması

## Faz 5: Teslim Kontrol Listesi
- [ ] README.md ve belgeleme standartlarının doğrulanması
- [ ] Dockerfile, docker-compose.yml ve .env.example dosyalarının kontrolü
- [ ] Kod geçmişinin, commit'lerin ve PR (Pull Request) kalitesinin incelenmesi
- [ ] Danışman hocanın (keyvanarasteh) Github reposuna Read erişimiyle Collaborator olarak eklenmesi
- [ ] Gereksiz veya büyük binary dosyalarının repo dışında tutulması (.gitignore kontrolü)

# Kaynaklar ve Referanslar

Bu proje kapsamında araştırma, geliştirme ve yamalama süreçlerinde faydalanılan araçlar, makaleler ve resmi dökümanlar aşağıda listelenmiştir.

## Resmi Dokümantasyon ve Araçlar

- [Nginx Official Documentation](https://nginx.org/en/docs/) - Web sunucusunun temel çalışma mantığı ve konfigürasyon seçenekleri.
- [RFC 9000: QUIC](https://datatracker.ietf.org/doc/html/rfc9000) - QUIC, A UDP-Based Multiplexed and Secure Transport (Protokolün resmi standardı).
- [AddressSanitizer (ASAN)](https://github.com/google/sanitizers/wiki/AddressSanitizer) - Hafıza sızıntısı (memory corruption) ve buffer overflow hatalarını yakalamak için derleyici aracı.
- [Scapy (Python)](https://scapy.net/) - QUIC fuzzer geliştirilirken manuel paket oluşturma (packet crafting) aracı.

## Makaleler ve Eğitim Materyalleri

- [Fuzzing Nginx QUIC Modules](https://blog.cloudflare.com/fuzzing-quic-implementations/) - QUIC protokolü üzerinde fuzzing gerçekleştirme metodolojileri (örnek kaynak).
- [Understanding Heap Buffer Overflows](https://cwe.mitre.org/data/definitions/122.html) - CWE-122: Heap-based Buffer Overflow teknik analizi.
- [eBPF ve XDP ile Paket Düşürme](https://ebpf.io/what-is-ebpf/) - Gelişmiş mitigasyon stratejileri çerçevesinde Linux Kernel seviyesinde paket analizi araştırmaları.

*Not: Bu proje eğitim amaçlı olduğundan bazı CVE ve zafiyet senaryoları simülatiftir.*

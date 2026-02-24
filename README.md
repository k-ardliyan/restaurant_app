# 🍽️ Restaurant App

Aplikasi berbasis Flutter yang dibangun sebagai **studi kasus** (_learning case_) untuk mengimplementasikan fundamental pengembangan UI/UX secara _native_.

---

## ✨ Fitur Utama (Features)

- **Pencarian & Katalog**: Menampilkan daftar puluhan restoran dari API dan fitur pencarian (_live search_ dengan _debounce_ 500ms).
- **Tema Modern**: Mendukung _Dark Mode_ dan _Light Mode_ sesuai _state_ aplikasi.
- **Detail Restoran**: Menampilkan info lengkap, _rating_, _header_ gambar yang bisa di-zoom (_fullscreen_), dan grid menu makanan & minuman.
- **Sistem Ulasan (_Review_)**: Pengguna dapat menambahkan ulasan lewat _Bottom Sheet_ dengan validasi inline. Ulasan baru langsung ditambahkan ke tampilan secara instan (reverse chronological).
- **State Management**: Menggunakan `Provider` untuk manajemen _state_ dan memisahkan logika UI.
- **Image Caching**: Memanfaatkan `cached_network_image` untuk optimalisasi gambar.

---

## 🚀 Kebutuhan & Instalasi

- Flutter SDK: `^3.11.0`
- Dart SDK: `^3.0.0`

### Cara Menjalankan Aplikasi:

1. _Clone_ repository ini ke lokal:
   ```bash
   git clone https://github.com/k-ardliyan/restaurant_app.git
   ```
2. Unduh dependencies bawaan:
   ```bash
   flutter pub get
   ```
3. Targetkan emulator perangkat Anda lalu jalankan aplikasi:
   ```bash
   flutter run
   ```

---

## 👨‍💻 _Author_

[k-ardliyan](https://github.com/k-ardliyan)

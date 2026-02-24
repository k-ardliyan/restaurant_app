# Restaurant App

Aplikasi Flutter sebagai **submission akhir** Dicoding — Belajar Fundamental Aplikasi Flutter.
Mengimplementasikan manajemen state, persistensi data lokal, notifikasi terjadwal, dan automated testing.

---

## Fitur Utama

### Katalog & Pencarian

- Menampilkan daftar restoran dari REST API Dicoding
- Live search dengan debounce 500ms
- Error state dengan pesan dan tombol Retry saat gagal memuat data

### Detail Restoran

- Informasi lengkap: deskripsi, kota, rating, kategori, menu makanan & minuman
- Header gambar yang bisa di-zoom (fullscreen interactive viewer)
- Sistem ulasan: tambah review via Bottom Sheet dengan validasi inline
- Ulasan baru langsung tampil secara instan (reverse chronological)

### Favorit Restoran

- Simpan dan hapus restoran favorit
- Data favorit tersimpan di database SQLite (persisten)
- Indikator ikon favorit pada setiap card di halaman list, pencarian, dan favorit
- Navigasi dari halaman favorit langsung ke detail restoran

### Pengaturan Tema

- Toggle Dark Mode / Light Mode
- Preferensi tema disimpan via SharedPreferences (persisten setelah restart)

### Daily Reminder

- Notifikasi harian pukul 11:00 AM menggunakan Workmanager
- Menampilkan restoran acak dari API setiap hari
- Toggle aktif/nonaktif tersimpan via SharedPreferences

---

## Tech Stack

| Layer            | Library                       |
| ---------------- | ----------------------------- |
| State Management | `provider`                    |
| HTTP             | `http`                        |
| Local DB         | `sqflite` + `path`            |
| Preferences      | `shared_preferences`          |
| Background Task  | `workmanager`                 |
| Notification     | `flutter_local_notifications` |
| Image            | `cached_network_image`        |
| Font             | `google_fonts`                |
| Animation        | `lottie`                      |

---

## Testing

| #    | File                               | Jenis       | Skenario                                                                               |
| ---- | ---------------------------------- | ----------- | -------------------------------------------------------------------------------------- |
| 1–3  | `test/provider_test.dart`          | Unit        | Initial state, API success, API error pada `RestaurantListProvider`                    |
| 4–7  | `test/api_service_test.dart`       | Unit        | `getRestaurantList` (success & HTTP error), `getRestaurantDetail`, `searchRestaurants` |
| 8–13 | `test/database_provider_test.dart` | Unit        | CRUD SQLite via `DatabaseProvider` (mock `DatabaseHelper`)                             |
| 14   | `test/widget_test.dart`            | Widget      | `RestaurantCard` render nama, kota, rating                                             |
| 15   | `integration_test/app_test.dart`   | Integration | E2E: tap restoran → favorit → verifikasi di halaman favorit                            |

```bash
# Jalankan unit + widget test
flutter test

# Jalankan integration test (butuh emulator/device)
flutter test integration_test/app_test.dart
```

---

## Instalasi & Menjalankan

**Prasyarat:** Flutter SDK `^3.11.0`

```bash
# Clone repository
git clone https://github.com/k-ardliyan/restaurant_app.git
cd restaurant_app

# Install dependencies
flutter pub get

# Generate mock files (untuk testing)
dart run build_runner build --delete-conflicting-outputs

# Jalankan aplikasi
flutter run

# Build APK release
flutter build apk --release
```

---

## Struktur Proyek

```
lib/
  core/
    constants/    # API constants
    state/        # ResultState sealed class
    theme/        # AppTheme light & dark
  data/
    api/          # ApiService (HTTP)
    db/           # DatabaseHelper (SQLite)
    models/       # Data models
    preferences/  # PreferencesHelper (SharedPreferences)
  provider/       # ChangeNotifier providers
  ui/
    pages/        # Halaman aplikasi
    widgets/      # Widget reusable
  utils/          # NotificationHelper, BackgroundService (Workmanager)
  main.dart
test/             # Unit & widget test
integration_test/ # Integration test (E2E)
```

---

## Author

[@k-ardliyan](https://github.com/k-ardliyan)

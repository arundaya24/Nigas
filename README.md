# Nigas ⚡
> **Aplikasi pencatat dan pengelola tugas sekolah buat anak SMK.**  
> Ringan, tanpa akun, 100% luring (offline-first), dan tampil beda dengan gaya neo-brutalisme modern.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Database](https://img.shields.io/badge/SQLite-Drift-003B57?logo=sqlite&logoColor=white)](https://drift.simonbinder.eu/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-blue)](#)

---

## 🎯 Kenapa Bikin Nigas?

Kalau kamu anak SMK, kamu pasti tahu rasanya waktu tugas kejuruan (praktikum, ngoding, instalasi jaringan, render video) mulai numpuk barengan sama tugas mapel umum. Banyak aplikasi to-do list di Play Store yang:
- Terlalu ribet (harus register, verifikasi email, login Google).
- Banyak iklan atau fitur berbayar.
- Harus ada koneksi internet cuma buat nyatet PR besok pagi.
- Formatnya kaku dan nggak ramah buat struktur mapel SMK.

**Nigas** dibuat sesimpel mungkin: install, buka, langsung catat. Semua data tersimpan aman di HP kamu, nggak dikirim ke server mana pun, dan bisa dipakai kapan aja tanpa kuota.

---

## ✨ Fitur Andalan

### 1. Template Jurusan SMK Siap Pakai
Nggak perlu ngetik nama mapel satu-satu dari nol. Saat aplikasi pertama kali dibuka, Nigas sudah menyiapkan template mapel kejuruan dan umum:
- **RPL (Rekayasa Perangkat Lunak):** `PAD`, `PWEB`, `PPB`, `UI/UX`, `APS`.
- **TKJ (Teknik Komputer & Jaringan):** `ASJ`, `KEJAR`, `KPJ`, `DMIKRO`, `TJKN`, `PPJ`.
- **DKV (Desain Komunikasi Visual):** `Fotografi`, `Videografi`, `KPD`, `DP`, `Desain Cetak`, `AMG`.
- **Mata Pelajaran Umum:** `PAI`, `PKK`, `PPKn`, `B. Indo`, `B. Inggris`, `Sejarah`, `MTK`, `PJOK`, `B. Jepang`, `BTQ`, `BP/BK`.
> *Kamu tetap bebas nambah, ganti nama, ubah warna tag, atau hapus mapel sesuai kurikulum sekolahmu lewat menu Pengaturan.*

### 2. Checklist Subtugas (Step-by-Step)
Tugas besar kayak "Proyek Web Laravel" atau "Bikin Banner Promosi" biasanya butuh beberapa tahapan. Kamu bisa pecah tugas jadi checklist subtugas kecil lengkap dengan progress bar otomatis. Begitu semua subtugas dicentang, aplikasi bakal nawarin buat langsung tandai tugas utama sebagai selesai.

### 3. Pengingat Deadline Lokal (H-1 & Hari-H)
- Notifikasi berjalan 100% lokal di perangkatmu via `flutter_local_notifications` dan `timezone`.
- Jadwal otomatis: **H-1** sore hari dan **Hari-H** pagi hari sebelum jam masuk sekolah.
- Jam notifikasi bisa diatur sesuka hati lewat menu Pengaturan.

### 4. Navigasi & Filter Sat-Set
- **Pencarian Cepat (Live Search):** Cari berdasarkan judul tugas, mapel, atau isi catatan tambahan.
- **Filter Status:** Pisahkan antara tugas yang `Belum`, `Sedang Dikerjakan`, atau `Selesai`.
- **Grup Deadline Cerdas:** Tugas otomatis dikelompokkan: *Lewat Deadline*, *Hari Ini*, *Besok*, *Minggu Ini*, dan *Nanti*.

### 5. Desain Neo-Brutalisme yang Segar & Rapi
- Menggunakan tipografi tegas (`Space Grotesk` untuk judul dan `Space Mono` untuk metadata/jam).
- Border tebal dengan shadow retro yang konsisten.
- Mendukung **Mode Terang** dan **Mode Gelap** yang nyaman di mata, plus deteksi otomatis dari tema sistem HP.

### 6. Privasi 100% & Manajemen Data
- Tanpa pelacak, analitik, maupun koneksi eksternal.
- Fitur **Bersihkan Tugas Selesai** untuk membersihkan daftar tanpa menghilangkan tugas yang masih aktif.
- Opsi **Reset Data Pabrik** kalau mau mengulang dari awal.

---

## 🛠️ Tech Stack & Arsitektur

Aplikasi ini dibangun menggunakan arsitektur fitur (*feature-first*) yang terpisah dan mudah dipelihara:

| Komponen | Pustaka / Teknologi |
|---|---|
| **Framework** | [Flutter](https://flutter.dev) (Dart SDK 3.5+) |
| **State Management** | [Flutter Riverpod](https://riverpod.dev) |
| **Local Database** | [Drift (SQLite)](https://drift.simonbinder.eu) dengan reactive streams |
| **Routing / Navigasi** | [GoRouter](https://pub.dev/packages/go_router) |
| **Notifikasi Lokal** | `flutter_local_notifications` + `flutter_timezone` |
| **Desain & UI Tokens** | Custom Theme Extension (`NeoBrutalTokens`) |
| **Fonts** | Space Grotesk & Space Mono (Open Font License) |

### Struktur Folder

```text
lib/
├── core/
│   ├── constants/       # Warna tema, string statis, palet mapel
│   ├── db/              # Skema tabel Drift (SQLite), koneksi, dan provider
│   ├── navigation/      # Deklarasi rute go_router
│   ├── theme/           # Definisi tema (Light/Dark) & neo-brutal tokens
│   └── widgets/         # Komponen UI reusable (Button, TextField, Chip, Card, dll)
├── features/
│   ├── tasks/           # Alur tugas: home screen, detail tugas, form add/edit, filter
│   ├── subjects/        # Manajemen mapel kustom & template jurusan
│   ├── settings/        # Pengaturan tema, jam notifikasi, & kelola data
│   └── reminders/       # Logic scheduler & helper notifikasi lokal
└── main.dart            # Entry point aplikasi & inisialisasi background service
```

---

## 🚀 Memulai (Local Setup)

### Prasyarat
Pastikan komputer kamu sudah terpasang:
1. **Flutter SDK** versi `3.24.0` ke atas (`flutter doctor` centang hijau).
2. **Android Studio** atau **VS Code** dengan ekstensi Flutter/Dart.
3. Emulator Android atau perangkat fisik dengan fitur *USB Debugging* aktif.

### Langkah Instalasi

1. **Clone repository ini:**
   ```bash
   git clone https://github.com/username/nigas.git
   cd "nigas"
   ```

2. **Pasang dependency:**
   ```bash
   flutter pub get
   ```

3. **(Opsional) Generate kode database jika mengubah skema:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Jalankan aplikasi di perangkat:**
   ```bash
   # Jalankan di Android
   flutter run

   # Atau jalankan di Chrome (Web Mode)
   flutter run -d chrome
   ```

---

## 🧪 Pengujian & Kualitas Kode

Proyek ini dilengkapi rangkaian pengujian unit dan widget (termasuk verifikasi timezone deadline, form validation, filter status, dan layout constraints):

```bash
# Jalankan seluruh unit & widget test
flutter test

# Cek static analysis (linter)
flutter analyze
```

---

## 📦 Build APK (Release)

Untuk menghasilkan file APK siap pasang di HP Android:

```bash
flutter build apk --release
```

Hasil build berada di:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🤝 Kontribusi

Mau nambahin template jurusan SMK baru (misal: Otomotif/TKRO, Akuntansi, Perhotelan) atau punya ide perbaikan UI/UX?
1. Fork repo ini.
2. Buat branch fitur baru (`git checkout -b fitur-keren`).
3. Commit perubahanmu (`git commit -m "Tambah template jurusan TKRO"`).
4. Push ke branch (`git push origin fitur-keren`).
5. Buat **Pull Request**.

---

## 📄 Lisensi

Dibuat dengan ❤️ untuk teman-teman pelajar SMK di Indonesia.  
Proyek ini dilisensikan di bawah lisensi [MIT](LICENSE). Bebas dipelajari, dimodifikasi, dan dikembangkan lebih lanjut.

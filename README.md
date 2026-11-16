# Nigas

Aplikasi manajemen tugas luring (offline) yang dirancang untuk siswa Sekolah Menengah Kejuruan (SMK). Aplikasi ini membantu siswa mengorganisasi tugas kejuruan maupun mata pelajaran umum dalam satu antarmuka yang terstruktur.

## Fitur Utama

### 1. Pengelompokan Berdasarkan Jurusan dan Mapel Umum
- Jurusan Kejuruan: Tersedia menu khusus untuk jurusan Rekayasa Perangkat Lunak (RPL), Teknik Komputer dan Jaringan (TKJ), serta Desain Komunikasi Visual (DKV).
- Mata Pelajaran Umum: Menu khusus untuk mata pelajaran wajib seperti Matematika, Bahasa Indonesia, Bahasa Inggris, dan lainnya.
- Navigasi Langsung: Setiap kartu jurusan atau mapel umum dapat diklik untuk membuka daftar tugas spesifik kategori tersebut.

### 2. Manajemen To-Do List dan Status Tugas
- Tiga Tahapan Status: Setiap tugas memiliki indikator status yang jelas, yaitu Belum Dikerjakan, Sedang Dikerjakan, dan Sudah Selesai.
- Penggantian Status Cepat: Status tugas dapat diubah langsung melalui penanda status pada kartu tugas atau melalui halaman detail tugas.
- Penyelesaian Tugas: Kotak centang untuk menandai tugas selesai secara instan dengan opsi pembatalan (undo).
- Subtugas: Dukungan penambahan rincian subtugas berupa daftar periksa dengan bar progres otomatis.

### 3. Template dan Pengelolaan Mata Pelajaran
- Template Bawaan: Disediakan daftar mata pelajaran bawaan untuk setiap jurusan dan mapel umum saat aplikasi pertama kali dijalankan.
- Penambahan Bebas: Pengguna dapat memilih template yang tersedia atau membuat mata pelajaran baru secara mandiri.
- Manajemen Penuh: Pengguna dapat mengubah nama mata pelajaran, warna label, maupun menghapus mata pelajaran dari menu pengaturan.

### 4. Pengingat Deadline Lokal
- Notifikasi Luring: Pengingat berjalan sepenuhnya di perangkat tanpa memerlukan koneksi internet atau pembuatan akun.
- Jadwal Pengingat: Pengingat otomatis menjelang batas waktu pengumpulan (H-1 dan Hari-H).
- Penyesuaian Jam: Waktu pengingat dapat disesuaikan melalui halaman Pengaturan.

### 5. Dukungan Multiplatform
- Android: Menggunakan penyimpanan lokal SQLite native.
- Web: Menggunakan SQLite berbasis WebAssembly (WASM) dan Web Worker dengan penyimpanan persisten di peramban.

## Kebutuhan Sistem

- Flutter SDK versi 3.24 atau lebih baru
- Dart SDK versi 3.5 atau lebih baru
- Google Chrome (untuk menjalankan versi web)
- Android SDK dan Android Studio (untuk menjalankan versi Android)

## Petunjuk Penggunaan

### 1. Persiapan Dependensi

Jalankan perintah berikut di direktori proyek:

```bash
flutter pub get
```

### 2. Menjalankan Aplikasi di Peramban Web

```bash
flutter run -d chrome
```

### 3. Menjalankan Aplikasi di Perangkat Android

Pastikan perangkat Android atau emulator telah terhubung:

```bash
flutter run -d android
```

### 4. Menjalankan Pengujian

Untuk menjalankan seluruh unit test dan widget test:

```bash
flutter test
```

### 5. Pemeriksaan Kualitas Kode

```bash
flutter analyze
```

## Struktur Direktori

```text
lib/
├── core/
│   ├── constants/       # Konstanta warna, string, dan teks aplikasi
│   ├── db/              # Konfigurasi database Drift, migrasi skema, dan provider
│   ├── navigation/      # Konfigurasi rute menggunakan GoRouter
│   ├── theme/           # Konfigurasi tema dan token tampilan
│   └── widgets/         # Komponen antarmuka yang dapat digunakan ulang
├── features/
│   ├── tasks/           # Modul tugas, to-do list, filter status, dan form tugas
│   ├── subjects/        # Modul pengelolaan mata pelajaran dan kategori SMK
│   ├── settings/        # Modul pengaturan jam pengingat dan preferensi tema
│   └── reminders/       # Modul perhitungan jadwal pengingat dan notifikasi lokal
└── main.dart            # Titik masuk utama aplikasi
```

## Lisensi

Proyek ini ditujukan untuk kebutuhan personal dan edukasi.

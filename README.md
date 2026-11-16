# Nigas (Aplikasi Manajemen Tugas Siswa SMK)

Aplikasi manajemen tugas (To-Do List & Task Manager) offline yang dirancang khusus untuk siswa SMK. Aplikasi ini hadir dengan desain antarmuka yang bersih, modern, dan nyaman dipandang mata—memudahkan siswa untuk fokus mengelola tugas kejuruan maupun tugas mata pelajaran umum.

---

## 🚀 Fitur Unggulan

### 1. Navigasi Berdasarkan Jurusan & Mapel Umum
- **RPL (Rekayasa Perangkat Lunak):** Kartu interaktif untuk tugas-tugas kejuruan seperti Pemrograman Web, Pemrograman Berorientasi Objek, Basis Data, dll.
- **TKJ (Teknik Komputer & Jaringan):** Pengelompokan tugas seperti Jaringan Dasar, Administrasi Server, Keamanan Jaringan, dll.
- **DKV (Desain Komunikasi Visual):** Pengelompokan tugas seperti Desain Grafis, Ilustrasi Digital, Fotografi, Animasi 2D/3D, dll.
- **Mata Pelajaran Umum:** Terletak rapi di bawah kartu kejuruan untuk tugas Matematika, Bahasa Indonesia, Bahasa Inggris, Pendidikan Pancasila, dll.

Setiap kartu jurusan dan mapel umum dapat diklik langsung untuk membuka daftar tugas spesifik jurusan tersebut lengkap dengan filter mapel dan filter status.

### 2. To-Do List Interaktif & 3 Status Tugas
Siswa memegang kendali penuh atas manajemen tugas mereka dengan indikator visual yang jelas:
- ⚪ **Belum Dikerjakan (`todo`):** Tugas yang baru dibuat atau belum disentuh.
- 🟡 **Sedang Dikerjakan (`inProgress`):** Tugas yang sedang dalam proses pengerjaan.
- 🟢 **Sudah Selesai (`done`):** Tugas yang telah rampung dikerjakan.

**Interaksi Fleksibel:**
- **Checkbox Cepat:** Ketuk checkbox untuk menandai tugas langsung selesai (dilengkapi tombol *URUNGKAN* / *Undo* pada notifikasi SnackBar).
- **Badge Status:** Ketuk badge status pada kartu tugas untuk memunculkan pemilih status interaktif (Belum, Sedang, Selesai).
- **Subtugas (Checklist):** Setiap tugas dapat memiliki daftar checklist subtugas dengan progres bar dinamis.

### 3. Template Mata Pelajaran yang Fleksibel
- Dilengkapi template mata pelajaran default untuk masing-masing jurusan SMK dan Mapel Umum yang otomatis terisi saat pertama kali digunakan.
- Siswa dapat menambah tugas baru dengan memilih template yang ada atau mengetik mata pelajaran baru secara mandiri.
- Manajemen mata pelajaran lengkap: ubah nama, ganti warna label, tambah mapel kustom, atau hapus mapel.

### 4. Pengingat Deadline & Notifikasi Lokal (100% Offline)
- Pengingat otomatis menjelang deadline:
  - **H-1 Deadline** (Default: 18:00 WIB)
  - **Hari-H Deadline** (Default: 07:00 WIB)
- Waktu pengingat dapat disesuaikan sesuka hati melalui menu Pengaturan.
- Berjalan sepenuhnya offline tanpa perlu koneksi internet, backend, ataupun registrasi akun.

### 5. Tampilan Sederhana & Nyaman Dipandang
- Menggunakan pendekatan desain yang rapi dan terstruktur: sudut membulat elegan (16px), bayangan halus, garis pemisah lembut, serta tipografi kontras yang nyaman dibaca (`Space Grotesk` & `JetBrains Mono`).

---

## 💻 Cara Menjalankan Aplikasi

File entry point utama aplikasi adalah:
`lib/main.dart`

### 1. Menjalankan di Browser (Chrome Web)
Untuk mencoba atau melihat aplikasi dengan cepat di komputer:
```bash
flutter run -d chrome
```

### 2. Menjalankan di Android (Device / Emulator)
Pastikan perangkat Android atau emulator sudah terhubung (`flutter devices`):
```bash
flutter run -d android
```

### 3. Menjalankan Pengujian (Unit & Widget Tests)
Seluruh fungsionalitas dan logika pengingat telah diuji:
```bash
flutter test
```

### 4. Analisis Kode (Linter)
```bash
flutter analyze
```

---

## 📁 Struktur Arsitektur Proyek

Proyek ini dibangun menggunakan arsitektur modular Feature-First berbasis **Flutter Riverpod**, **Drift (SQLite)**, dan **GoRouter**:

```text
lib/
├── core/
│   ├── constants/       # AppColors, AppStrings
│   ├── db/              # Drift Database (AppDatabase v2, migrasi & DAOs)
│   ├── navigation/      # GoRouter AppRouter
│   ├── theme/           # AppTheme, NeoBrutalTokens
│   └── widgets/         # Komponen UI: NeoBrutalCard, TaskStatusBadge, Checkbox, Chip, dll.
├── features/
│   ├── tasks/           # Manajemen tugas, to-do list, home screen, kategori screen, form & detail
│   ├── subjects/        # Pengelolaan mapel SMK (RPL, TKJ, DKV, General) & dialog edit
│   ├── settings/        # Pengaturan waktu pengingat & preferensi tema
│   └── reminders/       # ReminderCalculator & NotificationService lokal
└── main.dart            # Entry point aplikasi
```

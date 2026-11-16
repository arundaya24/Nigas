# Nigas

Aplikasi manajemen tugas untuk siswa SMK yang membantu mengatur tugas kejuruan maupun mata pelajaran umum dalam satu tempat.

## Preview

<!-- Tambahkan screenshot aplikasi di sini -->

## Features

- Pengelompokan tugas berdasarkan jurusan RPL, TKJ, DKV, dan mata pelajaran umum.
- Manajemen tugas dengan tiga status: To Do, In Progress, dan Done.
- Checklist subtugas dengan indikator progres.
- Pengelolaan mata pelajaran secara mandiri.
- Pengingat deadline otomatis.
- Notifikasi lokal tanpa koneksi internet.
- Pengaturan waktu pengingat dan preferensi tema.
- Penyimpanan data secara lokal.

## Tech Stack

- Flutter
- Dart
- Riverpod
- Drift (SQLite)
- GoRouter

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── db/
│   ├── navigation/
│   ├── theme/
│   └── widgets/
├── features/
│   ├── tasks/
│   ├── subjects/
│   ├── settings/
│   └── reminders/
└── main.dart
```

## Getting Started

Clone repository:

```bash
git clone https://github.com/username/nigas.git
```

Masuk ke direktori project:

```bash
cd nigas
```

Install dependencies:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

## Requirements

- Flutter SDK
- Dart SDK
- Android Studio atau VS Code
- Android Emulator atau perangkat Android

## License

This project is available for personal and educational use.
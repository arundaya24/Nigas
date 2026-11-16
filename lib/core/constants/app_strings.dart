/// Kumpulan konstanta teks UI dalam Bahasa Indonesia untuk Nigas.
/// Tidak ada string hardcode yang berserakan di kode presentation.
class AppStrings {
  AppStrings._();

  // App Name & Tagline
  static const String appName = 'Nigas';
  static const String appTagline = 'Pencatat Tugas Siswa SMK';

  // Navigation & Tabs
  static const String tabPending = 'Belum Selesai';
  static const String tabCompleted = 'Selesai';
  static const String allSubjects = 'Semua';
  static const String searchTasks = 'Cari tugas...';

  // Deadline Grouping Labels
  static const String groupOverdue = 'Telat';
  static const String groupToday = 'Hari ini';
  static const String groupTomorrow = 'Besok';
  static const String groupThisWeek = 'Minggu ini';
  static const String groupLater = 'Nanti';

  // Stickers
  static const String stickerOverdue = 'TELAT';
  static const String stickerToday = 'HARI INI';
  static const String stickerTomorrow = 'BESOK';
  static const String stickerDaysLeft = 'HARI LAGI';
  static const String stickerDone = 'SELESAI';

  // Empty States
  static const String emptyPendingTitle = 'Kosong. Mantap.';
  static const String emptyPendingSubtitle =
      'Semua tugas beres atau belum ada tugas baru. Jangan lupa istirahat!';
  static const String emptyCompletedTitle = 'Belum ada yang beres';
  static const String emptyCompletedSubtitle =
      'Selesaikan tugas pertamamu hari ini. Semangat!';
  static const String emptyFilterTitle = 'Tidak ada tugas';
  static const String emptyFilterSubtitle =
      'Belum ada tugas untuk mata pelajaran ini.';

  // Actions
  static const String addTask = 'Tambah Tugas';
  static const String editTask = 'Edit Tugas';
  static const String deleteTask = 'Hapus Tugas';
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String undo = 'Urungkan';
  static const String markDone = 'Tandai Selesai';
  static const String markUndone = 'Kembalikan';
  static const String delete = 'Hapus';

  // Task Form Fields
  static const String taskTitle = 'Judul Tugas';
  static const String taskTitleHint = 'Misal: Laporan Praktikum TKJ';
  static const String taskSubject = 'Mata Pelajaran';
  static const String taskSubjectSelect = 'Pilih Mata Pelajaran';
  static const String selectSubjectHint = 'Pilih Mata Pelajaran';
  static const String saveChanges = 'Simpan Perubahan';
  static const String saveTask = 'Simpan Tugas';
  static const String markTaskDone = 'Tandai Selesai';
  static const String later = 'Nanti Saja';
  static const String allSubtasksCompleted = 'Semua Subtugas Selesai!';
  static const String addNewSubjectInline = '+ Tambah mapel baru';
  static const String taskDeadline = 'Tenggat Waktu';
  static const String taskNotes = 'Catatan';
  static const String taskNotesHint = 'Tambahkan instruksi guru atau catatan...';
  static const String taskSubtasks = 'Subtugas / Langkah Pengerjaan';
  static const String addSubtask = 'Tambah Langkah';
  static const String subtaskHint = 'Tulis langkah pengerjaan...';

  // Validation Errors
  static const String errorTitleRequired = 'Judul tugas wajib diisi';
  static const String errorSubjectRequired = 'Pilih salah satu mata pelajaran';
  static const String errorDeadlinePast =
      'Tenggat waktu tidak boleh sebelum waktu sekarang';
  static const String errorSubtaskEmpty = 'Teks subtugas tidak boleh kosong';
  static const String errorSubjectNameRequired = 'Nama mapel wajib diisi';

  // Snackbars & Notifications
  static const String taskCreated = 'Tugas berhasil ditambahkan!';
  static const String taskUpdated = 'Tugas berhasil diperbarui!';
  static const String taskDeleted = 'Tugas dihapus.';
  static const String taskMarkedDone = 'Tugas diselesaikan! Mantap!';
  static const String taskMarkedUndone = 'Tugas dikembalikan ke daftar.';
  static const String allSubtasksCompletedPrompt =
      'Semua subtugas selesai! Tandai tugas utama selesai?';

  // Subjects Management
  static const String manageSubjects = 'Kelola Mapel';
  static const String addSubject = 'Tambah Mapel';
  static const String editSubject = 'Edit Mapel';
  static const String deleteSubject = 'Hapus Mapel';
  static const String subjectName = 'Nama Mapel';
  static const String subjectColor = 'Pilih Warna';
  static const String deleteSubjectHasTasks =
      'Mapel ini masih memiliki tugas. Pindahkan tugas ke mapel lain atau selesaikan dulu.';
  static const String moveTasksTo = 'Pindahkan tugas ke:';

  // Settings
  static const String settings = 'Pengaturan';
  static const String appearance = 'Mode Tampilan';
  static const String themeLight = 'Terang';
  static const String themeDark = 'Gelap';
  static const String themeSystem = 'Ikuti Sistem';
  static const String notificationSettings = 'Pengingat Tugas';
  static const String reminderD1 = 'Pengingat H-1';
  static const String reminderD0 = 'Pengingat Hari-H';
  static const String vocationalMajor = 'Jurusan SMK';
  static const String changeMajor = 'Ganti Jurusan';
  static const String changeMajorNote =
      'Mengganti jurusan akan menambahkan mapel kejuruan baru tanpa menghapus tugas yang sudah ada.';

  // Onboarding
  static const String onboardingTitle = 'Pilih Jurusan SMK Kamu';
  static const String onboardingSubtitle =
      'Nigas akan menyiapkan daftar mata pelajaran umum dan kejuruan secara otomatis.';
  static const String selectMajor = 'Pilih Jurusan';
  static const String startApp = 'Mulai Menggunakan Nigas';

  // Component Showcase
  static const String showcaseTitle = 'Neo-Brutalism Showcase';
}


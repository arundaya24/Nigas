/// Representasi jurusan SMK dan preset mata pelajarannya.
class PresetSubjectItem {
  final String name;
  final int colorIndex;
  final bool isVocational;

  const PresetSubjectItem({
    required this.name,
    required this.colorIndex,
    this.isVocational = false,
  });
}

class VocationalMajor {
  final String code;
  final String name;
  final String description;
  final List<PresetSubjectItem> vocationalSubjects;

  const VocationalMajor({
    required this.code,
    required this.name,
    required this.description,
    required this.vocationalSubjects,
  });
}

/// Daftar preset mata pelajaran umum untuk semua siswa SMK
const List<PresetSubjectItem> kGeneralSubjects = [
  PresetSubjectItem(name: 'Matematika', colorIndex: 0), // Yellow
  PresetSubjectItem(name: 'Bahasa Indonesia', colorIndex: 4), // Pink
  PresetSubjectItem(name: 'Bahasa Inggris', colorIndex: 2), // Blue
  PresetSubjectItem(name: 'PPKn', colorIndex: 1), // Red
  PresetSubjectItem(name: 'Pendidikan Agama & Budi Pekerti', colorIndex: 3), // Lime
  PresetSubjectItem(name: 'PJOK', colorIndex: 5), // Orange
  PresetSubjectItem(name: 'Sejarah Indonesia', colorIndex: 6), // Cyan
  PresetSubjectItem(name: 'Seni Budaya', colorIndex: 7), // Purple
];

/// Daftar seluruh jurusan SMK yang didukung
const List<VocationalMajor> kVocationalMajors = [
  VocationalMajor(
    code: 'TKJ',
    name: 'Teknik Komputer & Jaringan (TKJ)',
    description: 'Jaringan komputer, routing, server, dan administrasi sistem',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Administrasi Infrastruktur Jaringan', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Administrasi Sistem Jaringan', colorIndex: 6, isVocational: true),
      PresetSubjectItem(name: 'Teknologi Jaringan Berbasis Luas (WAN)', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Teknologi Layanan Jaringan', colorIndex: 3, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'RPL',
    name: 'Rekayasa Perangkat Lunak (RPL)',
    description: 'Pengembangan aplikasi mobile, web, desktop, dan database',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Pemrograman Web & Perangkat Bergerak', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Pemrograman Berorientasi Objek', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Basis Data', colorIndex: 3, isVocational: true),
      PresetSubjectItem(name: 'Pemodelan Perangkat Lunak', colorIndex: 5, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'DKV',
    name: 'Multimedia / DKV',
    description: 'Desain grafis, animasi 2D/3D, audio video, dan fotografi',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Desain Grafis Percetakan', colorIndex: 4, isVocational: true),
      PresetSubjectItem(name: 'Animasi 2D dan 3D', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Teknik Pengolahan Audio & Video', colorIndex: 1, isVocational: true),
      PresetSubjectItem(name: 'Fotografi & Desain Media Interaktif', colorIndex: 7, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'AKL',
    name: 'Akuntansi & Keuangan Lembaga',
    description: 'Akuntansi jasa, dagang, manufaktur, perpajakan, dan spreadsheet',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Praktikum Akuntansi Perusahaan Jasa & Dagang', colorIndex: 3, isVocational: true),
      PresetSubjectItem(name: 'Komputer Akuntansi (Spreadsheet/MYOB)', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Administrasi Pajak', colorIndex: 1, isVocational: true),
      PresetSubjectItem(name: 'Akuntansi Keuangan', colorIndex: 0, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'MPLB',
    name: 'Perkantoran / Manajemen',
    description: 'Administrasi perkantoran, tata kelola kepegawaian, dan kearsipan',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Otomatisasi Tata Kelola Kepegawaian', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Otomatisasi Tata Kelola Keuangan', colorIndex: 3, isVocational: true),
      PresetSubjectItem(name: 'Otomatisasi Tata Kelola Sarana & Prasarana', colorIndex: 5, isVocational: true),
      PresetSubjectItem(name: 'Otomatisasi Tata Kelola Humas & Keprotokolan', colorIndex: 7, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'BDP',
    name: 'Pemasaran (Bisnis Daring)',
    description: 'Digital marketing, retail bisnis, penataan produk, dan penjualan',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Bisnis Online & Digital Marketing', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Pengelolaan Bisnis Ritel', colorIndex: 5, isVocational: true),
      PresetSubjectItem(name: 'Penataan Produk (Visual Merchandising)', colorIndex: 4, isVocational: true),
      PresetSubjectItem(name: 'Perencanaan & Komunikasi Bisnis', colorIndex: 6, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'PH',
    name: 'Perhotelan',
    description: 'Front office, housekeeping, layanan makanan, dan perhotelan',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Front Office Hotel', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Housekeeping & Laundry', colorIndex: 6, isVocational: true),
      PresetSubjectItem(name: 'Food & Beverage Service', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Industri Perhotelan', colorIndex: 3, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'TB',
    name: 'Tata Boga (Kuliner)',
    description: 'Pengolahan makanan, pastry, hidang nusantara, dan kue Indonesia',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Pengolahan & Penyajian Makanan', colorIndex: 1, isVocational: true),
      PresetSubjectItem(name: 'Produk Pastry dan Bakery', colorIndex: 5, isVocational: true),
      PresetSubjectItem(name: 'Produk Cake dan Kue Indonesia', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Tata Hidang Restoran', colorIndex: 4, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'TKR',
    name: 'Teknik Kendaraan Ringan (TKR)',
    description: 'Mesin mobil, sasis, pemindah tenaga, dan kelistrikan mobil',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Pemeliharaan Mesin Kendaraan Ringan', colorIndex: 1, isVocational: true),
      PresetSubjectItem(name: 'Pemeliharaan Sasis & Pemindah Tenaga', colorIndex: 5, isVocational: true),
      PresetSubjectItem(name: 'Pemeliharaan Kelistrikan Kendaraan Ringan', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Produk Kreatif & Kewirausahaan Otomotif', colorIndex: 2, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'TSM',
    name: 'Teknik Sepeda Motor (TSM)',
    description: 'Tune up, injeksi motor, sasis, kelistrikan, dan bengkel motor',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Pemeliharaan Mesin Sepeda Motor', colorIndex: 1, isVocational: true),
      PresetSubjectItem(name: 'Pemeliharaan Sasis Sepeda Motor', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Pemeliharaan Listrik Sepeda Motor', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Pengelolaan Bengkel Sepeda Motor', colorIndex: 3, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'TE',
    name: 'Teknik Elektronika',
    description: 'Rangkaian elektronika, sistem kendali, IoT, dan audio video',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Penerapan Rangkaian Elektronika', colorIndex: 6, isVocational: true),
      PresetSubjectItem(name: 'Sistem Pengendali Elektronik & PLC', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Pemrograman Sistem Tertanam (Embedded System)', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'Perencanaan Sistem Audio Video', colorIndex: 7, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'FAR',
    name: 'Farmasi',
    description: 'Farmakologi, farmasetika resep, kimia farmasi, dan obat herbal',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Pelayanan Farmasi (Farmasetika)', colorIndex: 3, isVocational: true),
      PresetSubjectItem(name: 'Farmakologi & Toksikologi', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Farmakognosi Obat Bahan Alam', colorIndex: 6, isVocational: true),
      PresetSubjectItem(name: 'Kimia Farmasi', colorIndex: 4, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'KEP',
    name: 'Keperawatan',
    description: 'Kebutuhan dasar manusia, tindakan keperawatan, dan anatomi tubuh',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Kebutuhan Dasar Manusia (KDM)', colorIndex: 4, isVocational: true),
      PresetSubjectItem(name: 'Keterampilan Dasar Tindakan Keperawatan', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'Komunikasi Keperawatan & Etika Profesi', colorIndex: 3, isVocational: true),
      PresetSubjectItem(name: 'Anatomi Fisiologi & Ilmu Kesehatan', colorIndex: 1, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'OTHER',
    name: 'Lainnya (Hanya Mapel Umum)',
    description: 'Hanya mengisi mapel umum sekolah tanpa preset kejuruan tambahan',
    vocationalSubjects: [],
  ),
];


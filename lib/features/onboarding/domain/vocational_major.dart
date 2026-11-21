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
  PresetSubjectItem(name: 'PAI', colorIndex: 0),
  PresetSubjectItem(name: 'PKK', colorIndex: 1),
  PresetSubjectItem(name: 'PPKn', colorIndex: 2),
  PresetSubjectItem(name: 'B. Indo', colorIndex: 3),
  PresetSubjectItem(name: 'B. Inggris', colorIndex: 4),
  PresetSubjectItem(name: 'Sejarah', colorIndex: 5),
  PresetSubjectItem(name: 'MTK', colorIndex: 6),
  PresetSubjectItem(name: 'PJOK', colorIndex: 7),
  PresetSubjectItem(name: 'B. Jepang', colorIndex: 0),
  PresetSubjectItem(name: 'BTQ', colorIndex: 1),
  PresetSubjectItem(name: 'BP/BK', colorIndex: 2),
];

/// Daftar seluruh jurusan SMK yang didukung
const List<VocationalMajor> kVocationalMajors = [
  VocationalMajor(
    code: 'TKJ',
    name: 'Teknik Komputer & Jaringan (TKJ)',
    description: 'Jaringan komputer, routing, server, dan administrasi sistem',
    vocationalSubjects: [
      PresetSubjectItem(name: 'ASJ', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'KEJAR', colorIndex: 6, isVocational: true),
      PresetSubjectItem(name: 'KPJ', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'DMIKRO', colorIndex: 3, isVocational: true),
      PresetSubjectItem(name: 'TJKN', colorIndex: 1, isVocational: true),
      PresetSubjectItem(name: 'PPJ', colorIndex: 5, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'RPL',
    name: 'Rekayasa Perangkat Lunak (RPL)',
    description: 'Pengembangan aplikasi mobile, web, desktop, dan database',
    vocationalSubjects: [
      PresetSubjectItem(name: 'PAD', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'PWEB', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'PPB', colorIndex: 3, isVocational: true),
      PresetSubjectItem(name: 'UI/UX', colorIndex: 5, isVocational: true),
      PresetSubjectItem(name: 'APS', colorIndex: 1, isVocational: true),
    ],
  ),
  VocationalMajor(
    code: 'DKV',
    name: 'Multimedia / DKV',
    description: 'Desain grafis, animasi 2D/3D, audio video, dan fotografi',
    vocationalSubjects: [
      PresetSubjectItem(name: 'Fotografi', colorIndex: 4, isVocational: true),
      PresetSubjectItem(name: 'Videografi', colorIndex: 0, isVocational: true),
      PresetSubjectItem(name: 'KPD', colorIndex: 1, isVocational: true),
      PresetSubjectItem(name: 'DP', colorIndex: 7, isVocational: true),
      PresetSubjectItem(name: 'Desain Cetak', colorIndex: 2, isVocational: true),
      PresetSubjectItem(name: 'AMG', colorIndex: 3, isVocational: true),
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


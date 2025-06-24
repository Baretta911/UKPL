# Student Status Evaluator

Aplikasi web untuk mengevaluasi status mahasiswa berdasarkan kriteria akademik yang telah ditentukan.

## Fitur Utama

- **Input Data Mahasiswa**: Form untuk memasukkan data lengkap mahasiswa
- **Evaluasi Otomatis**: Sistem evaluasi otomatis berdasarkan kriteria yang telah ditetapkan
- **Feedback Visual**: Indikator lulus/tidak lulus dengan warna dan ikon
- **Detail Kriteria**: Breakdown lengkap setiap kriteria evaluasi

## Kriteria Evaluasi

Mahasiswa dinyatakan **LULUS** jika memenuhi SEMUA kriteria berikut:

1. **Kehadiran**: Minimal 75%
2. **Nilai Tugas**: Minimal 70
3. **Nilai UTS**: Minimal 60
4. **Nilai UAS**: Minimal 60
5. **Sertifikasi**: Harus memiliki sertifikasi
6. **Kelengkapan Administrasi**: Harus lengkap
7. **Nilai Akhir**: Minimal 60 (dihitung dengan bobot: Tugas 30%, UTS 30%, UAS 40%)

## Teknologi yang Digunakan

- **React.js** - Library UI
- **Vite** - Build tool dan development server
- **CSS3** - Styling dengan support untuk dark/light mode
- **JavaScript (ES6+)** - Logika aplikasi

## Cara Menjalankan

### Prerequisites
- Node.js (versi 14 atau lebih baru)
- npm atau yarn

### Instalasi
```bash
# Clone repository
git clone <repository-url>

# Masuk ke direktori project
cd student-status-evaluator

# Install dependencies
npm install

# Jalankan development server
npm run dev
```

### Build untuk Production
```bash
npm run build
```

### Preview Production Build
```bash
npm run preview
```

## Struktur Project

```
student-status-evaluator/
├── src/
│   ├── App.jsx          # Komponen utama aplikasi
│   ├── App.css          # Styling untuk App component
│   ├── index.css        # Global styling
│   └── main.jsx         # Entry point aplikasi
├── public/              # Static assets
├── index.html           # HTML template
├── package.json         # Dependencies dan scripts
├── vite.config.js       # Konfigurasi Vite
└── README.md           # Dokumentasi project
```

## Cara Penggunaan

1. **Masukkan Data Mahasiswa**
   - Isi nama dan NIM mahasiswa
   - Masukkan persentase kehadiran (0-100%)
   - Input nilai tugas, UTS, dan UAS (0-100)
   - Centang checkbox untuk sertifikasi dan kelengkapan administrasi

2. **Evaluasi Status**
   - Klik tombol "Evaluasi Status"
   - Sistem akan menampilkan hasil evaluasi lengkap
   - Status LULUS/TIDAK LULUS akan ditampilkan dengan jelas
   - Detail setiap kriteria akan ditampilkan dengan indikator visual

3. **Reset Data**
   - Gunakan tombol "Reset" untuk membersihkan form
   - Semua input akan dikembalikan ke nilai awal

## Fitur Tambahan

- **Responsive Design**: Tampilan yang optimal di desktop dan mobile
- **Dark/Light Mode**: Otomatis mengikuti preferensi sistem
- **Real-time Calculation**: Nilai akhir dihitung secara otomatis
- **Visual Feedback**: Indikator warna dan ikon untuk setiap kriteria
- **Error Prevention**: Validasi input untuk mencegah kesalahan data

## Kontribusi

1. Fork repository ini
2. Buat branch fitur baru (`git checkout -b fitur-baru`)
3. Commit perubahan (`git commit -am 'Menambah fitur baru'`)
4. Push ke branch (`git push origin fitur-baru`)
5. Buat Pull Request

## Lisensi

Project ini menggunakan lisensi MIT. Lihat file LICENSE untuk detail lengkap.

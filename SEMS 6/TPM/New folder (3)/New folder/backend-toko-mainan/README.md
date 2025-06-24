# Toko Mainan Backend

## Deskripsi

Backend untuk aplikasi mobile Toko Mainan yang dibangun menggunakan Node.js, Express, dan Sequelize (MySQL). Aplikasi ini menyediakan berbagai fitur untuk manajemen mainan, pesanan, saran, dan lokasi toko.

## Fitur

1. **Autentikasi Pengguna**

   - Login dan logout pengguna menggunakan NIM dan password.
   - Menghasilkan token JWT saat login.

2. **Manajemen Mainan**

   - Menampilkan daftar mainan.
   - Melihat detail mainan.
   - Melakukan pemesanan mainan dan mengurangi stok.
   - Pencarian mainan berdasarkan nama.
   - Refresh daftar mainan terbaru.

3. **Manajemen Pesanan**

   - Mengelola pesanan pengguna.

4. **Manajemen Saran dan Kesan**

   - Pengguna dapat mengirim saran dan kesan terkait mata kuliah.

5. **Lokasi Toko**

   - Menyimpan informasi lokasi toko termasuk nama, alamat, dan koordinat.

6. **Konversi**

   - Konversi mata uang dan waktu.

7. **Profil Pengguna**

   - Melihat dan memperbarui profil pengguna.

8. **Notifikasi dan Pencarian**
   - Endpoint untuk pencarian mainan dan notifikasi stok.

## Struktur Folder

```
backend-toko-mainan
├── controllers
├── middleware
├── models
├── config
├── routes.js
└── README.md
```

## Instalasi

1. Clone repositori ini.
2. Install dependensi dengan perintah:
   ```
   npm install
   ```
3. Konfigurasi database pada file `config/config.js`.
4. Jalankan migrasi untuk membuat tabel di database:
   ```
   npx sequelize-cli db:migrate
   ```
5. Jalankan server:
   ```
   npm start
   ```

## Penggunaan API

- **Login**: `POST /api/auth/login`
- **Daftar Mainan**: `GET /api/mainan`
- **Detail Mainan**: `GET /api/mainan/:id`
- **Pesan Mainan**: `POST /api/pesanan`
- **Kirim Saran**: `POST /api/saran`
- **Lokasi Toko**: `GET /api/toko`

## Kontribusi

Silakan ajukan pull request jika Anda ingin berkontribusi pada proyek ini.

# Geoportal Apps Mobile

<p align="center">
  <img src="assets/images/logo/logo-geoportal.png" alt="Geoportal Logo" width="200"/>
</p>

Geoportal adalah aplikasi mobile yang dirancang untuk mempermudah masyarakat dalam mengakses informasi perumahan dan permukiman secara efisien. Aplikasi ini mendukung perencanaan dan pengembangan wilayah di Kota Batam melalui penyediaan data spasial yang terpusat.

Geoportal dikembangkan sebagai bagian dari upaya mendukung program pemerintah di bidang perumahan dan permukiman. Aplikasi ini memanfaatkan peta interaktif berbasis GeoJSON serta dilengkapi dengan fitur pengelolaan data lokasi (CRUD), unggah koordinat, unggah foto, dan pengunduhan data.

## 📱 Fitur Utama

- 🔐 **Login & Register**  
  Pengguna dapat membuat akun dan masuk ke dalam aplikasi.

- 🗺️ **Tampilan Informasi Perumahan dan Permukiman di Peta**  
  Data ditampilkan secara interaktif melalui peta berbasis GeoJSON.

- ✏️ **Input, Ubah dan Hapus Data Umum dan Spasial**  
  Mengelola informasi perumahan dan permukiman, termasuk nama lokasi, jenis kawasan, serta atribut lainnya.

- 📍 **Input, Ubah dan Hapus Koordinat Lokasi**  
  Mengelola titik koordinat lokasi secara langsung dari interaksi peta.

- 📸 **Input, Ubah dan Hapus Foto Lokasi**  
  Mengelola foto lokasi menggunakan galeri perangkat.

- ⬇️ **Unduh Data Lokasi**  
  Pengguna dapat mengunduh data lokasi dalam format terstruktur dalam format PDF.

- 🧭 **Akses dan Navigasi Peta Interaktif**  
  Berbasis Flutter Map, pengguna dapat menelusuri dan memantau persebaran data lokasi secara interaktif.  
  Tersedia dua jenis tampilan peta yang dapat dipilih:
  - 🗺️ **Peta Biasa (OpenStreetMap)**
  - 🛰️ **Peta Satelit (ESRI Satellite)**

## 🖼️ Screenshots Tampilan Aplikasi

## ⚙️ Prasyarat

- ![Flutter](https://img.shields.io/badge/Flutter-3.29.3-02569B?logo=flutter&logoColor=white)
- ![Dart](https://img.shields.io/badge/Dart-3.7.2-0175C2?logo=dart&logoColor=white)
- ![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase&logoColor=black)
- ![Supabase](https://img.shields.io/badge/Supabase-Storage-3FCF8E?logo=supabase&logoColor=white)
- ![VS Code](https://img.shields.io/badge/VS_Code-Recommended-007ACC?logo=visualstudiocode&logoColor=white)

## 🚀 Instalasi

1. Clone repositori

   ```bash
   git clone https://github.com/fadliaditya06/Geoportal-Mobile.git
   cd Geoportal-Mobile
   ```

2. Install dependensi:

   ```bash
   flutter pub get
   ```

3. Setup Firebase:

   - Tambahkan file `google-services.json` ke dalam folder `android/app/`
   - Pastikan fitur berikut aktif di Firebase console:
     - Firebase Authentication
     - Cloud Firestore

4. Setup Supabase:

   - Simpan konfigurasi berikut dari Supabase Project:
     - URL
     - Anon Key
     - Storage Bucket untuk gambar lokasi
   - Pastikan bucket bersifat public atau diatur sesuai kebutuhan aplikasi.

5. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 🛠️ Teknologi dan Dependensi

| Teknologi               | Deskripsi                                                                   |
| ----------------------- | --------------------------------------------------------------------------- |
| **Flutter**             | Framework UI untuk membangun aplikasi mobile                                |
| **Dart**                | Bahasa pemrograman utama yang digunakan oleh Flutter                        |
| **Firebase**            | Backend untuk login, register, dan penyimpanan data di Firestore            |
| **Supabase Storage**    | Cloud storage untuk mengunggah dan mengambil gambar                         |
| **Flutter Map**         | Library berbasis Leaflet untuk menampilkan peta interaktif                  |
| **OpenStreetMap (OSM)** | Peta dasar sumber terbuka yang digunakan untuk navigasi lokasi              |
| **ESRI Satellite**      | Layanan peta satelit untuk visualisasi spasial berbasis citra               |
| **Image Picker**        | Plugin untuk mengambil gambar dari kamera atau galeri perangkat             |
| **latlong2**            | Library untuk menangani data koordinat (latitude & longitude)               |
| **GeoJSON Dataset**     | Format data spasial yang digunakan untuk menampilkan area perumahan di peta |

## 👥 Kontributor

| Nama & NIM                                | Peran                                      |
| ----------------------------------------- | ------------------------------------------ |
| Ir. Farouki Dinda Rassarandi, S.T., M.Eng | Klien dan Manajer Proyek                   |
| 3312301006 – Fadli Aditya Suhairi         | Ketua Tim & Fullstack Mobile Developer     |
| 3312301012 – Faradilla Zahara             | Frontend Mobile Developer & UI/UX Designer |
| 3312301022 – Isma Rapmaria Silitonga      | Frontend Mobile Developer & UI/UX Designer |
| 3312301122 – Ainaya Nurfaddilah           | Frontend Mobile Developer & UI/UX Designer |

<p align="center">
  <img src="assets/images/logo/logo-polibatam.png" alt="Logo Polibatam" width="180" style="margin-right: 50px;" />
  <img src="assets/images/logo/logo-prodi-if.png" alt="Logo Prodi IF" width="180" style="margin-bottom: 100px;"/>
</p>

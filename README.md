# Flutter Firebase Authentication

**Nama:** Muhamad Miftahul Ulum  
**NIM:** 1124160131  
**Kelas:** TI 24 P SE2

## Deskripsi Proyek

Proyek ini merupakan aplikasi autentikasi pengguna berbasis Flutter yang terintegrasi dengan Firebase Authentication. Aplikasi ini diimplementasikan untuk menerapkan proses pengelolaan akses pengguna, mulai dari registrasi akun menggunakan nama, email, dan password, login, menampilkan informasi pengguna yang sedang masuk, hingga logout. Firebase digunakan untuk mengelola autentikasi pengguna, sedangkan Postman dimanfaatkan sebagai alat bantu untuk menguji API melalui HTTP request dan memeriksa respons yang diterima. Selama pengembangan, kode aplikasi juga disusun ulang dari satu file `main.dart` menjadi beberapa folder agar lebih terstruktur dan mudah dikembangkan.

## Teknologi yang Digunakan

- **Flutter:** Membangun antarmuka aplikasi.
- **Dart:** Bahasa pemrograman aplikasi.
- **Firebase Core:** Menghubungkan aplikasi dengan Firebase.
- **Firebase Authentication:** Mengelola registrasi dan login pengguna.
- **Postman:** Mengirim dan menguji HTTP request serta memeriksa respons API.

## Fitur Aplikasi

1. Registrasi akun pengguna.
2. Login menggunakan email dan password.
3. Menampilkan informasi pengguna.
4. Menampilkan nama pengguna secara dinamis.
5. Logout dari aplikasi.
6. Memeriksa status autentikasi secara otomatis.

## Implementasi Postman

Postman digunakan sebagai alat bantu pengujian API untuk mengirim HTTP request dan melihat respons dari layanan yang diuji. Pengujian ini membantu memahami komunikasi antara aplikasi dan layanan backend, termasuk respons yang diterima ketika suatu request dijalankan.

## Struktur Folder

```text
lib/
├── main.dart
├── firebase_options.dart
├── login/
│   └── login_screen.dart
├── register/
│   └── register_screen.dart
└── informasi_pengguna/
    └── user_info_screen.dart
```

## Cara Menjalankan Proyek

Clone repository:

```bash
git clone https://github.com/mfthluum/flutter-firebase-authentication.git
```

Masuk ke folder proyek:

```bash
cd flutter-firebase-authentication
```

Install dependencies:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run -d chrome
```

## Developer

Muhamad Miftahul Ulum

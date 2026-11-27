
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_firebase/fcm_token_card.dart';

class UserInfoScreen extends StatelessWidget {
  final User user;

  const UserInfoScreen({
    super.key,
    required this.user,
  });

  // Fungsi logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Mengubah tanggal menjadi format yang mudah dibaca
  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Tidak tersedia';
    }

    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Pengguna'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 110,
              color: Colors.blue,
            ),

            const SizedBox(height: 16),

            const Text(
              'Login Berhasil!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Selamat datang di aplikasi Firebase',
            ),

            const SizedBox(height: 30),

            // Informasi nama pengguna
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Nama Lengkap'),
                subtitle: Text(
                  user.displayName ?? 'Nama belum tersedia',
                ),
              ),
            ),

            // Informasi email
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(
                  user.email ?? 'Email tidak tersedia',
                ),
              ),
            ),

            // Informasi UID
            Card(
              child: ListTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text('User ID (UID)'),
                subtitle: SelectableText(user.uid),
              ),
            ),

            // Tanggal pembuatan akun
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Tanggal Pendaftaran'),
                subtitle: Text(
                  _formatDate(user.metadata.creationTime),
                ),
              ),
            ),

            // Terakhir login
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Terakhir Login'),
                subtitle: Text(
                  _formatDate(user.metadata.lastSignInTime),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // FCM Token untuk Push Notification
            const FcmTokenCard(),

            const SizedBox(height: 24),

            // Tombol logout
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('LOGOUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

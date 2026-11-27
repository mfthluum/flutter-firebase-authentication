
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FcmTokenCard extends StatelessWidget {
  const FcmTokenCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: FirebaseMessaging.instance.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Gagal mengambil FCM Token'),
            ),
          );
        }

        final token = snapshot.data ?? '';

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FCM Token:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                SelectableText(
                  token.isEmpty
                      ? 'Token tidak tersedia'
                      : token,
                  style: const TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 8),

                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Salin Token'),
                  onPressed: token.isEmpty
                      ? null
                      : () async {
                          await Clipboard.setData(
                            ClipboardData(text: token),
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Token disalin!'),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

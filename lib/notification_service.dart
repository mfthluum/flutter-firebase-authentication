import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:login_firebase/firebase_options.dart';
import 'package:login_firebase/notification_detail_screen.dart';

/// Navigator global untuk navigasi dari notifikasi.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// HANDLER BACKGROUND / TERMINATED
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('[FCM] Pesan BACKGROUND: ${message.messageId}');
  debugPrint('[FCM] Data: ${message.data}');
}

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  /// Channel notifikasi Android.
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notifikasi Penting',
    description: 'Channel untuk notifikasi Firebase',
    importance: Importance.max,
  );

  /// Inisialisasi seluruh layanan notifikasi.
  static Future<void> init() async {
    // 1. Meminta izin notifikasi.
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('[FCM] Status izin: ${settings.authorizationStatus}');

    // 2. Inisialisasi local notifications.
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _localNotif.initialize(
      settings: const InitializationSettings(
        android: androidInit,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data =
                jsonDecode(response.payload!) as Map<String, dynamic>;
            _openDetail(data);
          } catch (e) {
            debugPrint('[FCM] Payload lokal tidak valid: $e');
          }
        }
      },
    );

    // Membuat channel Android.
    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // 3. Mengambil FCM Token.
    try {
      // ignore: deprecated_member_use
      final token = await _messaging.getToken();
      debugPrint('[FCM] TOKEN: $token');
    } catch (e) {
      debugPrint('[FCM] Gagal mengambil token: $e');
    }

    // Memantau perubahan token.
    // ignore: deprecated_member_use
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('[FCM] TOKEN BARU: $newToken');
    });

    // 4. Subscribe ke topic kelas.
    await _messaging.subscribeToTopic('kelas');
    debugPrint('[FCM] Berhasil subscribe topic kelas');

    // 5. FOREGROUND.
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // 6. BACKGROUND -> Notifikasi diklik.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[FCM] Dibuka dari BACKGROUND');
      _openDetail(_messageToMap(message));
    });

    // 7. TERMINATED -> Aplikasi dibuka melalui notifikasi.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[FCM] Dibuka dari TERMINATED');
      _openDetail(_messageToMap(initialMessage));
    }

    // 8. Aplikasi dibuka dari notifikasi lokal saat app tertutup.
    final launchDetails = await _localNotif.getNotificationAppLaunchDetails();
    final payload = launchDetails?.notificationResponse?.payload;
    if ((launchDetails?.didNotificationLaunchApp ?? false) && payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        _openDetail(data);
      } catch (e) {
        debugPrint('[FCM] Gagal membaca payload: $e');
      }
    }
  }

  /// Menampilkan notifikasi langsung dari aplikasi (misalnya saat login berhasil).
  static Future<void> showWelcomeNotification({
    required String title,
    required String body,
    Map<String, dynamic> data = const {},
  }) async {
    final payloadData = <String, dynamic>{
      'title': title,
      'body': body,
      ...data,
    };

    await _localNotif.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(payloadData),
    );
  }

  /// Menampilkan notifikasi ketika aplikasi sedang terbuka (FOREGROUND).
  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    debugPrint('[FCM] Pesan FOREGROUND');

    final notification = message.notification;
    if (notification == null) return;

    await _localNotif.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(_messageToMap(message)),
    );
  }

  /// Menggabungkan title, body, dan data payload.
  static Map<String, dynamic> _messageToMap(RemoteMessage message) {
    return {
      'title': message.notification?.title ?? '-',
      'body': message.notification?.body ?? '-',
      ...message.data,
    };
  }

  /// Membuka halaman detail notifikasi.
  static void _openDetail(Map<String, dynamic> data) {
    void push() {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => NotificationDetailScreen(data: data),
        ),
      );
    }

    if (navigatorKey.currentState != null) {
      push();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => push());
    }
  }
}
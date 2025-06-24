import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }

  // Show instant notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'toy_store_channel',
      'Toy Store Notifications',
      channelDescription: 'Notifications for toy store app',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Schedule notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'toy_store_scheduled',
      'Scheduled Notifications',
      channelDescription: 'Scheduled notifications for toy store app',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Notification for new products
  static Future<void> notifyNewProduct(String productName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: '🧸 New Toy Available!',
      body: 'Check out the new $productName in our store!',
      payload: 'new_product',
    );
  }

  // Notification for discounts
  static Future<void> notifyDiscount(String storeName, int discountPercent) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: '🎉 Special Discount!',
      body: 'Get $discountPercent% off at $storeName branch!',
      payload: 'discount',
    );
  }

  // Notification for wishlist suggestions
  static Future<void> notifyWishlistSuggestion(String productName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: '💝 From Your Wishlist',
      body: '$productName is now available for purchase!',
      payload: 'wishlist',
    );
  }

  // Daily reminder notification
  static Future<void> scheduleDailyReminder() async {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day + 1,
      10, // 10 AM
      0,
    );

    await scheduleNotification(
      id: 999,
      title: '🎪 Toy Store Daily',
      body: 'Discover amazing toys for kids today!',
      scheduledTime: scheduledTime,
      payload: 'daily_reminder',
    );
  }

  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Location-based store notifications
  static Future<void> notifyStoreProximity(String storeName, String location) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: '📍 Store Nearby',
      body: 'You\'re near our $storeName store in $location!',
      payload: 'store_proximity',
    );
  }

  // Order status notifications
  static Future<void> notifyOrderStatus(String orderId, String status) async {
    String title;
    String body;
    
    switch (status.toLowerCase()) {
      case 'confirmed':
        title = '✅ Order Confirmed';
        body = 'Your order #$orderId has been confirmed!';
        break;
      case 'shipped':
        title = '🚚 Order Shipped';
        body = 'Your order #$orderId is on the way!';
        break;
      case 'delivered':
        title = '📦 Order Delivered';
        body = 'Your order #$orderId has been delivered!';
        break;
      default:
        title = '📋 Order Update';
        body = 'Order #$orderId status: $status';
    }

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      payload: 'order_$orderId',
    );
  }
}

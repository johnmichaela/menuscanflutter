// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class NotificationService {
//   static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();
  
//   static String? _deviceToken;
//   static List<NotificationData> _notifications = [];
//   static int _unreadCount = 0;

//   // ==================== INITIALIZATION ====================
  
//   static Future<void> initialize() async {
//     // Request permissions
//     NotificationSettings settings = await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('✅ User granted permission');
//     } else {
//       print('❌ User declined permission');
//     }

//     // Get device token
//     _deviceToken = await _fcm.getToken();
//     print('📱 Device Token: $_deviceToken');
    
//     // Save token to server
//     if (_deviceToken != null) {
//       await _saveTokenToServer(_deviceToken!);
//     }

//     // Initialize local notifications
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings();
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
    
//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );

//     // Listen to messages
//     FirebaseMessaging.onMessage.listen(_onMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    
//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
//     // Load cached notifications
//     await _loadCachedNotifications();
//   }

//   // ==================== BACKGROUND HANDLER ====================
  
//   @pragma('vm:entry-point')
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     print('📨 Handling background message: ${message.messageId}');
//     // Handle background message
//     await _saveNotificationToCache(message);
//   }

//   // ==================== SAVE TOKEN TO SERVER ====================
  
//   static Future<void> _saveTokenToServer(String token) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? userId = prefs.getString('profid');
      
//       if (userId == null) return;
      
//       final response = await http.post(
//         Uri.parse('http://192.168.1.115:8000 /api/save-fcm-token/'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'user_id': userId,
//           'fcm_token': token,
//         }),
//       );
      
//       if (response.statusCode == 200) {
//         print('✅ FCM token saved to server');
//       }
//     } catch (e) {
//       print('❌ Failed to save token: $e');
//     }
//   }

//   // ==================== HANDLE FOREGROUND MESSAGE ====================
  
//   static Future<void> _onMessage(RemoteMessage message) async {
//     print('📨 Received foreground message: ${message.notification?.title}');
    
//     // Show notification
//     await _showNotification(message);
    
//     // Save to cache
//     await _saveNotificationToCache(message);
    
//     // Update notification list
//     _addNotification(message);
//   }

//   // ==================== HANDLE MESSAGE OPEN ====================
  
//   static Future<void> _onMessageOpenedApp(RemoteMessage message) async {
//     print('📨 User tapped notification: ${message.notification?.title}');
//     // Navigate to specific page based on data
//     _handleNavigation(message.data);
//   }

//   // ==================== HANDLE LOCAL NOTIFICATION TAP ====================
  
//   static Future<void> _onNotificationTap(NotificationResponse response) async {
//     print('📨 Local notification tapped: ${response.payload}');
//     if (response.payload != null) {
//       final data = json.decode(response.payload!);
//       _handleNavigation(data);
//     }
//   }

//   // ==================== SHOW NOTIFICATION ====================
  
//   static Future<void> _showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'balloon_channel',
//       'Balloon Notifications',
//       channelDescription: 'Notifications from Balloon app',
//       importance: Importance.max,
//       priority: Priority.high,
//       icon: '@mipmap/ic_launcher',
//     );

//     const DarwinNotificationDetails iosDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     final payload = json.encode(message.data);
    
//     await _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       message.notification?.title ?? 'New Notification',
//       message.notification?.body ?? 'You have a new notification',
//       details,
//       payload: payload,
//     );
//   }

//   // ==================== SAVE NOTIFICATION TO CACHE ====================
  
//   static Future<void> _saveNotificationToCache(RemoteMessage message) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final List<String>? cached = prefs.getStringList('notifications');
//       List<String> notifications = cached ?? [];
      
//       final notificationData = {
//         'id': message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
//         'title': message.notification?.title ?? 'New Notification',
//         'body': message.notification?.body ?? '',
//         'data': message.data,
//         'timestamp': DateTime.now().toIso8601String(),
//         'read': false,
//       };
      
//       notifications.insert(0, json.encode(notificationData));
      
//       // Keep only last 100 notifications
//       if (notifications.length > 100) {
//         notifications = notifications.sublist(0, 100);
//       }
      
//       await prefs.setStringList('notifications', notifications);
      
//       // Update unread count
//       await _updateUnreadCount();
      
//     } catch (e) {
//       print('❌ Failed to save notification: $e');
//     }
//   }

//   // ==================== LOAD CACHED NOTIFICATIONS ====================
  
//   static Future<void> _loadCachedNotifications() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final List<String>? cached = prefs.getStringList('notifications');
      
//       if (cached != null) {
//         _notifications = cached.map((item) {
//           final data = json.decode(item);
//           return NotificationData.fromJson(data);
//         }).toList();
        
//         _unreadCount = _notifications.where((n) => !n.read).length;
//       }
//     } catch (e) {
//       print('❌ Failed to load cached notifications: $e');
//     }
//   }

//   // ==================== ADD NOTIFICATION ====================
  
//   static void _addNotification(RemoteMessage message) {
//     final notification = NotificationData(
//       id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       title: message.notification?.title ?? 'New Notification',
//       body: message.notification?.body ?? '',
//       data: message.data,
//       timestamp: DateTime.now(),
//       read: false,
//     );
    
//     _notifications.insert(0, notification);
//     _unreadCount++;
//   }

//   // ==================== UPDATE UNREAD COUNT ====================
  
//   static Future<void> _updateUnreadCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String>? cached = prefs.getStringList('notifications');
    
//     if (cached != null) {
//       _unreadCount = cached.where((item) {
//         final data = json.decode(item);
//         return data['read'] == false;
//       }).length;
//     }
//   }

//   // ==================== GET NOTIFICATIONS ====================
  
//   static List<NotificationData> getNotifications() {
//     return _notifications;
//   }

//   // ==================== GET UNREAD COUNT ====================
  
//   static int getUnreadCount() {
//     return _unreadCount;
//   }

//   // ==================== MARK AS READ ====================
  
//   static Future<void> markAsRead(String id) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final List<String>? cached = prefs.getStringList('notifications');
      
//       if (cached != null) {
//         final updated = cached.map((item) {
//           final data = json.decode(item);
//           if (data['id'] == id) {
//             data['read'] = true;
//           }
//           return json.encode(data);
//         }).toList();
        
//         await prefs.setStringList('notifications', updated);
        
//         // Update local list
//         final index = _notifications.indexWhere((n) => n.id == id);
//         if (index != -1) {
//           _notifications[index].read = true;
//           _unreadCount = _notifications.where((n) => !n.read).length;
//         }
//       }
//     } catch (e) {
//       print('❌ Failed to mark as read: $e');
//     }
//   }

//   // ==================== MARK ALL AS READ ====================
  
//   static Future<void> markAllAsRead() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final List<String>? cached = prefs.getStringList('notifications');
      
//       if (cached != null) {
//         final updated = cached.map((item) {
//           final data = json.decode(item);
//           data['read'] = true;
//           return json.encode(data);
//         }).toList();
        
//         await prefs.setStringList('notifications', updated);
        
//         // Update local list
//         for (var notification in _notifications) {
//           notification.read = true;
//         }
//         _unreadCount = 0;
//       }
//     } catch (e) {
//       print('❌ Failed to mark all as read: $e');
//     }
//   }

//   // ==================== DELETE NOTIFICATION ====================
  
//   static Future<void> deleteNotification(String id) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final List<String>? cached = prefs.getStringList('notifications');
      
//       if (cached != null) {
//         final updated = cached.where((item) {
//           final data = json.decode(item);
//           return data['id'] != id;
//         }).toList();
        
//         await prefs.setStringList('notifications', updated);
        
//         // Update local list
//         _notifications.removeWhere((n) => n.id == id);
//         _unreadCount = _notifications.where((n) => !n.read).length;
//       }
//     } catch (e) {
//       print('❌ Failed to delete notification: $e');
//     }
//   }

//   // ==================== CLEAR ALL NOTIFICATIONS ====================
  
//   static Future<void> clearAll() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('notifications');
      
//       _notifications.clear();
//       _unreadCount = 0;
//     } catch (e) {
//       print('❌ Failed to clear notifications: $e');
//     }
//   }

//   // ==================== HANDLE NAVIGATION ====================
  
//   static void _handleNavigation(Map<String, dynamic> data) {
//     // Navigate based on notification data
//     // Example: if data contains 'screen' -> navigate to that screen
//     // You can implement this based on your app's navigation
//   }
// }

// // ==================== NOTIFICATION DATA MODEL ====================

// class NotificationData {
//   final String id;
//   final String title;
//   final String body;
//   final Map<String, dynamic> data;
//   final DateTime timestamp;
//   bool read;

//   NotificationData({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.data,
//     required this.timestamp,
//     this.read = false,
//   });

//   factory NotificationData.fromJson(Map<String, dynamic> json) {
//     return NotificationData(
//       id: json['id'] ?? '',
//       title: json['title'] ?? '',
//       body: json['body'] ?? '',
//       data: json['data'] ?? {},
//       timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
//       read: json['read'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'body': body,
//       'data': data,
//       'timestamp': timestamp.toIso8601String(),
//       'read': read,
//     };
//   }
// }
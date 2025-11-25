// // notification_provider.dart
// import 'dart:developer';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' show ScaffoldMessenger, SnackBar;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:go_router/go_router.dart';
// import 'package:rider_pay_driver/core/utils/routes/routes.dart';
// import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
// import 'notification_service.dart';
//
// // final notificationProvider =
// // StateNotifierProvider<NotificationNotifier, RemoteMessage?>(
// //         (ref) => NotificationNotifier());
// //
// // class NotificationNotifier extends StateNotifier<RemoteMessage?> {
// //   NotificationNotifier() : super(null) {
// //     _init();
// //   }
// //
// //   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
// //
// //   Future<void> _init() async {
// //     try {
// //       await initLocalNotifications();
// //       NotificationSettings settings = await _messaging.requestPermission(
// //         alert: true,
// //         badge: true,
// //         sound: true,
// //       );
// //
// //       log('📱 Notification permission: ${settings.authorizationStatus}');
// //
// //       // Get FCM token
// //       String? token = await _messaging.getToken();
// //       log('🔥 FCM Token: $token');
// //
// //       // Foreground messages
// //       FirebaseMessaging.onMessage.listen((message) {
// //         log('📩 Foreground message: ${message.messageId}');
// //         log('📩 Message data: ${message.data}');
// //         if (navigatorKey.currentContext != null) {
// //           ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
// //             SnackBar(
// //               content: Text(message.notification?.body ?? 'New notification'),
// //               duration: Duration(seconds: 2),
// //             ),
// //           );
// //         }
// //         _showLocalNotification(message);
// //
// //         state = message;
// //       });
// //
// //       // When user taps notification (app in background)
// //       FirebaseMessaging.onMessageOpenedApp.listen((message) {
// //         log('📌 Notification tapped: ${message.messageId}');
// //         _handleNotificationTap(message);
// //         state = message;
// //       });
// //
// //       RemoteMessage? initialMessage = await _messaging.getInitialMessage();
// //       if (initialMessage != null) {
// //         log('📌 Initial message: ${initialMessage.messageId}');
// //         _handleNotificationTap(initialMessage);
// //         state = initialMessage;
// //       }
// //
// //     } catch (e) {
// //       log('❌ Notification initialization error: $e');
// //     }
// //   }
// //
// //   // void _showLocalNotification(RemoteMessage message) async {
// //   //   try {
// //   //     final notification = message.notification;
// //   //     if (notification == null) return;
// //   //     final android = message.notification?.android;
// //   //
// //   //       AndroidNotificationDetails androidPlatformChannelSpecifics =
// //   //       AndroidNotificationDetails(
// //   //         'app_channel', // channelId
// //   //         'App Notifications', // channelName
// //   //         channelDescription: 'General Notifications',
// //   //         importance: Importance.max,
// //   //         priority: Priority.high,
// //   //         showWhen: true,
// //   //         styleInformation: BigTextStyleInformation(notification.body ?? ''),
// //   //       );
// //   //     final iosDetails = DarwinNotificationDetails(
// //   //       presentAlert: true,
// //   //       presentBadge: true,
// //   //       presentSound: true,
// //   //     );
// //   //
// //   //       DarwinNotificationDetails iosPlatformChannelSpecifics =
// //   //       const DarwinNotificationDetails();
// //   //
// //   //       NotificationDetails platformChannelSpecifics = NotificationDetails(
// //   //         android: androidPlatformChannelSpecifics,
// //   //         iOS: iosPlatformChannelSpecifics,
// //   //       );
// //   //
// //   //       await flutterLocalNotificationsPlugin.show(
// //   //         message.hashCode,
// //   //         notification.title ?? 'New Notification',
// //   //         notification.body,
// //   //         platformChannelSpecifics,
// //   //         payload: message.data.toString(),
// //   //       );
// //   //
// //   //       log('📲 Local notification shown');
// //   //   } catch (e) {
// //   //     log('❌ Local notification error: $e');
// //   //   }
// //   // }
// //   Future<void> _showLocalNotification(RemoteMessage message) async {
// //     final notification = message.notification;
// //     if (notification == null) return;
// //
// //     final androidDetails = AndroidNotificationDetails(
// //       'app_channel',
// //       'App Notifications',
// //       channelDescription: 'General notifications',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       styleInformation: BigTextStyleInformation(notification.body ?? ''),
// //     );
// //
// //     final iosDetails = DarwinNotificationDetails(
// //       presentAlert: true,
// //       presentBadge: true,
// //       presentSound: true,
// //     );
// //
// //     final details = NotificationDetails(android: androidDetails, iOS: iosDetails);
// //
// //     await flutterLocalNotificationsPlugin.show(
// //       message.hashCode,
// //       notification.title ?? 'New Notification',
// //       notification.body,
// //       details,
// //       payload: message.data.toString(),
// //     );
// //   }
// //
// //   void _handleNotificationTap(RemoteMessage message) {
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (navigatorKey.currentContext != null) {
// //         final data = message.data;
// //
// //         final router = GoRouter.of(navigatorKey.currentContext!);
// //
// //         if (data['type'] == 'payment') {
// //           router.pushNamed(RoutesName.notificationScreen);
// //         } else if (data['type'] == 'ride') {
// //           // router.pushNamed(RoutesName.rideDetails);
// //         } else {
// //           // router.pushNamed(RoutesName.notification);
// //         }
// //
// //         log('📍 Navigated from notification: ${data['type']}');
// //       }
// //     });
// //   }
// //   // Get FCM token
// //   Future<String?> getFCMToken() async {
// //     try {
// //       return await _messaging.getToken();
// //     } catch (e) {
// //       log('❌ Error getting FCM token: $e');
// //       return null;
// //     }
// //   }
// //
// //   // Subscribe to topic
// //   Future<void> subscribeToTopic(String topic) async {
// //     try {
// //       await _messaging.subscribeToTopic(topic);
// //       log('✅ Subscribed to topic: $topic');
// //     } catch (e) {
// //       log('❌ Error subscribing to topic: $e');
// //     }
// //   }
// //
// //   // Unsubscribe from topic
// //   Future<void> unsubscribeFromTopic(String topic) async {
// //     try {
// //       await _messaging.unsubscribeFromTopic(topic);
// //       log('✅ Unsubscribed from topic: $topic');
// //     } catch (e) {
// //       log('❌ Error unsubscribing from topic: $e');
// //     }
// //   }
// // }
//
// final notificationProvider =
// StateNotifierProvider<NotificationNotifier, RemoteMessage?>(
//         (ref) => NotificationNotifier());
//
// class NotificationNotifier extends StateNotifier<RemoteMessage?> {
//   NotificationNotifier() : super(null) {
//     _init();
//   }
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   Future<void> _init() async {
//     try {
//       await initLocalNotifications();
//       NotificationSettings settings = await _messaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//
//       log('📱 Notification permission: ${settings.authorizationStatus}');
//
//       String? token = await _messaging.getToken();
//       log('🔥 FCM Token: $token');
//
//       FirebaseMessaging.onMessage.listen((message) {
//         log('📩 Foreground message: ${message.messageId}');
//         log('📩 Message data: ${message.data}');
//         _showLocalNotification(message);
//
//         state = message;
//       });
//
//       // When user taps notification (app in background)
//       FirebaseMessaging.onMessageOpenedApp.listen((message) {
//         log('📌 Notification tapped: ${message.messageId}');
//         _handleNotificationTap(message);
//         state = message;
//       });
//
//       RemoteMessage? initialMessage = await _messaging.getInitialMessage();
//       if (initialMessage != null) {
//         log('📌 Initial message: ${initialMessage.messageId}');
//         _handleNotificationTap(initialMessage);
//         state = initialMessage;
//       }
//
//     } catch (e) {
//       log('❌ Notification initialization error: $e');
//     }
//   }
//
//   // void _showLocalNotification(RemoteMessage message) async {
//   //   try {
//   //     final notification = message.notification;
//   //     if (notification == null) return;
//   //     final android = message.notification?.android;
//   //
//   //       AndroidNotificationDetails androidPlatformChannelSpecifics =
//   //       AndroidNotificationDetails(
//   //         'app_channel', // channelId
//   //         'App Notifications', // channelName
//   //         channelDescription: 'General Notifications',
//   //         importance: Importance.max,
//   //         priority: Priority.high,
//   //         showWhen: true,
//   //         styleInformation: BigTextStyleInformation(notification.body ?? ''),
//   //       );
//   //     final iosDetails = DarwinNotificationDetails(
//   //       presentAlert: true,
//   //       presentBadge: true,
//   //       presentSound: true,
//   //     );
//   //
//   //       DarwinNotificationDetails iosPlatformChannelSpecifics =
//   //       const DarwinNotificationDetails();
//   //
//   //       NotificationDetails platformChannelSpecifics = NotificationDetails(
//   //         android: androidPlatformChannelSpecifics,
//   //         iOS: iosPlatformChannelSpecifics,
//   //       );
//   //
//   //       await flutterLocalNotificationsPlugin.show(
//   //         message.hashCode,
//   //         notification.title ?? 'New Notification',
//   //         notification.body,
//   //         platformChannelSpecifics,
//   //         payload: message.data.toString(),
//   //       );
//   //
//   //       log('📲 Local notification shown');
//   //   } catch (e) {
//   //     log('❌ Local notification error: $e');
//   //   }
//   // }
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     final notification = message.notification;
//     if (notification == null) return;
//     final data = message.data;
//
//     final title = notification.title ?? data['title'] ?? 'New Notification';
//     final body = notification.body ?? data['body'] ?? '';
//     final androidDetails = AndroidNotificationDetails(
//       'app_channel',
//       'App Notifications',
//       channelDescription: 'General notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       styleInformation: BigTextStyleInformation(notification.body ?? ''),
//     );
//
//     final iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     final details = NotificationDetails(android: androidDetails, iOS: iosDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       title,
//       body,
//       details,
//       payload: message.data.toString(),
//     );
//   }
//   void _handleNotificationTap(RemoteMessage message) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (navigatorKey.currentContext != null) {
//         final data = message.data;
//         final router = GoRouter.of(navigatorKey.currentContext!);
//
//         if (data['type'] == 'payment') {
//           router.pushNamed(RoutesName.notificationScreen);
//         } else if (data['type'] == 'ride') {
//           // router.pushNamed(RoutesName.rideDetails);
//         } else if(data['type'] == 'service_account'){
//           router.pushNamed(RoutesName.mapScreen);
//         }
//
//         log('📍 Navigated from notification: ${data['type']}');
//       }
//     });
//   }
//   // void _handleNotificationTap(RemoteMessage message) {
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     if (navigatorKey.currentContext != null) {
//   //       final data = message.data;
//   //
//   //       if (data['type'] == 'payment') {
//   //         navigatorKey.currentState?.pushNamed(RouteName.notification);
//   //       } else if (data['type'] == 'ride') {
//   //         navigatorKey.currentState?.pushNamed(RouteName.rideDetails);
//   //       } else if(data['type'] == 'service_account'){
//   //         navigatorKey.currentState?.pushNamed(RouteName.notification);
//   //       }
//   //
//   //       log('📍 Navigated from notification: ${data['type']}');
//   //     }
//   //   });
//   // }
//
//   // Get FCM token
//   Future<String?> getFCMToken() async {
//     try {
//       return await _messaging.getToken();
//     } catch (e) {
//       log('❌ Error getting FCM token: $e');
//       return null;
//     }
//   }
//
//   // Subscribe to topic
//   Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _messaging.subscribeToTopic(topic);
//       log('✅ Subscribed to topic: $topic');
//     } catch (e) {
//       log('❌ Error subscribing to topic: $e');
//     }
//   }
//
//   // Unsubscribe from topic
//   Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _messaging.unsubscribeFromTopic(topic);
//       log('✅ Unsubscribed from topic: $topic');
//     } catch (e) {
//       log('❌ Error unsubscribing from topic: $e');
//     }
//   }
// }
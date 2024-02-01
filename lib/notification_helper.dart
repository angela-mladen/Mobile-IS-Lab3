// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationHelper {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   NotificationHelper() {
//     _initializeNotifications();
//   }

//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: null,
//       macOS: null,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       //'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   // You can add more methods for scheduling and canceling notifications if needed
// }

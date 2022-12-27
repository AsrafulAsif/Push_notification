import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pushnotification/home_page.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  log('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
      log(message.notification!.title.toString());
        //local notification inistialization
  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true);
  InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);
  bool? initialized =
      await notificationsPlugin.initialize(initializationSettings);
  log("Notification:$initialized");

    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
        "notification-youtube", "youtube notification",
        priority: Priority.max, importance: Importance.max);
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
          NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await notificationsPlugin.show(
        0, message.notification?.title.toString(), message.notification?.body.toString(), notiDetails);
    }
  });
  FirebaseMessaging.instance.getToken().then((value) {
    log("Get token:$value");
  });


  
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../message_board/bloc/message_board_bloc.dart';
import '../message_board/message_board_layout.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // print('Title: ${message.notification?.title}');
  // print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  if (message.notification == null) {
    var prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    print('Need to handle when there is no remoteNotification');
    final List<String>? items = prefs.getStringList('messi');
    var json = jsonEncode(message.toMap());
    if (items == null) {
      prefs.setStringList('messi', [json]);
    } else {
      var update = [...items, json];
      prefs.setStringList('messi', update);
    }
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    var currentContext = ContextService.navigatorKey.currentContext!;
    BlocProvider.of<MessageBoardCubit>(currentContext).addMessage(message);
    ContextService.navigatorKey.currentState?.pushNamed(
      MessageBoardLayout.route,
      //   arguments: message,
    );
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    // const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const android = AndroidInitializationSettings('ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(settings, onDidReceiveNotificationResponse: (nr) {
      final message = RemoteMessage.fromMap(jsonDecode(nr.payload!));
      handleMessage(message);
    });
    final platform =
        _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      if (ContextService.lifecycleState != AppLifecycleState.resumed) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          )),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('TOKEN: $fcmToken');
    initPushNotifications();
    initLocalNotifications();
  }
}

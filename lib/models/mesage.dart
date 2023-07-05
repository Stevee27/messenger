import 'package:firebase_messaging/firebase_messaging.dart';

class Message {
  final String name;
  final Map data;
  final RemoteNotification? notification;
  final String? payload;

  Message({
    required this.name,
    required this.data,
    this.notification,
    this.payload,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'payload': payload,
    };
  }

  factory Message.fromMap(map) {
    return parseMessage(map);
  }

  factory Message.empty() {
    return Message(
      name: '',
      data: {},
    );
  }
}

Message parseMessage(map) {
  switch (map['name']) {
    default:
      throw Exception('Unknown Message Name');
  }
}

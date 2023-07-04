import 'mesage.dart';

class Envelope {
  String username;
  List<String> distribution;
  Message message;

  Envelope({
    required this.username,
    required this.distribution,
    required this.message,
  });

  Map toMap() {
    return {
      'username': username,
      'distribution': distribution,
      'message': message.toMap(),
    };
  }

  factory Envelope.fromMap(map) {
    return Envelope(
      username: map['username'],
      distribution: map['distribution'],
      message: Message.fromMap(map['message']),
    );
  }
}

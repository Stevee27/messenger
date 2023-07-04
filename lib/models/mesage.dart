class Message {
  final String name;
  final dynamic payload;
  Message({
    required this.name,
    required this.payload,
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
      payload: '',
    );
  }
}

Message parseMessage(map) {
  switch (map['name']) {
    default:
      throw Exception('Unknown Message Name');
  }
}

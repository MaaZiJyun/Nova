class MessageModel {
  final String from;
  final String to;
  final DateTime timestamp;
  final String content;
  String? _id;

  String? get id => _id;

  MessageModel({
    required this.from,
    required this.to,
    required this.timestamp,
    required this.content,
  });

  toJson() => {
        "from": from,
        "to": to,
        "timestamp": timestamp,
        "content": content,
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final messageModel = MessageModel(
      from: json['from'],
      to: json['to'],
      timestamp: json['timestamp'],
      content: json['content'],
    );
    messageModel._id = json['id'];
    return messageModel;
  }
}

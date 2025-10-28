class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timeStamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timeStamp,
    required this.isRead,
  });
}

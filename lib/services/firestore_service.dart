import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/models/message.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // send message to firestore
  Future<void> sendMessage(Message msg) async {
    await _db.collection('messages').doc(msg.id).set({
      'id': msg.id,
      'senderId': msg.senderId,
      'receiverId': msg.receiverId,
      'text': msg.text,
      'timeStamp': msg.timeStamp,
      'isRead': msg.isRead,
      'participants': [msg.senderId, msg.receiverId],
    });
  }

  // Stream messages between current user & other user
  Stream<List<Message>> getMessages(String me, String other) {
    return _db
        .collection('messages')
        .where('participants', arrayContains: me)
        .orderBy('timeStamp')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data();

                // Filter only messages between the two users
                if ((data['senderId'] == me && data['receiverId'] == other) ||
                    (data['senderId'] == other && data['receiverId'] == me)) {
                  return Message(
                    id: data['id'],
                    senderId: data['senderId'],
                    receiverId: data['receiverId'],
                    text: data['text'],
                    timeStamp: (data['timeStamp'] as Timestamp).toDate(),
                    isRead: data['isRead'],
                  );
                }
                return null;
              })
              .whereType<Message>()
              .toList();
        });
  }

  // Delete message
  Future<void> deleteMessage(String id) async {
    await _db.collection('messages').doc(id).delete();
  }
}

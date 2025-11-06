import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/models/message.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Send a new message to Firestore
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

  // Stream messages between two users (real-time)
  Stream<List<Message>> getMessages(String me, String other) {
    return _db
        .collection('messages')
        // Fetch messages where either user is a participant
        .where('participants', arrayContainsAny: [me, other])
        .orderBy('timeStamp')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data();

                // Only include messages exchanged between these two users
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
              .whereType<Message>() // removes nulls
              .toList();
        });
  }

  // Delete a message
  Future<void> deleteMessage(String id) async {
    await _db.collection('messages').doc(id).delete();
  }

  // Optional: Mark message as read
  Future<void> markAsRead(String id) async {
    await _db.collection('messages').doc(id).update({'isRead': true});
  }

  // 🔹 Fetch all users fresh from the Firestore server (ignore cache)
  Future<List<Map<String, dynamic>>> getAllUsersFromServer() async {
    final querySnapshot = await _db
        .collection('users')
        .get(const GetOptions(source: Source.server));

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}

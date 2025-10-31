// import 'package:messenger_app/models/message.dart';
import 'package:messenger_app/models/user.dart';

final currentUser = User(id: '1', name: 'You', email: 'fariha@example.com');
final List<User> dummyUsers = [
  User(id: '2', name: 'Alice', email: 'alice@example.com'),
  User(id: '3', name: 'Bob', email: 'bob@example.com'),
];

// final List<Message> dummyMessages = [
//   Message(
//     id: 'm1',
//     senderId: 'u1',
//     receiverId: 'u2',
//     text: 'Hey, U..!',
//     timeStamp: DateTime.now().subtract(const Duration(minutes: 5)),
//     isRead: true,
//   ),

//   Message(
//     id: 'm2',
//     senderId: 'u2',
//     receiverId: 'u1',
//     text: 'Hi Fariha! How are you?',
//     timeStamp: DateTime.now().subtract(const Duration(minutes: 4)),
//     isRead: true,
//   ),

//   Message(
//     id: 'm3',
//     senderId: 'u1',
//     receiverId: 'u2',
//     text: 'I’m good!',
//     timeStamp: DateTime.now().subtract(const Duration(minutes: 2)),
//     isRead: false,
//   ),
// ];

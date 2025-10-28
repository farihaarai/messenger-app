import 'package:messenger_app/models/message.dart';
import 'package:messenger_app/models/user.dart';

final User currentUser = User(
  id: 'u1',
  name: 'Fariha',
  email: 'fariha@example.com',
);

final User otherUser = User(id: 'u2', name: 'U', email: 'uneiz@example.com');

final List<Message> dummyMessages = [
  Message(
    id: 'm1',
    senderId: 'u1',
    receiverId: 'u2',
    text: 'Hey, U..!',
    timeStamp: DateTime.now().subtract(const Duration(minutes: 5)),
    isRead: true,
  ),

  Message(
    id: 'm2',
    senderId: 'u2',
    receiverId: 'u1',
    text: 'Hi Fariha! How are you?',
    timeStamp: DateTime.now().subtract(const Duration(minutes: 4)),
    isRead: true,
  ),

  Message(
    id: 'm3',
    senderId: 'u1',
    receiverId: 'u2',
    text: 'I’m good!',
    timeStamp: DateTime.now().subtract(const Duration(minutes: 2)),
    isRead: false,
  ),
];

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;

import '../models/bot_message.dart';
import 'database_service.dart';

Future<String> getData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

class BotService {
  String uid;

  BotService({required this.uid});

  Stream<QuerySnapshot> getMessages() {
    if (uid == '') {
      return DatabaseService()
          .botMessageCollection
          .doc('default')
          .collection('messages')
          .orderBy('time', descending: false)
          .snapshots();
    }
    String bot_id = uid;
    return DatabaseService()
        .botMessageCollection
        .doc(bot_id)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future addMessage(BotMessage message) async {
    if (uid == '') {
      await DatabaseService()
          .botMessageCollection
          .doc('default')
          .collection('messages')
          .add(message.toMap());
      return;
    }
    String bot_id = uid;

    await DatabaseService()
        .botMessageCollection
        .doc(bot_id)
        .collection('messages')
        .add(message.toMap());
  }
}

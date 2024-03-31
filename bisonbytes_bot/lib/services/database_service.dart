import 'package:bisonbytes_bot/models/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService extends ChangeNotifier {
  // Add your database methods here
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference botMessageCollection =
      FirebaseFirestore.instance.collection('all_bot_messages');

    Future updateUserCollection(MyUser user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user.toMap();
    // update all student collections and student collections in respective schools
    await userCollection.doc(user.uid).set(dic);
    notifyListeners();
  }
}
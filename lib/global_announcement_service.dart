import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String text;

  Announcement(this.id, this.text);

  static Announcement from(DocumentSnapshot event) {
    return Announcement(event.documentID, event.data['text']);
  }
}

class GlobalAnnouncementService {
  static Stream<QuerySnapshot> _stream =
      Firestore.instance.collection("announcements").snapshots();

  static StreamSubscription<QuerySnapshot> onNotification(
          void Function(List<Announcement> notifications) func) =>
      _stream.listen((QuerySnapshot event) {
        func(event.documents.map((element) {
          return Announcement.from(element);
        }).toList());
      });
}

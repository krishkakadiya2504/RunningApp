import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var currentUser = _auth.currentUser;
    var userUid = currentUser!.uid;
    return Center(
      child: SizedBox(
        height: 200,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Registration')
              .doc(userUid)
              .collection('messages')
              .orderBy('timestamp', descending: true) // Order by timestamp
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> messageData =
                  messages[index].data() as Map<String, dynamic>;
                  String message = messageData['message'];
                  String timestamp = messageData['timestamp'];

                  return ListTile(
                    title: Text(message),
                    subtitle: Text(timestamp),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

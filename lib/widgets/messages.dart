import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_firebase_app/widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  Messages({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String userId = '';
    if (user != null) userId = user!.uid;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chat').orderBy('created_at', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final chatDocs = snapshot.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, idx) => MessageBubble(
                chatDocs[idx]['text'],
                chatDocs[idx]['user_id'] == userId,
                chatDocs[idx]['user_id'],
                key: ValueKey(chatDocs[idx].id),
              ),
            );
          }
        });
  }
}

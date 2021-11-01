import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ListView.builder(
  //         itemCount: 10,
  //         itemBuilder: (context, idx) => Container(
  //               padding: EdgeInsets.all(8),
  //               child: Text('This works'),
  //             )),
  //     floatingActionButton: FloatingActionButton(
  //         onPressed: () {
  //           // await Firebase.initializeApp();
  //           FirebaseFirestore.instance.collection('chats/Gl5rLpP1K8l3EFiANjME/messages').snapshots().listen((data) {
  //             data.docs.forEach((doc) {
  //               print(doc['text']);
  //             });
  //           });
  //         },
  //         child: Icon(Icons.add)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final firebaseSnapshot = FirebaseFirestore.instance.collection('chats/Gl5rLpP1K8l3EFiANjME/messages').snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseSnapshot,
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting || !streamSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> documents = streamSnapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, idx) => Container(
              padding: EdgeInsets.all(8),
              child: Text(documents[idx]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/Gl5rLpP1K8l3EFiANjME/messages')
                .add({'text': 'this was added by app'});
          },
          child: Icon(Icons.add)),
    );
  }
}

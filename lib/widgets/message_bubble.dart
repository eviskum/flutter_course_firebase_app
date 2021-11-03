import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userId;
  const MessageBubble(this.message, this.isMe, this.userId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(12),
              )),
          width: 240,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                  builder: (context, snapshot) {
                    String userTxt = 'Dummy';
                    if (snapshot.connectionState == ConnectionState.waiting)
                      userTxt = 'Getting username...';
                    else {
                      if (snapshot.hasData && snapshot.data!.data() != null) {
                        try {
                          userTxt = snapshot.data!['username'];
                        } catch (e) {
                          userTxt = 'username field error';
                        }
                      } else
                        userTxt = 'User not found!';
                    }
                    print(userTxt);
                    return Text(userTxt,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.black : Theme.of(context).colorScheme.onSecondary));
                  }),
              Text(
                message,
                style: isMe ? null : TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

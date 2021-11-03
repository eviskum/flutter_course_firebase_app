import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_firebase_app/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username, bool isLogin) async {
    UserCredential userCredential;
    String errorMessage;

    setState(() {
      _isLoading = true;
    });

    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }
      print('We are logged in');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'username': username, 'email': email});
    } on FirebaseAuthException catch (error) {
      errorMessage = 'We have an error';
      switch (error.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'account-exists-with-different-credential';
          break;
        case 'invalid-credential':
          errorMessage = 'invalid-credential';
          break;
        case 'invalid-verification-code':
          errorMessage = 'invalid-verification-code';
          break;
        case 'invalid-verification-id':
          errorMessage = 'invalid-verification-id';
          break;
        case 'user-disabled':
          errorMessage = 'user-disabled';
          break;
        case 'user-not-found':
          errorMessage = 'user-not-found';
          break;
        case 'wrong-password':
          errorMessage = 'wrong-password';
          break;
        case 'email-already-in-user':
          errorMessage = 'email-already-in-user';
          break;
        case 'invalid-email':
          errorMessage = 'invalid-email';
          break;
        case 'operation-not-allowed':
          errorMessage = 'operation-not-allowed';
          break;
        case 'weak-password':
          errorMessage = 'weak-password';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: AppBar(),
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}

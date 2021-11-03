import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function submitAuth;
  final isLoading;

  const AuthForm(
    this.submitAuth,
    this.isLoading, {
    Key? key,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  bool _isLogin = true;

  void _trySubmit() {
    if (_formKey.currentState == null) return;
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      print('$_userEmail $_userName $_userPassword');
      widget.submitAuth(_userEmail, _userPassword, _userName, _isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value == null || !value.contains('@')) return 'Please enter a valid email address';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email Address'),
                  onSaved: (value) {
                    _userEmail = value ?? '';
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value == null || value.length < 4) return 'Username must be at least 4 characters long';
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (value) {
                      _userName = value ?? '';
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value == null || value.length < 8) return 'Password must be at least 8 characters long';
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value ?? '';
                  },
                ),
                SizedBox(height: 12),
                widget.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(onPressed: _trySubmit, child: Text(_isLogin ? 'Login' : 'Sign Up')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin ? 'Create new account' : 'Log in with existing account')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

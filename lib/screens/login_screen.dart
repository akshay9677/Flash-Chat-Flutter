import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/authActions.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool load = false;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: load,
              child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
              child: Container(
                  height: 100.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email=value;
                },
                decoration: kInputDecoration,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                 password=value;
                },
                decoration: kInputDecoration.copyWith(hintText: 'Enter your Password'),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: 'login',
              child: AuthButtons(action: 'Login In',colour: Colors.lightBlueAccent,
                onClick: ()async{
                  setState(() {
                    load = true;
                  });
                  try{
                    final existingUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if(existingUser != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      load = false;
                    });
                  }catch(e){
                    print(e);
                  }
                  
                },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

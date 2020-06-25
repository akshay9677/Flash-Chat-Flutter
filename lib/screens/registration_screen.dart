import 'package:flash_chat/components/authActions.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                tag: 'register',
              child: AuthButtons(action: 'Register',colour: Colors.blue,
                onClick: ()async{
                  setState(() {
                    load = true;
                  });
                  try{
                    final newUser = await  _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if(newUser != null){
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
import 'package:flutter/material.dart';

class AuthButtons extends StatelessWidget {
  AuthButtons({this.action,this.colour,this.onClick});
  final String action;
  final Color colour;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onClick,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            action,
          ),
        ),
      ),
    );
  }
}
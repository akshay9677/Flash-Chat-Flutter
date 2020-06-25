import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = Firestore.instance;
 FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

  
class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  final _auth = FirebaseAuth.instance;
 
  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }


  void getCurrentUser() async{
    try{
         final user = await _auth.currentUser();
    if(user != null){
     loggedInUser = user;
     print(loggedInUser.email);
    }
    }catch(e){
      print(e);
    }
    
  }

  // void getMessages()async{
  //   final messages = await _firestore.collection('messages').getDocuments();
  //   for(var message in messages.documents){
  //     print(message.data);
  //   }
    
  // }

  void getMessages() async{
    await for(var snapshots in _firestore.collection('messages').snapshots()){
      for(var message in snapshots.documents){
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getMessages();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textController.clear();
                     _firestore.document('messages/'+new DateTime.now().toString()).setData({
                       'text': messageText,
                       'sender': loggedInUser.email
                     });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key key,
    @required Firestore firestore,
  }) : _firestore = firestore, super(key: key);

  final Firestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots() ,
      builder: (context,snapshot){
        if(!snapshot.hasData){
         return Center(
           child: CircularProgressIndicator(
             backgroundColor: Colors.lightBlueAccent,
           ),
         );
        }
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageWidgets = [];
          for(var message in messages){
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];

            final currUser = loggedInUser.email;

            final messageWidget = MessageBubble(text: messageText,sender: messageSender,isMe: currUser == messageSender,);
            messageWidgets.add(messageWidget);

          }
          return Expanded(
           child: ListView(
             reverse: true,
             padding: EdgeInsets.symmetric(horizontal: 13.00,vertical: 20.00),
              children: messageWidgets,
            ),
          );
        
      });
  }
}


class MessageBubble extends StatelessWidget {

  MessageBubble({this.text,this.sender,this.isMe});

  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.00),
      child: Column(
        crossAxisAlignment:isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:10.0,bottom: 4.0),
            child: Text(sender,style: TextStyle(fontSize: 10,color: Colors.black),),
          ),
          Material(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0),
            bottomRight:   Radius.circular(30.0),topLeft:  isMe ? Radius.circular(30.0) : Radius.circular(0),
            topRight: isMe ? Radius.circular(0) : Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.00,horizontal: 20.00),
              child: Text(text,style: TextStyle(fontSize: 15,color:isMe ? Colors.white : Colors.black),),
            )),
        ],
      ),
    );
  }
}
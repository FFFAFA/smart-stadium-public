import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class VerifyTicketPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Verify Ticket'),
      ),
      body: VerifyTicketForm()
    );
  }

  void _verifyTicket(){

  }
}

class VerifyTicketForm extends StatefulWidget{
  VerifyTicketForm({Key key}): super(key:key);
  _VerifyTicketFormState createState() => _VerifyTicketFormState();
}

class _VerifyTicketFormState extends State<VerifyTicketForm>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _eventSelected;
  String _dropdownValue = 'Select an event';
  TextEditingController _verificationCodeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Label(text: 'Event',),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Events').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (snapshot.hasError){return LinearProgressIndicator();}
                      if(!snapshot.hasData) {return LinearProgressIndicator();}
                      return DropdownButtonFormField<String>(
                          hint: Text(_dropdownValue, style: TextStyle(fontSize: 16),),
                          validator: (value){
                            if (value.isEmpty){return 'Please select an event';}
                            return null;
                          },
                          icon: Icon(Icons.arrow_downward, color: Theme.of(context).primaryColor,),
                          elevation: 20,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          items: snapshot.data.docs.map((document){
                            return DropdownMenuItem<String>(
                              child: Text(
                                document.data()['title'],
                                style: TextStyle(fontSize: 16),
                              ),
                              value: document.data()['title'],);
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              FirebaseFirestore.instance.collection('Events').where('title', isEqualTo: value).get()
                                  .then((snapshot) { _eventSelected = snapshot.docs[0].id; });
                            });
                          });
                    }
                ),
              ],
            ),
            Column(
              children: [
                Label(text: 'Verification',),
                TextFormField(
                  controller: _verificationCodeController,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                  ),
                  validator: (value){
                    if (value.isEmpty){
                      return 'Please enter the verification code on your ticket';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5)
                    ),
                    hintText: 'Enter your ticket number',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).hintColor,
                    ),
                    errorStyle: TextStyle(
                      fontSize: 15,
                      color:Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(
              onPressed: _verifyTicket,
              shape: StadiumBorder(),
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('Verify', style: TextStyle(fontSize: 25),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyTicket() async {
    final formState = _formKey.currentState;
    formState.validate();
    CollectionReference tickets = FirebaseFirestore.instance.collection('Tickets');
    CollectionReference users = FirebaseFirestore.instance.collection('User');
    Query byEventID = tickets.where('eventID', isEqualTo: _eventSelected);
    // Check if ticket exists
    byEventID.get().then((snapshot){
      if (snapshot.docs.isEmpty) {Toast.show('No available tickets under this event', context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);}
      else {
        Query byUserID = byEventID.where('userID', isEqualTo: FirebaseAuth.instance.currentUser.uid);
        byUserID.get().then((snapshot) {
          if (snapshot.docs.isEmpty) {Toast.show('You do not have valid ticket for this event', context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);}
          else {
            if (snapshot.docs[0]['verified']){
              Toast.show('This ticket has already been used', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            } else {
              if (snapshot.docs[0]['verification-code']==_verificationCodeController.text){
                // Update ticket status to verified = true
                tickets.doc(snapshot.docs[0].id).update({'verified': true});
                // Update user role to 'audience'
                users.doc(FirebaseAuth.instance.currentUser.uid).update({'role': 'audience'});
                Toast.show('Ticket Verified', context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                Navigator.of(context).pop();
              } else {
                Toast.show('Wrong verification code', context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
              }
            }
          }
        });
      }
    });
  }
}

class Label extends StatelessWidget{
  final text;
  Label({Key key, this.text}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      );
  }
}
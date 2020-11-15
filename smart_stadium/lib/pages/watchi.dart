import 'package:flutter/material.dart';

class WatchiPage extends StatefulWidget {

  @override
  _WatchiPageState createState() => _WatchiPageState();
}

class _WatchiPageState extends State<WatchiPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WatchiPage'),
      ),


      body:Center(
             child: Column(
                children: <Widget>[

             Image.asset('assets/Fifa.png'),
            Text('Fifa20'),
                ],
    ));

}
}









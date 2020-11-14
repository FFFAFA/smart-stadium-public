import 'package:flutter/material.dart';

class ReservePage extends StatefulWidget{
  @override
  _ReservePageState createState() => _ReservePageState();

}

class _ReservePageState extends State<ReservePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Reservation'),
      ),
    );
  }
}
import 'dart:convert';

import 'package:smart_stadium/pages/products/product.dart';

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_stadium/pages/products/product.dart';

class Cart extends StatefulWidget{
  List<Product> items;

  Cart(this.items);

  @override
  CartState createState() => CartState(this.items);
}

class CartState extends State<Cart> {
  CartState(this.items);

  List<Product> items;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 2.0),
                child: Card(elevation: 4.0,
                  child: ListTile(leading:
                    ImageIcon(
                      AssetImage(item.image),
                      color: Colors.black26,
                    ),
                    title: Text(item.title),
                    trailing: GestureDetector(
                        child: Icon(Icons.remove_circle,
                          color: Colors.amberAccent,),
                        onTap: () {
                          setState(() {
                            items.remove(item);
                          });
                        }),
                  ),
                ),
              );
          }),
    );
  }


}
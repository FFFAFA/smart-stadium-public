import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_stadium/pages/products/product.dart';
import 'package:smart_stadium/pages/products/cart.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:myOrderPage(title: 'Place order'),
    );
  }


}

class myOrderPage extends StatefulWidget{
  myOrderPage({Key key, this.title}):super(key:key);
  final String title;

  @override
  _myOrderPage createState() => _myOrderPage();

}

class _myOrderPage extends State<myOrderPage>{

  List<Product> listingItem = List<Product>();
  List<Product> cartList = List<Product>();



  @override
  void initState(){
    super.initState();
    _listOutProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(padding: const EdgeInsets.only(right:16,top:8),
                  child: GestureDetector(
                    child: Stack(alignment: Alignment.topCenter,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        size: 36.0,
                      ),
                    if(cartList.length > 0)
                      Padding(padding: const EdgeInsets.only(left: 2.0),
                        child: CircleAvatar(
                          radius: 8.0,
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.blue,
                          child: Text(
                            cartList.length.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                      ),
                      )
                    ],
                    ),
                    onTap: () {
                      if(cartList.isNotEmpty)
                        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Cart(cartList),
                      ),
                      );
                    },
                  ),

          ),
        ],
      ),
      body: _buildGridView(),
    );
  }

  GridView _buildGridView(){
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
        ),
      itemCount: listingItem.length,
      itemBuilder: (context, index){
        var item = listingItem[index];
        return Card(
          elevation: 4.0,
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget> [
                    ImageIcon(
                      AssetImage(item.image),
                      color: (cartList.contains(item))
                          ? Colors.blue
                          : Colors.amberAccent,
                          size:100.0,
                      ),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                right: 8.0,
                bottom: 8.0,
              ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    child: (!cartList.contains(item))
                        ? Icon(
                      Icons.add_circle,
                      color: Colors.amber,
                    )
                        : Icon(
                      Icons.remove_circle,
                      color: Colors.black12,
                    ),
                    onTap: (){
                        setState(() {
                          if (!cartList.contains(item))
                            cartList.add(item);
                          else
                            cartList.remove(item);
                        });},
                ),
              ),

              )],
          ),

        );
      },
    );

  }

  ListView _buildListView(){
    return ListView.builder(
        itemCount: listingItem.length,
        itemBuilder: (context, index){
          var item = listingItem[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2.0,
            ),
            child: Card(
              elevation: 4.0,
              child: ListTile(
                leading: ImageIcon(
                  AssetImage(item.image),
                  color: Colors.amber,
                ),
                title: Text(item.title),
                trailing: GestureDetector(
                  child:(!cartList.contains(item))
                      ? Icon(
                    Icons.add_circle,
                    color: Colors.green,
                  )
                      : Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  onTap: (){
                    setState(() {
                      if(!cartList.contains(item))
                        cartList.add(item);
                      else
                        cartList.remove(item);
                    });
                  },
                ),
              ),
            ),
          );
        });

  }

  void _listOutProduct(){
    var list = <Product>[
      Product(
          "1",
          "https://www.midgetmomma.com/wp-content/uploads/2013/05/Homemade-Lemonade_-5.jpg",
          "Lemonade",
          3.00,
          1
      ),
    ];

    setState((){
      listingItem = list;
    });
  }

  // static double _calculatePrice(List<Product> items) {
  //   final double price = items.fold(0, (accumulator , product) => accumulator + (product.quantity * product.price));
  //   return double.parse(price.toStringAsFixed(2));
  // }
  //
  // static int _calculateItems(List<Product> items){
  //   return items.fold(0, (accumulator, item) => accumulator+item.quantity);
  // }

}



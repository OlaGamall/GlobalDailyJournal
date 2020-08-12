import 'package:flutter/material.dart';
import '../widgets/categories_item.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categories';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        title: Text(
          'Filters',
          style: TextStyle(
              fontFamily: "Florentia",
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.greenAccent,),
            iconSize: 28,
            onPressed: () => Apply.applyButton(context),
          )
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //   child: RaisedButton(
          //       color: Theme.of(context).accentColor,
          //       child: Padding(
          //           padding: const EdgeInsets.all(4.0),
          //           child: Text(
          //             'Apply',
          //             style: TextStyle(
          //                 fontFamily: 'Raleway',
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 20,
          //                 color: Colors.white),
          //           )),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(40)),
          //       onPressed: () => Apply.applyButton(context)),
          //)
        ],
      ),
      body: SingleChildScrollView(child: CategoriesItem()),
    );
  }
}

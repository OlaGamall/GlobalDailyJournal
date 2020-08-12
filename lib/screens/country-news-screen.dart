//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../providers/news.dart';
import '../widgets/news_item.dart';

class CountryNewsScreen extends StatelessWidget {
  static const routeName = '/country-news';
  @override
  Widget build(BuildContext context) {
    final countryData = ModalRoute.of(context).settings.arguments as Map;
    final location = countryData['countryName'];
    final id = countryData['countryId'];
    final newsData = Provider.of<News>(context, listen: false);

    //newsData.getNewsOfLocation(id);
  
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        title: Text(
          location,
          style: TextStyle(
            fontFamily: "Florentia",
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body: FutureBuilder(
        future: newsData.getNewsOfLocation(location: id, category: News.newsCategory),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: ListView.builder(
                        itemCount: newsData.localNews.length,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                              value: newsData.localNews[i],
                              child: NewsItem(
                                item: newsData.localNews[i],
                              ),
                            )),
                  ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/news.dart';
import '../widgets/news_item.dart';

class RecentNewsScreen extends StatefulWidget {
  static const routeName = '/recentNews';

  @override
  _RecentNewsScreenState createState() => _RecentNewsScreenState();
}

class _RecentNewsScreenState extends State<RecentNewsScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreNews();
      }
    });
    super.initState();
  }

  void _getMoreNews() {
    Provider.of<News>(context, listen: false).getNews().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final news = Provider.of<News>(context, listen: false).news;

    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        title: Text(
          'News',
          style: TextStyle(
              fontFamily: "Florentia",
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
        child: ListView.builder(
            controller: _scrollController,
            itemCount: news.length + 1,
            itemBuilder: (ctx, i) {
              if (i == news.length) {
                return CupertinoActivityIndicator();
              }
              return ChangeNotifierProvider.value(
                  value: news[i],
                  //builder: (_) => products[index],
                  child: NewsItem(
                    item: news[i],
                  ));
            }),
      ),
    );
  }
}

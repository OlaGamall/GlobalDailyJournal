import 'package:flutter/material.dart';
import 'package:gdj/models/news_article.dart';
import 'package:provider/provider.dart';
//import '../providers/auth.dart';
import '../providers/news.dart';
import '../models/news_article.dart';
import '../widgets/news_item.dart';

class SavedNewsScreen extends StatelessWidget {
  static const routeName = '/saved_news_screen';

  @override
  Widget build(BuildContext context) {
    List<NewsArticle> savedNews;
    return Scaffold(
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          centerTitle: true,
          title: Text(
            'Saved News',
            style: TextStyle(
                fontFamily: "Florentia",
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: Provider.of<News>(context).getSavedNews().then((result) {
            savedNews = result;
          }),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Container(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SavedNewsItems(savedNews: savedNews),
        ));
  }
}

class SavedNewsItems extends StatefulWidget {
  const SavedNewsItems({
    @required this.savedNews,
  });

  final List<NewsArticle> savedNews;

  @override
  _SavedNewsItemsState createState() => _SavedNewsItemsState();
}

class _SavedNewsItemsState extends State<SavedNewsItems> {
  void update(String id) {
    setState(() {
      widget.savedNews.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
        child: widget.savedNews.length == 0
            ? Center(child: Text("You don't have any saved News!"))
            : ListView.builder(
                itemCount: widget.savedNews.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: widget.savedNews[i],
                      //builder: (_) => products[index],
                      child: NewsItem(
                        item: widget.savedNews[i],
                        showAsSaved: true,
                        updateScreen: update,
                      ),
                    )));
  }
}

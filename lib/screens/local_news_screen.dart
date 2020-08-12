import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news.dart';
import '../widgets/news_item.dart';

class LocalNewsScreen extends StatelessWidget {
  static const routeName = "/local-news";
  @override
  Widget build(BuildContext context) {
    final newsData = Provider.of<News>(context, listen: false);
    Locale location = Localizations.localeOf(context);
    final userLocation = location.toString().split("_")[1];
    //newsData.getNewsOfLocation(userLocation);
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        title: Text(
          'Your Local News',
          style: TextStyle(
            fontFamily: "Florentia",
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body: FutureBuilder(
        future: newsData.getNewsOfLocation(location: userLocation, category: News.newsCategory),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(
                padding:
                    const EdgeInsets.only(top: 10, left: 5, right: 5),
                child: newsData.localNews == null
                    ? Container(
                        child: Center(
                          child: Text(
                              "There is no news for your location at the moment!",
                              style: TextStyle(color: Colors.black)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: newsData.localNews.length,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: newsData.localNews[i],
                            //builder: (_) => products[index],
                            child: NewsItem(
                              item: newsData.localNews[i],
                            )),
                      ),
              ),
      ),
    );
  }
}

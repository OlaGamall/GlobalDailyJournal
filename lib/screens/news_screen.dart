import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './recent-news-screen.dart';
import '../providers/news.dart';
import '../widgets/news_item.dart';
import '../widgets/top_item.dart';

class NewsScreen extends StatelessWidget {
  final availableHeight;
  NewsScreen(this.availableHeight);
  @override
  Widget build(BuildContext context) {
    final myNews = Provider.of<News>(context);
    print('News screen');
    return Container(
      color: Color.fromRGBO(238, 238, 238, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          // Text(
          //   ' Top News',
          //   style: TextStyle(
          //     fontSize: 22,
          //     fontFamily: 'Florentia',
          //     fontWeight: FontWeight.bold,
          //     letterSpacing: 1.5,
          //     color: Colors.white70,
          //   ),
          // ),
          // SizedBox(
          //   height: 4,
          // ),
          Container(
            height: 200,
            child: ListView.builder( 
                scrollDirection: Axis.horizontal,
                itemCount: myNews.topNews.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: myNews.topNews[i],
                    //builder: (_) => products[index],
                    child: Row(
                      children: [
                        i == 0 ? SizedBox(width: 6,) : SizedBox(width: 0,), 
                        TopItem(myNews.topNews[i]),
                      ],
                    ))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '  Recent News',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 3),
                child: RaisedButton(
                  elevation: 0,
                  child: Text(
                    'See All',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  color: Color.fromRGBO(238, 238, 238, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RecentNewsScreen.routeName);
                  },
                ),
              )
            ],
          ),

          Padding(
              padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
              child: Container(
                  height: availableHeight - 318,
                  child: ListView.builder(
                      itemCount: myNews.recentNews.length,
                      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: myNews.recentNews[i],
                            //builder: (_) => products[index],
                            child: NewsItem(
                              item: myNews.recentNews[i],
                            ),
                          )))),
        ],
      ),
    );
  }
}

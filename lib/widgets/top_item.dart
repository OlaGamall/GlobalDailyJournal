import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_article.dart';
import '../screens/news_detail_screen.dart';

class TopItem extends StatelessWidget {
  final NewsArticle item;
  TopItem(this.item);
  @override
  Widget build(BuildContext context) {
    Provider.of<NewsArticle>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(NewsDetailScreen.routeName, arguments: item.id);
        item.incrementNumberOfViews(item);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 5, offset: Offset(2, 2),)
        ]),
        margin: EdgeInsets.only(right: 8, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width * 0.75,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              child: Opacity(
                opacity: 0.9,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            //Positioned(
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    item.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${item.views} ",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white60),
                      ),
                      Icon(Icons.visibility, color: Colors.white60),
                    ],
                  ),
                ],
              ),
            ),
            // bottom: 0,
            //),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../screens/news_detail_screen.dart';
import '../screens/auth-screen.dart';
import '../models/news_article.dart';

class NewsItem extends StatelessWidget {
  final NewsArticle item;
  final bool showAsSaved;
  final Function updateScreen;
  NewsItem({@required this.item, this.showAsSaved = false, this.updateScreen});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(NewsDetailScreen.routeName, arguments: item.id);

        item.incrementNumberOfViews(item);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.white,
        elevation: 5,
        child: Container(
          //padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        item.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13 //15,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              showAsSaved
                  ? DeleteIcon(
                      item: item,
                      updateScreen: updateScreen,
                    )
                  : SavedIcon(item: item),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteIcon extends StatelessWidget {
  final NewsArticle item;
  final Function updateScreen;
  DeleteIcon({@required this.item, @required this.updateScreen});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text(
                      'Are you sure you want to delete this from your saved news list?'),
                  contentPadding: const EdgeInsets.all(20),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        item.toggleSavedStatus(item, Auth.token, Auth.userId);
                        updateScreen(item.id);
                      },
                    ),
                  ],
                ));
      },
    );
  }
}

class SavedIcon extends StatefulWidget {
  const SavedIcon({
    Key key,
    @required this.item,
  }) : super(key: key);

  final NewsArticle item;

  @override
  _SavedIconState createState() => _SavedIconState();
}

class _SavedIconState extends State<SavedIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.item.isSaved ? Icons.bookmark : Icons.bookmark_border,
        size: 30,
      ),
      onPressed: () {
        Auth.isAuth
            ? setState(() {
                widget.item
                    .toggleSavedStatus(widget.item, Auth.token, Auth.userId);
              })
            : Navigator.of(context)
                .pushNamed(AuthScreen.routeName, arguments: widget.item)
                .then((result) {
                if (result != null) {
                  widget.item.setSavedStatusToTrue(
                      widget.item, Auth.token, Auth.userId);
                }
              });
      },
    );
  }
}

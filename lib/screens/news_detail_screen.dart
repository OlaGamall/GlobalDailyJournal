import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../providers/news.dart';
import '../models/news_article.dart';

class NewsDetailScreen extends StatelessWidget {
  static const routeName = "/news-detail";
  @override
  Widget build(BuildContext context) {
    String content1 = "";
    String content2 = "";
    var newsId;
    NewsArticle newsObject;
    var contentList;

    try {
      newsId = ModalRoute.of(context).settings.arguments as String;
      newsObject =
          Provider.of<News>(context, listen: false).getNewsById(newsId);
      contentList = newsObject.content;
    } catch (e) {
      newsObject = ModalRoute.of(context).settings.arguments as NewsArticle;
      contentList = newsObject.content;
    }

    for (int i = 0; i < 6 ; i++) {
      content1 += "${contentList[i]}\n\n";
    }
    for (int i = 6; i < contentList.length; i++) {
      content2 += "${contentList[i]}\n\n";
    }

    final appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [HearingIcon(content1, content2)],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Container(
        height: MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                newsObject.description,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
              ),
              SizedBox(height: 10,),
              Container(
                height: 200,
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  child: Image.network(
                    newsObject.imageUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              Text(
            content1,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          Text(
            content2,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

class HearingIcon extends StatefulWidget {
  final String content1;
  final String content2;
  HearingIcon(this.content1, this.content2);
  @override
  _HearingIconState createState() => _HearingIconState();
}

class _HearingIconState extends State<HearingIcon> {
  FlutterTts flutterTts = FlutterTts();
  var cancel = false;

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  Future _speak(String text1, String text2) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(1);
    await flutterTts.speak(text1);
    await flutterTts.speak(text2);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      //icon: Icon(Icons.headset),
      icon: cancel == false ? Icon(Icons.hearing) : Icon(Icons.cancel),
      onPressed: () {
        cancel == false ? _speak(widget.content1, widget.content2) : _stop();
        setState(() {
          cancel = !cancel;
        });
      },
    );
  }
}
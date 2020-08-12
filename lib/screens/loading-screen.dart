import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../providers/news.dart';
import '../models/news_article.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String content = "";
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

    for (int i = 0; i < contentList.length; i++) {
      content += "${contentList[i]}\n\n";
    }

    final appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [HearingIcon(content)],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Container(
        height: MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                newsObject.description,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w900, height: 1.5),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
            content,
            textAlign: TextAlign.left,
            style: TextStyle(
              //fontFamily: 'ZCOOLXiaoWei-Regular',
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1,
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
  final String content;
  HearingIcon(this.content);
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

  Future _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      //icon: Icon(Icons.headset),
      icon: cancel == false ? Icon(Icons.volume_up) : Icon(Icons.cancel),
      onPressed: () {
        cancel == false ? _speak(widget.content) : _stop();
        setState(() {
          cancel = !cancel;
        });
      },
    );
  }
}

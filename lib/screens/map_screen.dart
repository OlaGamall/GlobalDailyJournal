import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/news.dart';
import './country-news-screen.dart';
import './news_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen();

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  WebView webView;
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://map-view-project-4a61d.web.app/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController control) {
        //_controller = control;
      },
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'print',
            onMessageReceived: (JavascriptMessage message) {
              if (message.message == "null") {
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'This country has no news at the moment',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2)));
              } else {
                Navigator.of(context)
                    .pushNamed(CountryNewsScreen.routeName, arguments: {
                  'countryId': message.message.substring(0, 2),
                  'countryName': message.message.substring(2)
                });
              }
            }),
        JavascriptChannel(
            name: 'send',
            onMessageReceived: (JavascriptMessage message) async {
              final newsObject = await Provider.of<News>(context, listen: false)
                  .getNewsByIdFromServer(message.message);
              Navigator.of(context).pushNamed(NewsDetailScreen.routeName,
                  arguments: newsObject);
            }),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class COVID19MapScreen extends StatelessWidget {
  static const routeName = '/corona';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        title: Text(
          'Covid-19',
          style: TextStyle(
            fontFamily: "Florentia",
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body:WebView(
      initialUrl: 'https://covid-19-map-29294.web.app/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController control) {
        //_controller = control;
      },
      
    ),
    );
  }
}
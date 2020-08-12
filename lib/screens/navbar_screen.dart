import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news.dart';
import '../providers/auth.dart';
import '../widgets/appDrawer.dart';
import './map_screen.dart';
import './news_screen.dart';

enum SelectedView {
  Map,
  TopNews,
}

class NavBarScreen extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).tryToLogin().then((result) {
      if (result == false) {
        Provider.of<Auth>(context, listen: false)
            .tryToLoginWithEmailAndPassword();
      }
    });
    Provider.of<News>(context, listen: false).getTopNews().then((_){
      Provider.of<News>(context, listen: false).getRecentNews();
    });
    super.initState();
  }

  var selectedView = SelectedView.Map;

  final appBar = AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    // actions: <Widget>[
    //   IconButton(
    //     icon: Icon(
    //       Icons.search,
    //       color: Colors.black,
    //     ),
    //     onPressed: () {},
    //   )
    // ],
    leading: DrawerIcon(),
    title: Text(
      'Home',
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final availableHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);
    final map =  Container(
        margin: EdgeInsets.only(right: 3),
        child: RaisedButton(
          elevation: selectedView == SelectedView.Map ? 5 : 0,
          color: selectedView == SelectedView.Map
              ? Colors.greenAccent
              : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(38)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
            child: Text(
              '  Map  ',
              style: TextStyle(
                color: selectedView == SelectedView.Map
                    ? Colors.white
                    : Colors.grey,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedView = SelectedView.Map;
            });
          },
        ),
    );

    final topNews = RaisedButton(
        elevation: selectedView == SelectedView.Map ? 0 : 5,
        color: selectedView == SelectedView.Map
            ? Colors.white
            : Colors.greenAccent, //Color.fromRGBO(82, 71, 90, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
          child: Text(
            'Journal',
            style: TextStyle(
              color:
                  selectedView == SelectedView.Map ? Colors.grey : Colors.white,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            selectedView = SelectedView.TopNews;
          });
        },
    );

    return Scaffold(
      appBar: appBar,
      drawer: new AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(color: Color.fromRGBO(238, 238, 238, 1)),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black38,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [map, topNews],
                    )
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Stack(
                  children: [
                    Container(
                        width: double.infinity,
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.86,
                        child: const MapScreen()),
                    selectedView == SelectedView.TopNews
                        ? NewsScreen(availableHeight)
                        : Container()
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class DrawerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Scaffold.of(context).openDrawer(),
      child: Icon(Icons.menu, size: 30, color: Colors.black),
    );
  }
}

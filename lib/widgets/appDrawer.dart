import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/auth-screen.dart';
import '../screens/saved-news-screen.dart';
import '../screens/local_news_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/covid-19-map.dart';

class AppDrawer extends StatelessWidget {
  Widget listTileBuilder(IconData icon, String title, Function onPress) {
    return ListTile(
      leading: Text(
        title,
        style: TextStyle(
            color: Colors.black54,
            fontFamily: 'Raleway',
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        icon,
        size: 27,
        color: Colors.black54,
      ),
      onTap: onPress,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Drawer(
        child: Column(
      children: <Widget>[
        Container(
          height: 120,
          child: Image.asset(
            'assets/images/location_news.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Color.fromRGBO(238, 238, 238, 1),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(colors: [
          //     Color.fromRGBO(238, 238, 238, 1),//Color.fromRGBO(72, 63, 78, 1),
          //     //Color.fromRGBO(82, 71, 90, 1),
          //     //Color.fromRGBO(151, 122, 160, 1),
          //     Color.fromRGBO(255, 255, 255, 1),//Color.fromRGBO(230, 163, 225, 1),
          //   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          // ),
          width: double.infinity * 0.4,
          height: MediaQuery.of(context).size.height - 120,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              listTileBuilder(Icons.home, 'Home',
                  () => Navigator.of(context).pushReplacementNamed('/')),
              Divider(color: Colors.black26),
              listTileBuilder(Icons.bookmark, 'Saved News',
                  () => Navigator.of(context).pushNamed(SavedNewsScreen.routeName)),
              Divider(color: Colors.black26),
              listTileBuilder(Icons.location_on, 'Local News',
                  () => Navigator.of(context).pushNamed(LocalNewsScreen.routeName)),
              Divider(color: Colors.black26),
              listTileBuilder(Icons.map, 'COVID-19 Map',
                  () => Navigator.of(context).pushNamed(COVID19MapScreen.routeName)),
              Divider(color: Colors.black26),
              listTileBuilder(Icons.tune, 'Filters',
                  () => Navigator.of(context).pushNamed(CategoriesScreen.routeName)),
              Divider(color: Colors.black26),
              listTileBuilder(
                  Auth.isAuth ? Icons.exit_to_app : Icons.account_circle,
                  Auth.isAuth ? 'Sign out' : 'Sign in',
                  Auth.isAuth
                      ? () {
                          auth.logout();
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      : () => Navigator.of(context)
                          .pushNamed(AuthScreen.routeName)),
              Divider(color: Colors.black26),
            ],
          ),
        ),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/news.dart';
import './providers/auth.dart';
import './screens/navbar_screen.dart';
import './screens/country-news-screen.dart';
import './screens/news_detail_screen.dart';
import './screens/auth-screen.dart';
import './screens/local_news_screen.dart';
import './screens/recent-news-screen.dart';
import './screens/saved-news-screen.dart';
import './screens/categories_screen.dart';
import './screens/login_screen.dart';
import './screens/covid-19-map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),

        ChangeNotifierProvider.value(
          value: News(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: Colors.deepPurple,
          primaryColor: Colors.white,
          accentColor: Colors.greenAccent,
          fontFamily: 'Lato',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'Florentia',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
        ),
        title: 'news app',
        home: NavBarScreen(),
        routes: {
          CountryNewsScreen.routeName: (ctx) => CountryNewsScreen(),
          NewsDetailScreen.routeName: (ctx) => NewsDetailScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          RecentNewsScreen.routeName: (ctx) => RecentNewsScreen(),
          SavedNewsScreen.routeName: (ctx) => SavedNewsScreen(),
          CategoriesScreen.routeName:(ctx)=> CategoriesScreen(),
          LocalNewsScreen.routeName:(ctx) => LocalNewsScreen(),
          LoginScreen.routeName:(ctx)=>LoginScreen(),
          COVID19MapScreen.routeName: (ctx) => COVID19MapScreen(),
        },
      ),
    );
  }
}

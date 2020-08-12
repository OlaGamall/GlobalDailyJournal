import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './auth.dart';
import '../models/news_article.dart';

NewsArticle lastNewsItem;
var recentNewsUrl =
    'https://glopper-f830f.firebaseio.com/news/.json?orderBy="key"&limitToFirst=20';
String newsUrl;
const topNewsUrl =
    'https://glopper-f830f.firebaseio.com/news.json?orderBy="views"&limitToLast=20';

class News with ChangeNotifier {
  static String newsCategory = "null";
  List<NewsArticle> _recentNews = [];
  List<NewsArticle> _topNews = [];
  List<NewsArticle> _localNews = [];
  List<NewsArticle> _news = [];
  List<NewsArticle> _savedNews = [];
  var count = 30;
  var increment = 0;
  var savedData;
  var response;
  var extractedData;

  List<NewsArticle> get recentNews {
    return _recentNews;
  }

  List<NewsArticle> get news {
    return _news;
  }

  List<NewsArticle> get localNews {
    return _localNews;
  }

  List<NewsArticle> get topNews {
    return _topNews;
  }

  Future<void> getTopNews() async {
    _topNews = [];

    response = await http.get(topNewsUrl);
    print("top");
    extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (Auth.isAuth) {
      final savedUrl =
          'https://favorite-news-app-c0d67.firebaseio.com/savedStatus/${Auth.userId}.json?auth=${Auth.token}';
      final fetchSaved = await http.get(savedUrl);
      savedData = json.decode(fetchSaved.body);
    }

    extractedData.forEach((key, value) {
      _topNews.add(NewsArticle(
        id: key,
        title: value['header'],
        category: value['tag'],
        description: value['summary'],
        content: value['contentTexts'],
        imageUrl: value['imgUrl'],
        location: value['countryCode'],
        views: value['views'],
        isSaved: Auth.isAuth
            ? (savedData == null ? false : savedData[key] ?? false)
            : false,
      ));
    });
    _topNews.sort((a, b) => a.views.compareTo(b.views));
    _topNews = _topNews.reversed.toList();
  }

  Future<void> getRecentNews() async {
    _recentNews = [];
    response = await http.get(recentNewsUrl);
    print('news');
    extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((key, value) {
      _recentNews.add(NewsArticle(
        id: key,
        title: value['header'],
        category: value['tag'],
        description: value['summary'],
        content: value['contentTexts'],
        imageUrl: value['imgUrl'],
        location: value['countryCode'],
        views: value['views'],
        isSaved: Auth.isAuth
            ? (savedData == null ? false : savedData[key] ?? false)
            : false,
      ));
      _news.add(NewsArticle(
        id: key,
        title: value['header'],
        category: value['tag'],
        description: value['summary'],
        content: value['contentTexts'],
        imageUrl: value['imgUrl'],
        location: value['countryCode'],
        views: value['views'],
        isSaved: Auth.isAuth
            ? (savedData == null ? false : savedData[key] ?? false)
            : false,
      ));
    });

    notifyListeners();
  }

  Future<void> getNews() async {
    lastNewsItem = _recentNews[_recentNews.length - 1];
    newsUrl =
        'https://glopper-f830f.firebaseio.com/news.json?orderBy="key"&limitToFirst=$count';
    response = await http.get(newsUrl);
    extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((key, value) {
      ++increment;
      if (increment > count - 10) {
        _news.add(NewsArticle(
          id: key,
          title: value['header'],
          category: value['tag'],
          description: value['summary'],
          content: value['contentTexts'],
          imageUrl: value['imgUrl'],
          location: value['countryCode'],
          views: value['views'],
          isSaved: Auth.isAuth
              ? (savedData == null ? false : savedData[key] ?? false)
              : false,
        ));
      }
    });
    increment = 0;
    notifyListeners();
  }

  Future<void> getNewsByCategory(String category) async {
    _recentNews = [];
    _localNews = [];
    _news = [];

    newsUrl =
        'https://glopper-f830f.firebaseio.com/news.json?orderBy="category"&equalTo="$category"';
    response = await http.get(newsUrl);
    extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((key, value) {
      _recentNews.add(NewsArticle(
        id: key,
        title: value['header'],
        category: value['tag'],
        description: value['summary'],
        content: value['contentTexts'],
        imageUrl: value['imgUrl'],
        location: value['countryCode'],
        views: value['views'],
        isSaved: Auth.isAuth
            ? (savedData == null ? false : savedData[key] ?? false)
            : false,
      ));
    });
    var sortedNews = [..._recentNews];
    sortedNews.sort((a, b) => a.views.compareTo(b.views));
    sortedNews = sortedNews.reversed.toList();
    _topNews = sortedNews.sublist(0, 11);
    _news = _recentNews;
    notifyListeners();
  }

  Future<List<NewsArticle>> getSavedNews() async {
    _savedNews = [];
    final savedNewsUrl =
        'https://favorite-news-app-c0d67.firebaseio.com/savedNews/${Auth.userId}.json?auth=${Auth.token}}';

    response = await http.get(savedNewsUrl);
    extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((key, value) {
      _savedNews.add(NewsArticle(
          id: key,
          title: value['header'],
          content: value['contentTexts'],
          imageUrl: value['imageUrl'],
          isSaved: true));
    });
    return _savedNews;
  }

  NewsArticle getNewsById(String id) {
    final recentNewsItem =
        _recentNews.firstWhere((item) => item.id == id, orElse: () => null);
    if (recentNewsItem != null) {
      return recentNewsItem;
    }

    final topItem =
        _topNews.firstWhere((item) => item.id == id, orElse: () => null);
    if (topItem != null) {
      return topItem;
    }

    final localItem =
        _localNews.firstWhere((item) => item.id == id, orElse: () => null);
    if (localItem != null) {
      return localItem;
    }

    final savedItem =
        _savedNews.firstWhere((item) => item.id == id, orElse: () => null);
    if (savedItem != null) {
      return savedItem;
    }
    final newsItem =
        _news.firstWhere((item) => item.id == id, orElse: () => null);

    return newsItem;
  }

  Future<NewsArticle> getNewsByIdFromServer(String id) async {
    var getNewsUrl = 'https://glopper-f830f.firebaseio.com/news/$id.json';
    var response = await http.get(getNewsUrl);
    var extractedData = json.decode(response.body) as Map<String, dynamic>;

    var newsItem = NewsArticle(
      id: id,
      title: extractedData['header'],
      category: extractedData['tag'],
      description: extractedData['summary'],
      content: extractedData['contentTexts'],
      imageUrl: extractedData['imgUrl'],
      location: extractedData['countryCode'],
      views: extractedData['views'],
    );
    return newsItem;
  }

  Future<void> getNewsOfLocation(
      {@required String location, String category}) async {
    _localNews = [];
    var localNewsUrl =
        'https://glopper-f830f.firebaseio.com/news/.json?orderBy="countryCode"&equalTo="$location"';
    response = await http.get(localNewsUrl);
    extractedData = json.decode(response.body) as Map<String, dynamic>;

    // if (Auth.isAuth) {
    //   final savedUrl =
    //       'https://favorite-news-app-c0d67.firebaseio.com/savedStatus/${Auth.userId}.json?auth=${Auth.token}';
    //   final fetchSaved = await http.get(savedUrl);
    //   savedData = json.decode(fetchSaved.body);
    // }

    extractedData.forEach((key, value) {
      _localNews.add(NewsArticle(
        id: key,
        title: value['header'],
        category: value['tag'],
        description: value['summary'],
        content: value['contentTexts'],
        imageUrl: value['imgUrl'],
        location: value['countryCode'],
        views: value['views'],
        isSaved: Auth.isAuth
            ? (savedData == null ? false : savedData[key] ?? false)
            : false,
      ));
    });
    if (category != "null")
      _localNews = _localNews.where((item) => item.category == category);
  }
}

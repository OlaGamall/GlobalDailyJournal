import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './http_exception.dart';

class NewsArticle with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final List<dynamic> content;
  final String imageUrl;
  final String location;
  final String category;
  bool isSaved;
  int views;

  NewsArticle({
    @required this.id,
    @required this.title,
    this.description = "",
    @required this.content,
    @required this.imageUrl,
    this.location = "",
    this.category = "",
    this.isSaved = false,
    this.views,
  });

  Future<void> toggleSavedStatus(
      NewsArticle newsItem, String token, String userId) async {
    final url =
        'https://favorite-news-app-c0d67.firebaseio.com/savedStatus/$userId/${newsItem.id}.json?auth=$token';
    isSaved = !isSaved;
    notifyListeners();
    final response = await http.put(url,
        body: json.encode(
          isSaved,
        ));

    if (isSaved)
      await postSavedNews(newsItem, token, userId);
    else
      await deleteSavedNews(newsItem, token, userId);

    if (response.statusCode >= 400) {
      isSaved = !isSaved;
      notifyListeners();
      throw HttpException('faliled to mark as saved');
    }
  }

  Future<void> setSavedStatusToTrue(
      NewsArticle newsItem, String token, String userId) async {
    final url =
        'https://favorite-news-app-c0d67.firebaseio.com/savedStatus/$userId/${newsItem.id}.json?auth=$token';
    isSaved = true;
    notifyListeners();
    final response = await http.put(url,
        body: json.encode(
          isSaved,
        ));
    await postSavedNews(newsItem, token, userId);

    if (response.statusCode >= 400) {
      isSaved = false;
      notifyListeners();
      throw HttpException('faliled to mark as saved');
    }
  }

  Future<void> postSavedNews(
      NewsArticle newsItem, String token, String userId) async {
    final url =
        'https://favorite-news-app-c0d67.firebaseio.com/savedNews/$userId/${newsItem.id}.json?auth=$token';

    await http.put(url,
        body: json.encode({
          'header': newsItem.title,
          'content': newsItem.content,
          'imageUrl': newsItem.imageUrl,
        }));
  }

  Future<void> deleteSavedNews(
      NewsArticle newsItem, String token, String userId) async {
    final url =
        'https://favorite-news-app-c0d67.firebaseio.com/savedNews/$userId/${newsItem.id}.json?auth=$token';

    await http.delete(url);
  }

  Future<void> incrementNumberOfViews(NewsArticle newsArticle) async {
    final url =
        'https://glopper-f830f.firebaseio.com/news/${newsArticle.id}.json';
    newsArticle.views += 1;
    notifyListeners();
    final response = await http.patch(url,
        body: json.encode(
          {"views": newsArticle.views},
        ));

    if (response.statusCode >= 400) {
      newsArticle.views -= 1;
      notifyListeners();
      throw HttpException('faliled to increment');
    }
  }
}

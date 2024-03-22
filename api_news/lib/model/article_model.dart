import 'package:api_news/model/source_model.dart';
import 'package:flutter/foundation.dart';

class Article {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  Article(
      {required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});

  Article.fromJson(Map<String, dynamic> parsedJson)
      : source = Source.fromJson(parsedJson['source']),
        author = parsedJson['author'] ?? "Unknown Author",
        title = parsedJson['title'] ?? "Unknown Title",
        description = parsedJson['description'] ?? "Unknown Description",
        url = parsedJson['url'] ?? "Unknown Url",
        urlToImage = parsedJson['urlToImage'] ??
            "https://homepages.cae.wisc.edu/~ece533/images/peppers.png",
        publishedAt = parsedJson['publishedAt'] ?? "Unknown PublishedAt",
        content = parsedJson['content'] ?? "Unknown Content";

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source.toMap(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: Source.fromMap(map['source'] as Map<String, dynamic>),
      author: map['author'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      url: map['url'] as String,
      urlToImage: map['urlToImage'] as String,
      publishedAt: map['publishedAt'] as String,
      content: map['content'] as String,
    );
  }
}

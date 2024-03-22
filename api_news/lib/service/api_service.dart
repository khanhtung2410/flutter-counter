import 'dart:convert';

import 'package:http/http.dart';

import 'package:api_news/model/article_model.dart';

//HTTP service
class ApiService {
  final endPointURL = Uri.parse(
      "https://newsapi.org/v2/everything?q=tesla&from=2024-02-22&sortBy=publishedAt&apiKey=e3d30436c26040d3ab0583ae81c1cc5b");

  Future<List<Article>> getArticle() async {
    Response res = await get(endPointURL);

    //check if have 200 status code
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw ("Can't get the articles");
    }
  }
}

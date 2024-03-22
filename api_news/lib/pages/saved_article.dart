// import 'package:flutter/material.dart';
// import 'package:localstore/localstore.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:api_news/model/saved_article_model.dart';

// class SavedArticleView extends StatefulWidget {
//   @override
//   State<SavedArticleView> createState() => _SavedArticleViewState();
// }

// class _SavedArticleViewState extends State<SavedArticleView> {
//   Future<SavedArticle> init() async {
//     SavedArticle savedArticle = SavedArticle(saved: ar);
//     bool isLoaded = false;
//     if (isLoaded) return savedArticle;
//     var value = await loadSavedArticle();
//     if (value != null) {
//       try {
//         isLoaded = true;
//         return SavedArticle.fromMap(value);
//       } catch (e) {
//         debugPrint(e.toString());
//       }
//     }
//     return 
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }

//   }


// Future<Map<String, dynamic>?> loadSavedArticle() async {
//   return await Localstore.instance.collection('article').doc('saved').get();
// }

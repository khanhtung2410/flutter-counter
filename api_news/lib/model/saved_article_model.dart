// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:api_news/model/article_model.dart';

class SavedArticle {
  Article saved;
  SavedArticle({
    required this.saved,
  });

  SavedArticle copyWith({
    Article? saved,
  }) {
    return SavedArticle(
      saved: saved ?? this.saved,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'saved': saved.toMap(),
    };
  }

  factory SavedArticle.fromMap(Map<String, dynamic> map) {
    return SavedArticle(
      saved: Article.fromMap(map['saved'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedArticle.fromJson(String source) =>
      SavedArticle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SavedArticle(saved: $saved)';

  @override
  bool operator ==(covariant SavedArticle other) {
    if (identical(this, other)) return true;

    return other.saved == saved;
  }

  @override
  int get hashCode => saved.hashCode;
}

import 'package:floor/floor.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import '../../../../core/constants/constants.dart';

@Entity(tableName: 'article', primaryKeys: ['id'])
class ArticleModel extends ArticleEntity {
  const ArticleModel({
    int? id,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
  }) : super(
          id: id,
          author: author,
          title: title,
          description: description,
          url: url,
          urlToImage: urlToImage,
          publishedAt: publishedAt,
          content: content,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> map) {
    return ArticleModel(
      author: map['author'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      url: map['url'] ?? "",
      urlToImage: map['urlToImage'] != null && map['urlToImage'] != ""
          ? map['urlToImage']
          : kDefaultImage,
      publishedAt: map['publishedAt'] ?? "",
      content: map['content'] ?? "",
    );
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
        id: entity.id,
        author: entity.author,
        title: entity.title,
        description: entity.description,
        url: entity.url,
        urlToImage: entity.urlToImage,
        publishedAt: entity.publishedAt,
        content: entity.content);
  }

  // Firestore helpers
  factory ArticleModel.fromFirestore(Map<String, dynamic> map) {
    return ArticleModel(
      author: map['author'] as String? ?? "",
      title: map['title'] as String? ?? "",
      description: map['description'] as String? ?? "",
      url: map['url'] as String? ?? "",
      urlToImage: (map['urlToImage'] as String?) != null &&
              (map['urlToImage'] as String?)!.isNotEmpty
          ? map['urlToImage'] as String
          : kDefaultImage,
      publishedAt: map['publishedAt'] as String? ?? "",
      content: map['content'] as String? ?? "",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'author': author ?? "",
      'title': title ?? "",
      'description': description ?? "",
      'url': url ?? "",
      'urlToImage': urlToImage ?? kDefaultImage,
      'publishedAt': publishedAt ?? "",
      'content': content ?? "",
    };
  }
}

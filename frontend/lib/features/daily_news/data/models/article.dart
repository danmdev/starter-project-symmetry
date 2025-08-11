import 'package:floor/floor.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import '../../../../core/constants/constants.dart';

@Entity(tableName: 'article', primaryKeys: ['id'])
class ArticleModel extends ArticleEntity {
  const ArticleModel({
    super.docId,
    super.id,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> map) {
    String? publishedAtString;
    final publishedAt = map['publishedAt'];
    if (publishedAt is String) {
      publishedAtString = publishedAt;
    } else if (publishedAt != null && publishedAt.toString() != "") {
      // Si es Timestamp de Firestore
      try {
        publishedAtString = publishedAt.toDate().toString();
      } catch (_) {
        publishedAtString = publishedAt.toString();
      }
    } else {
      publishedAtString = "";
    }
    return ArticleModel(
      docId: map['docId'],
      author: map['author'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      url: map['url'] ?? "",
      urlToImage: map['urlToImage'] != null && map['urlToImage'] != ""
          ? map['urlToImage']
          : kDefaultImage,
      publishedAt: publishedAtString,
      content: map['content'] ?? "",
    );
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      docId: entity.docId,
      id: entity.id,
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: (entity.urlToImage != null && entity.urlToImage!.isNotEmpty)
          ? entity.urlToImage
          : kDefaultImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
    );
  }
}

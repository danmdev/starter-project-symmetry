import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/firestore_article_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/firebase_storage_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final FirestoreArticleDataSource _firestoreDataSource;
  final FirebaseStorageDataSource _storageDataSource;

  ArticleRepositoryImpl(this._firestoreDataSource, this._storageDataSource);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final data = await _firestoreDataSource.fetchArticlesOnce();
      return DataSuccess(data);
    } on FirebaseException catch (e) {
      return DataFailed(_firebaseToDioLike(e));
    }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    try {
      return await _firestoreDataSource.fetchSavedArticlesOnce();
    } on FirebaseException {
      return <ArticleModel>[];
    }
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _firestoreDataSource.removeArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _firestoreDataSource.saveArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> createArticle(ArticleEntity article) {
    return _firestoreDataSource.createArticle(ArticleModel.fromEntity(article));
  }

  /// Crea un nuevo artículo con imagen opcional
  Future<void> createArticleWithImage({
    required String title,
    required String description,
    String? imagePath,
  }) async {
    String? imageUrl;

    // Si hay imagen, subirla primero
    if (imagePath != null && imagePath.isNotEmpty) {
      final articleId = DateTime.now().millisecondsSinceEpoch.toString();
      imageUrl = await _storageDataSource.uploadThumbnail(
        articleId: articleId,
        imagePath: imagePath,
      );
    }

    // Crear el artículo
    final article = ArticleEntity(
      title: title,
      description: description,
      content: description, // Usar description como content por simplicidad
      urlToImage: imageUrl,
      publishedAt: DateTime.now().toIso8601String(),
      author: "User", // Por simplicidad, sin auth
      url: "", // Vacío para artículos creados localmente
    );

    await createArticle(article);
  }

  // Adaptación mínima: construimos un objeto parecido a DioError para satisfacer DataFailed actual.
  dynamic _firebaseToDioLike(FirebaseException e) {
    return Exception('FirebaseException(${e.code}): ${e.message}');
  }
}

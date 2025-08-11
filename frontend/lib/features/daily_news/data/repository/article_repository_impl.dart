import 'dart:io';

import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

import '../data_sources/remote/news_api_service.dart';
import '../data_sources/article_firebase_data_source.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  @override
  Future<DataState<void>> updateArticle(ArticleEntity article) async {
    try {
      final model = ArticleModel.fromEntity(article);
      if (model.docId == null) {
        return DataFailed(Exception('No docId para actualizar'));
      }
      await _firebaseDataSource.updateArticle(model.docId!, {
        'author': model.author,
        'title': model.title,
        'description': model.description,
        'url': model.url,
        'urlToImage': model.urlToImage,
        'publishedAt': model.publishedAt,
        'content': model.content,
      });
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }

  final NewsApiService? _newsApiService;
  final AppDatabase _appDatabase;
  final ArticleFirebaseDataSource _firebaseDataSource;

  ArticleRepositoryImpl(
    NewsApiService? newsApiService,
    AppDatabase appDatabase,
    ArticleFirebaseDataSource firebaseDataSource,
  )   : _newsApiService = newsApiService,
        _appDatabase = appDatabase,
        _firebaseDataSource = firebaseDataSource;

  /// Obtiene artículos desde Firestore usando el data source de Firebase
  @override
  Future<DataState<List<ArticleModel>>> getFirestoreArticles() async {
    try {
      final rawList = await _firebaseDataSource.fetchArticles();
      final articles = rawList.map((e) => ArticleModel.fromJson(e)).toList();
      return DataSuccess(articles);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }

  @override
  Future<DataState<void>> publishArticle(ArticleEntity article) async {
    try {
      final model = ArticleModel.fromEntity(article);
      await _firebaseDataSource.publishArticle({
        'author': model.author,
        'title': model.title,
        'description': model.description,
        'url': model.url,
        'urlToImage': model.urlToImage,
        'publishedAt': model.publishedAt,
        'content': model.content,
      });
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    throw UnimplementedError('API deshabilitada, solo Firestore disponible');
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _appDatabase.articleDAO.getArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _appDatabase.articleDAO
        .deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _appDatabase.articleDAO
        .insertArticle(ArticleModel.fromEntity(article));
  }
}

import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/publish_article_repository.dart';

class PublishArticleRepositoryImpl implements PublishArticleRepository {
  final ArticleRepository _articleRepository;
  PublishArticleRepositoryImpl(this._articleRepository);

  @override
  Future<DataState<void>> publishArticle(ArticleEntity article) {
    return _articleRepository.publishArticle(article);
  }
}

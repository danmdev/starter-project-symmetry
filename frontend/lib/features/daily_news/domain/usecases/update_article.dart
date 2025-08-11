import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class UpdateArticleUseCase implements UseCase<DataState<void>, ArticleEntity> {
  final ArticleRepository _repository;
  UpdateArticleUseCase(this._repository);

  @override
  Future<DataState<void>> call({ArticleEntity? params}) {
    if (params == null) {
      throw ArgumentError('params (ArticleEntity) is required');
    }
    return _repository.updateArticle(params);
  }
}

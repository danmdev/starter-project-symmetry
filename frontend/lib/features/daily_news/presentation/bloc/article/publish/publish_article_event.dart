import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class PublishArticleEvent extends Equatable {
  const PublishArticleEvent();

  @override
  List<Object?> get props => [];
}

class SubmitArticleEvent extends PublishArticleEvent {
  final ArticleEntity article;
  const SubmitArticleEvent(this.article);

  @override
  List<Object?> get props => [article];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'publish_article_event.dart';
import 'publish_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/publish_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/update_article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';

class PublishArticleBloc
    extends Bloc<PublishArticleEvent, PublishArticleState> {
  final PublishArticleUseCase publishArticleUseCase;
  final UpdateArticleUseCase updateArticleUseCase;

  PublishArticleBloc({
    required this.publishArticleUseCase,
    required this.updateArticleUseCase,
  }) : super(PublishArticleInitial()) {
    on<SubmitArticleEvent>(_onSubmitArticle);
  }

  Future<void> _onSubmitArticle(
    SubmitArticleEvent event,
    Emitter<PublishArticleState> emit,
  ) async {
    emit(PublishArticleLoading());
    final isEdit =
        event.article.docId != null && event.article.docId!.isNotEmpty;
    final result = isEdit
        ? await updateArticleUseCase(params: event.article)
        : await publishArticleUseCase(params: event.article);
    if (result is DataSuccess) {
      emit(PublishArticleSuccess());
    } else {
      emit(PublishArticleFailure(
          result.error?.toString() ?? 'Error desconocido'));
    }
  }
}

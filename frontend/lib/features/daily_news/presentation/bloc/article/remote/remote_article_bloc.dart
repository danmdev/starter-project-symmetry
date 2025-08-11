import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_firestore_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class RemoteArticlesBloc
    extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetFirestoreArticlesUseCase _getFirestoreArticlesUseCase;

  RemoteArticlesBloc(this._getFirestoreArticlesUseCase)
      : super(const RemoteArticlesLoading()) {
    on<GetFirestoreArticles>(onGetFirestoreArticles);
  }

  void onGetFirestoreArticles(
      GetFirestoreArticles event, Emitter<RemoteArticlesState> emit) async {
    final dataState = await _getFirestoreArticlesUseCase();
    if (dataState is DataSuccess && dataState.data != null) {
      if (dataState.data!.isNotEmpty) {
        emit(RemoteArticlesDone(dataState.data!));
      } else {
        emit(const RemoteArticlesError('No hay artículos en Firestore.'));
      }
    } else if (dataState is DataFailed) {
      emit(RemoteArticlesError(dataState.error!));
    }
  }
}

import 'package:get_it/get_it.dart';
// Eliminado: Dio y NewsApiService
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/article_firebase_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_firestore_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
// Eliminado: GetArticleUseCase
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/publish_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/update_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/publish/publish_article_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  // Solo Firestore como fuente de datos

  // DataSource de Firebase
  sl.registerSingleton<ArticleFirebaseDataSource>(ArticleFirebaseDataSource());

  sl.registerSingleton<ArticleRepository>(
      ArticleRepositoryImpl(null, sl(), sl()));
  // UseCase Firestore
  sl.registerSingleton<GetFirestoreArticlesUseCase>(
      GetFirestoreArticlesUseCase(sl()));

  // Eliminado: GetArticleUseCase

  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));

  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));

  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));

  //Blocs
  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));

  sl.registerFactory<LocalArticleBloc>(
      () => LocalArticleBloc(sl(), sl(), sl()));

  // UseCase y Bloc para publicar artículos
  sl.registerSingleton<PublishArticleUseCase>(PublishArticleUseCase(sl()));
  sl.registerFactory<UpdateArticleUseCase>(() => UpdateArticleUseCase(sl()));
  sl.registerFactory<PublishArticleBloc>(() => PublishArticleBloc(
        publishArticleUseCase: sl(),
        updateArticleUseCase: sl(),
      ));
}

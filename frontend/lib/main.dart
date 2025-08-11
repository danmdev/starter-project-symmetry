import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/daily_news.dart';
import 'config/theme/app_themes.dart';
import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'injection_container.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/publish/publish_article_bloc.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesBloc>(
          create: (context) =>
              sl<RemoteArticlesBloc>()..add(const GetFirestoreArticles()),
        ),
        BlocProvider<PublishArticleBloc>(
          create: (context) => sl<PublishArticleBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        home: const DailyNews(),
      ),
    );
  }
}

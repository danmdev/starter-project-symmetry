import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';

class ArticleDetailsView extends HookWidget {
  void _onEditArticleTapped(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/PublishArticle',
      arguments: article,
    );
  }

  final ArticleEntity? article;

  const ArticleDetailsView({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBackButtonTapped(context),
          child: const Icon(Ionicons.chevron_back, color: Colors.black),
        ),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            tooltip: 'Editar artículo',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/PublishArticle',
                arguments: article,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildArticleTitle(),
          _buildArticleImage(),
          _buildArticleContent(),
        ],
      ),
    );
  }

  Widget _buildArticleTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          article?.title ?? '',
          style: const TextStyle(
              fontFamily: 'Butler', fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    if (article?.urlToImage == null || article!.urlToImage!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.maxFinite,
      height: 250,
      margin: const EdgeInsets.only(top: 14),
      child: Image.network(article!.urlToImage!, fit: BoxFit.cover),
    );
  }

  Widget _buildArticleContent() {
    if (article?.content == null || article!.content!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Text(
        article!.content!,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Builder(
      builder: (context) => FloatingActionButton(
        onPressed: () => _onFloatingActionButtonPressed(context),
        child: const Icon(Ionicons.bookmark, color: Colors.white),
      ),
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onFloatingActionButtonPressed(BuildContext context) {
    BlocProvider.of<LocalArticleBloc>(context).add(SaveArticle(article!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.black,
        content: Text('Article saved successfully.'),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/article.dart';

/// Data Source remoto para artículos usando Cloud Firestore.
/// Único punto que interactúa con Firebase en esta feature.
class FirestoreArticleDataSource {
  FirestoreArticleDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _articlesCol =>
      _firestore.collection('articles');

  CollectionReference<Map<String, dynamic>> get _savedArticlesCol =>
      _firestore.collection('saved_articles');

  Future<List<ArticleModel>> fetchArticlesOnce() async {
    final snap =
        await _articlesCol.orderBy('publishedAt', descending: true).get();
    return snap.docs
        .map((d) => ArticleModel.fromFirestore(d.data()))
        .toList(growable: false);
  }

  Future<List<ArticleModel>> fetchSavedArticlesOnce() async {
    final snap =
        await _savedArticlesCol.orderBy('publishedAt', descending: true).get();
    return snap.docs
        .map((d) => ArticleModel.fromFirestore(d.data()))
        .toList(growable: false);
  }

  Future<void> saveArticle(ArticleModel article) async {
    final docId = _docIdFor(article);
    await _savedArticlesCol.doc(docId).set(article.toFirestore());
  }

  Future<void> removeArticle(ArticleModel article) async {
    final docId = _docIdFor(article);
    await _savedArticlesCol.doc(docId).delete();
  }

  /// Crea un nuevo artículo en la colección principal
  Future<void> createArticle(ArticleModel article) async {
    await _articlesCol.add(article.toFirestore());
  }

  String _docIdFor(ArticleModel a) {
    String key = '';
    if ((a.url ?? '').trim().isNotEmpty) {
      key = a.url!.trim();
    } else if ((a.title ?? '').trim().isNotEmpty) {
      key = a.title!.trim();
    } else if ((a.publishedAt ?? '').trim().isNotEmpty) {
      key = a.publishedAt!.trim();
    } else {
      // Como último recurso, genera uno estable por contenido
      key = '${a.author}-${a.content}'.trim();
    }
    // hashCode como ID determinístico simple
    return key.hashCode.abs().toString();
  }
}

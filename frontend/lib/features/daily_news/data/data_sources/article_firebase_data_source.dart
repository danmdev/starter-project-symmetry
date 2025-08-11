import 'package:cloud_firestore/cloud_firestore.dart';

/// Data source que se conecta a Firebase Firestore para obtener artículos.
class ArticleFirebaseDataSource {
  final FirebaseFirestore firestore;

  ArticleFirebaseDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final querySnapshot = await firestore.collection('articles').get();
    final docs = querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id;
      return data;
    }).toList();
    return docs;
  }

  /// Actualiza un artículo existente en Firestore
  Future<void> updateArticle(
      String docId, Map<String, dynamic> articleData) async {
    await firestore.collection('articles').doc(docId).update(articleData);
  }

  /// Publica un nuevo artículo en la colección 'articles' en Firestore.
  Future<void> publishArticle(Map<String, dynamic> articleData) async {
    await firestore.collection('articles').add(articleData);
  }
}

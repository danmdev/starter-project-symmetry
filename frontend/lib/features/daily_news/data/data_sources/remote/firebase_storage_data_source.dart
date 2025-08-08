import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Data Source remoto para subir archivos usando Firebase Storage.
/// Único punto que interactúa con Firebase Storage en esta feature.
class FirebaseStorageDataSource {
  FirebaseStorageDataSource(this._storage);

  final FirebaseStorage _storage;

  /// Sube una imagen thumbnail y retorna el download URL
  Future<String> uploadThumbnail({
    required String articleId,
    required String imagePath,
  }) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    final extension = imagePath.split('.').last.toLowerCase();

    // Crear referencia con path único
    final ref = _storage.ref().child('thumbnails/${articleId}.$extension');

    // Subir archivo con metadata apropiado
    final metadata = SettableMetadata(
      contentType: _getContentType(extension),
      customMetadata: {
        'articleId': articleId,
        'uploadedAt': DateTime.now().toIso8601String(),
      },
    );

    // Realizar upload
    final uploadTask = ref.putData(bytes, metadata);
    final snapshot = await uploadTask;

    // Obtener download URL
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  String _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}

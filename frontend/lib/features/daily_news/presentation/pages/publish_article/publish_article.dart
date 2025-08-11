// genera la plantilla basica:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/publish/publish_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/publish/publish_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/publish/publish_article_state.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class PublishArticle extends StatefulWidget {
  final ArticleEntity? article;
  const PublishArticle({super.key, this.article});

  @override
  State<PublishArticle> createState() => _PublishArticleState();
}

class _PublishArticleState extends State<PublishArticle> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  File? _selectedImage;
  ArticleEntity? _editingArticle;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _editingArticle = widget.article;
      _titleController.text = widget.article?.title ?? '';
      _descriptionController.text = widget.article?.description ?? '';
      _contentController.text = widget.article?.content ?? '';
      // No pre-cargamos imagen local, solo preview de red
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String? imageUrl = _editingArticle?.urlToImage;
      try {
        if (_selectedImage != null) {
          final fileName = path.basename(_selectedImage!.path);
          final ref =
              FirebaseStorage.instance.ref().child('articles/$fileName');
          final uploadTask = await ref.putFile(
            _selectedImage!,
            SettableMetadata(contentType: 'image/jpeg'),
          );
          imageUrl = await uploadTask.ref.getDownloadURL();
        }
        final article = ArticleEntity(
          title: _titleController.text,
          description: _descriptionController.text,
          content: _contentController.text,
          urlToImage: imageUrl ?? '',
          publishedAt:
              _editingArticle?.publishedAt ?? DateTime.now().toIso8601String(),
        );
        // ignore: use_build_context_synchronously
        context.read<PublishArticleBloc>().add(SubmitArticleEvent(article));
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error to publish article: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_editingArticle == null ? 'Publish Article' : 'Edit Article'),
      ),
      body: BlocConsumer<PublishArticleBloc, PublishArticleState>(
        listener: (context, state) {
          if (state is PublishArticleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(_editingArticle == null
                      ? 'Article published successfully'
                      : 'Article updated successfully')),
            );
            Navigator.pop(context, true); // <- Regresa true para recargar lista
          } else if (state is PublishArticleFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Field required' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(labelText: 'Content'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: Text(_editingArticle == null
                            ? 'Select Image'
                            : 'Change Image'),
                      ),
                      const SizedBox(width: 12),
                      if (_selectedImage != null)
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                Image.file(_selectedImage!, fit: BoxFit.cover),
                          ),
                        )
                      else if (_editingArticle?.urlToImage != null &&
                          _editingArticle!.urlToImage!.isNotEmpty)
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(_editingArticle!.urlToImage!,
                                fit: BoxFit.cover),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  state is PublishArticleLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: state is PublishArticleLoading
                              ? null
                              : () => _submit(context),
                          child: Text(
                              _editingArticle == null ? 'Publish' : 'Update'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  String? _selectedImagePath;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocalArticleBloc(sl(), sl(), sl()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Published new article'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () => _onImageTapped(context),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(122, 247, 244, 244),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(82, 158, 158, 158),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          _selectedImagePath == null
                              ? 'Tap to add an image'
                              : _selectedImagePath!.split('/').last,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 150, 148, 148),
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Image picker button
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 16),
                // boton
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _handleArticleSubmission();
                    },
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Publish article'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleArticleSubmission() async {
    // Recolectar todos los valores
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String? imagePath = _selectedImagePath;

    // Validaciones básicas
    if (title.isEmpty) {
      _showSnackBar('Please enter a title');
      return;
    }

    if (description.isEmpty) {
      _showSnackBar('Please enter a description');
      return;
    }

    try {
      _showSnackBar('Publishing article...');

      // Obtener el repositorio desde DI y crear el artículo
      final repository = sl<ArticleRepositoryImpl>();
      await repository.createArticleWithImage(
        title: title,
        description: description,
        imagePath: imagePath,
      );

      _showSnackBar('Article published successfully!');

      // Limpiar el formulario
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedImagePath = null;
      });

      // Opcional: navegar de vuelta
      // Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar('Error publishing article: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onImageTapped(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 70,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _selectedImagePath = image.path;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

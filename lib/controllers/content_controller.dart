import 'package:flutter/material.dart';
import '../models/content_model.dart';

class ContentController extends ChangeNotifier {
  List<ContentModel> _contents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ContentModel> get contents => _contents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadContents() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _contents = [
      ContentModel(
        id: '1',
        title: 'How to Water Your Trees',
        description: 'Learn the best practices for watering trees',
        content: 'Detailed content about watering trees...',
        category: 'Care Tips',
        createdAt: DateTime.now(),
      ),
      ContentModel(
        id: '2',
        title: 'Seasonal Tree Care',
        description: 'Understanding seasonal needs of your trees',
        content: 'Detailed content about seasonal care...',
        category: 'Guides',
        createdAt: DateTime.now(),
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
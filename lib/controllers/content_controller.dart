import 'package:flutter/material.dart';
import '../models/content_model.dart';
import '../data/static_data.dart';

class ContentController extends ChangeNotifier {
  List<ContentModel> _contents = [];
  bool _isLoading = false;
  String _searchQuery = '';
  ContentCategory? _selectedCategory;

  List<ContentModel> get contents {
    var filtered = _contents;

    if (_selectedCategory != null) {
      filtered = filtered.where((c) => c.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((c) =>
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  List<ContentModel> get featuredContents =>
      _contents.where((c) => c.isFeatured).toList();

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  ContentCategory? get selectedCategory => _selectedCategory;

  Future<void> loadContents() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _contents = StaticData.sampleContents;

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(ContentCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  ContentModel? getContentById(String id) {
    try {
      return _contents.firstWhere((content) => content.id == id);
    } catch (e) {
      return null;
    }
  }
}
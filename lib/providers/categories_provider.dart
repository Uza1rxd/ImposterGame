import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/category.dart' as models;

class CategoriesProvider extends ChangeNotifier {
  List<models.Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<models.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String jsonString = await rootBundle.loadString('assets/categories.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      _categories = jsonList.map((json) => models.Category.fromJson(json)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load categories: $e';
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  models.Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/cat.dart';
import '../../domain/usecases/get_cat_images.dart';

class CatViewModel extends ChangeNotifier {
  final GetCatImages getCatImages;

  List<Cat> _cats = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 0;
  final int _pageSize = 20;

  CatViewModel({required this.getCatImages});

  // Getters
  List<Cat> get cats => _cats;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadCats({bool reset = false}) async {
    if (reset) {
      _currentPage = 0;
      _cats = [];
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final newCats = await getCatImages(
        limit: _pageSize,
        page: _currentPage,
      );

      if (reset) {
        _cats = newCats;
      } else {
        _cats.addAll(newCats);
      }

      _currentPage++;
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreCats() async {
    await loadCats(reset: false);
  }

  Future<void> refreshCats() async {
    await loadCats(reset: true);
  }
}

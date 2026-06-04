import 'package:flutter/material.dart';
import '../../domain/entities/cat.dart';
import '../../domain/usecases/get_marvel.dart';

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
      print('DEBUG: Loading page $_currentPage');
      final newCats = await getCatImages(
        limit: _pageSize,
        page: _currentPage,
      );

      print('DEBUG: Received ${newCats.length} cats');
      for (int i = 0; i < newCats.length; i++) {
        print('DEBUG: Cat $i - ID: ${newCats[i].id}, URL: ${newCats[i].url}');
      }

      if (reset) {
        _cats = newCats;
      } else {
        _cats.addAll(newCats);
      }

      _currentPage++;
      print('DEBUG: Total cats now: ${_cats.length}, Next page will be: $_currentPage');
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      print('DEBUG: Error - $e');
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

import '../datasource/cat_datasource.dart';
import '../../domain/entities/cat.dart';

class CatRepository {
  final CatDatasource datasource;

  CatRepository({required this.datasource});

  Future<List<Cat>> getCats({int limit = 20, int page = 0}) async {
    final models = await datasource.getCats(limit: limit, page: page);
    return models.cast<Cat>();
  }
}

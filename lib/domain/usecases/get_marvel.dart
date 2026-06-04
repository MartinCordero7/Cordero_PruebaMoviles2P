import '../entities/cat.dart';
import '../../data/repositories/marvel_repositories.dart';

class GetCatImages {
  final CatRepository repository;

  GetCatImages({required this.repository});

  Future<List<Cat>> call({int limit = 20, int page = 0}) {
    return repository.getCats(limit: limit, page: page);
  }
}

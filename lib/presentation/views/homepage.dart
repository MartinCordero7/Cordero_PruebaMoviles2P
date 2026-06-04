import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/marvel_viewmodel.dart';
import '../../domain/entities/cat.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Cargar gatos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatViewModel>().loadCats();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<CatViewModel>().loadMoreCats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gatos Bonitos'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CatViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.cats.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.errorMessage.isNotEmpty &&
              viewModel.cats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.errorMessage),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.refreshCats();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.cats.isEmpty) {
            return const Center(
              child: Text('No hay gatos disponibles'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refreshCats(),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: viewModel.cats.length +
                  (viewModel.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == viewModel.cats.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final cat = viewModel.cats[index];
                return CatCard(cat: cat);
              },
            ),
          );
        },
      ),
    );
  }
}

class CatCard extends StatelessWidget {
  final Cat cat;

  const CatCard({
    super.key,
    required this.cat,
  });

  String _getImageUrl() {
    if (!kIsWeb) return cat.url;

    final source = cat.url;
    if (source.startsWith('https://')) {
      return 'https://images.weserv.nl/?url=${Uri.encodeComponent(source.replaceFirst('https://', ''))}';
    }
    if (source.startsWith('http://')) {
      return 'https://images.weserv.nl/?url=${Uri.encodeComponent(source.replaceFirst('http://', ''))}';
    }
    return source;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getImageUrl();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Container(
                color: Colors.grey[300],
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.breeds.isNotEmpty ? cat.breeds.first : 'Gato desconocido',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${cat.width} × ${cat.height}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                if (cat.breeds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${cat.breeds.length} raza(s)',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

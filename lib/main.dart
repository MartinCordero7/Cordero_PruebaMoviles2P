import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/viewmodels/cat_viewmodel.dart';
import 'domain/usecases/get_cat_images.dart';
import 'data/repositories/cat_repository.dart';
import 'data/datasource/cat_datasource.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CatDatasource>(
          create: (_) => CatDatasource(),
        ),
        Provider<CatRepository>(
          create: (context) => CatRepository(
            datasource: context.read<CatDatasource>(),
          ),
        ),
        Provider<GetCatImages>(
          create: (context) => GetCatImages(
            repository: context.read<CatRepository>(),
          ),
        ),
        ChangeNotifierProvider<CatViewModel>(
          create: (context) => CatViewModel(
            getCatImages: context.read<GetCatImages>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Gatos Bonitos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.home,
      ),
    );
  }
}

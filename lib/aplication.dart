import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stories_admin/config/UI/app_theme.dart';
import 'package:stories_admin/config/router/router.dart';
import 'package:stories_admin/presentation/screen/categories/bloc/categories_bloc.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/category_repository.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class Aplication extends StatelessWidget {
  const Aplication({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryRepository = diStoriesData<CategoryRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CategoriesBloc(categoryRepository)..add(CategoriesInitial()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru'),
        ],
      ),
    );
  }
}

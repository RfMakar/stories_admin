import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stories_admin/config/UI/app_theme.dart';
import 'package:stories_admin/config/router/router.dart';
import 'package:stories_admin/presentation/screens/categories/bloc/categories_bloc.dart';
import 'package:stories_admin/presentation/screens/stories/bloc/stories_bloc.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/category_repository.dart';
import 'package:stories_data/repositories/story_repository.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryRepository = diStoriesData<CategoryRepository>();
    final storyRepository = diStoriesData<StoryRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesBloc(categoryRepository)
            ..add(const CategoriesInitial()),
        ),
        BlocProvider(
          create: (context) =>
              StoriesBloc(storyRepository)..add(const StoriesInitial()),
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

import 'package:go_router/go_router.dart';
import 'package:stories_admin/config/router/routers.dart';
import 'package:stories_admin/presentation/screens/categories/categories_screen.dart';
import 'package:stories_admin/presentation/screens/categories_types/categories_types_screen.dart';
import 'package:stories_admin/presentation/screens/category_create/category_create_screen.dart';
import 'package:stories_admin/presentation/screens/category_type_create/category_type_create_screen.dart';
import 'package:stories_admin/presentation/screens/category_type_update/category_type_update_screen.dart';
import 'package:stories_admin/presentation/screens/category_update/category_update_screen.dart';
import 'package:stories_admin/presentation/screens/home/home_screen.dart';
import 'package:stories_admin/presentation/screens/stories/stories_screen.dart';
import 'package:stories_admin/presentation/screens/story/story_screen.dart';
import 'package:stories_admin/presentation/screens/story_create/story_create_screen.dart';
import 'package:stories_admin/presentation/screens/story_update/story_update_screen.dart';
import 'package:stories_data/models/index.dart';

final router = GoRouter(
  initialLocation: Routers.pathHomeScreen,
  routes: [
    GoRoute(
      path: Routers.pathHomeScreen,
      name: Routers.pathHomeScreen,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: Routers.pathCategoriesScreen,
      name: Routers.pathCategoriesScreen,
      builder: (context, state) => const CategoriesScreen(),
      routes: [
        GoRoute(
          path: Routers.pathCategoryCreateScreen,
          name: Routers.pathCategoryCreateScreen,
          builder: (context, state) => const CategoryCreateScreen(),
        ),
        GoRoute(
          path: Routers.pathCategoryUpdateScreen,
          name: Routers.pathCategoryUpdateScreen,
          builder: (context, state) {
            final categoryId = state.extra as String;
            return CategoryUpdateScreen(
              categoryId: categoryId,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: Routers.pathCategoriesTypesScreen,
      name: Routers.pathCategoriesTypesScreen,
      builder: (context, state) => const CategoriesTypesScreen(),
      routes: [
        GoRoute(
          path: Routers.pathCategoryTypeCreateScreen,
          name: Routers.pathCategoryTypeCreateScreen,
          builder: (context, state) => const CategoryTypeCreateScreen(),
        ),
        GoRoute(
          path: Routers.pathCategoryTypeUpdateScreen,
          name: Routers.pathCategoryTypeUpdateScreen,
          builder: (context, state) {
            final typeId = state.extra as String;
            return CategoryTypeUpdateScreen(
              typeId: typeId,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: Routers.pathStoriesScreen,
      name: Routers.pathStoriesScreen,
      builder: (context, state) => const StoriesScreen(),
      routes: [
        GoRoute(
          path: Routers.pathStoryCreateScreen,
          name: Routers.pathStoryCreateScreen,
          builder: (context, state) => const StoryCreateScreen(),
        ),
        GoRoute(
          path: Routers.pathStoryUpdateScreen,
          name: Routers.pathStoryUpdateScreen,
          builder: (context, state) {
            final storyId = state.extra as String;
            return StoryUpdateScreen(storyId: storyId);
          },
        ),
        GoRoute(
          path: Routers.pathStoryScreen,
          name: Routers.pathStoryScreen,
          builder: (context, state) {
            final story = state.extra as StoryModel;
            return StoryScreen(story: story);
          },
        ),
      ],
    ),
  ],
);

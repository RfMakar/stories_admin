import 'package:go_router/go_router.dart';
import 'package:stories_admin/config/router/routers.dart';
import 'package:stories_admin/presentation/screen/categories/categories_screen.dart';
import 'package:stories_admin/presentation/screen/category_create/category_create_screen.dart';
import 'package:stories_admin/presentation/screen/category_update/category_update_screen.dart';
import 'package:stories_admin/presentation/screen/home/home_screen.dart';
import 'package:stories_admin/presentation/screen/stories/stories_screen.dart';
import 'package:stories_admin/presentation/screen/story_create/story_create_screen.dart';
import 'package:stories_admin/presentation/screen/story_update/story_update_screen.dart';

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
      ],
    ),
  ],
);

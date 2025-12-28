import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/config/UI/app_assets.dart';
import 'package:stories_admin/config/UI/app_colors.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/config/router/routers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Админ панель'),
      ),
      body: const HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16
      ),
      children: [
        CategoryIconWidget(
          name: 'Типы категорий',
          onTap: () => context.pushNamed(Routers.pathCategoriesTypesScreen),
        ),
        CategoryIconWidget(
          name: 'Категории',
          onTap: () => context.pushNamed(Routers.pathCategoriesScreen),
        ),
        CategoryIconWidget(
          name: 'Сказки',
          onTap: () => context.pushNamed(Routers.pathStoriesScreen),
        ),
        CategoryIconWidget(
          name: 'Статистика',
          onTap: () => context.pushNamed(Routers.pathStatsScreen),
        ),
      ],
    );
  }
}

class CategoryIconWidget extends StatelessWidget {
  const CategoryIconWidget({
    super.key,
    required this.name,
    required this.onTap,
  });
  final String name;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.hexE7E7E7,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              spacing: 16,
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    height: double.infinity,
                    AppAssets.iconFolder,
                    colorFilter: ColorFilter.mode(
                      AppColors.hex5F3430,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  name,
                  style: AppTextStyles.s18h000000n,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

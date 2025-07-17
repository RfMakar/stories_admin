import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/application.dart';
import 'package:stories_admin/config/UI/app_assets.dart';
import 'package:stories_admin/config/UI/app_colors.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/config/router/routers.dart';
import 'package:stories_admin/presentation/bottom_sheet/sheet_delete.dart';
import 'package:stories_admin/presentation/screens/categories/bloc/categories_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_data/models/category_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        // actions: [
        //   IconButton(
        //     // onPressed: null,
        //     onPressed: () => context.read<CategoriesBloc>().add(
        //           CategoriesDeleteAll(),
        //         ),
        //     icon: SvgPicture.asset(AppAssets.iconDelete),
        //   ),
        //   IconButton(
        //     onPressed: null,
        //     icon: SvgPicture.asset(AppAssets.iconSearch),
        //   ),
        // ],
      ),
      body: BlocConsumer<CategoriesBloc, CategoriesState>(
        listener: (context, state) {
          if (state.status == CategoriesStatus.failure) {
            rootScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(state.exception?.message ?? ""),
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          if (current.status == CategoriesStatus.failure) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          switch (state.status) {
            case CategoriesStatus.initial:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            case CategoriesStatus.success:
              return const CategoriesScreenBody();
            case CategoriesStatus.failure:
              return Center(
                child: Text(
                  state.exception?.message ?? "",
                ),
              );
          }
        },
      ),
    );
  }
}

class CategoriesScreenBody extends StatelessWidget {
  const CategoriesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoriesBloc, CategoriesState, List<CategoryModel>>(
      selector: (state) {
        return state.categories;
      },
      builder: (context, categories) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryWidget(
                  key: ValueKey(category.id),
                  category: category,
                );
              },
            ),
           const ButtonAddCategory(),
          ],
        );
      },
    );
  }
}

class ButtonAddCategory extends StatelessWidget {
  const ButtonAddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      child: Text(
        'Создать категорию',
        style: AppTextStyles.s16hFFFFFFn,
      ),
      onTap: () => context.pushNamed(
        Routers.pathCategoryCreateScreen,
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.hexE7E7E7,
        ),
      ),
      child: Row(
        spacing: 8,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(16),
            child: CachedNetworkImage(
              imageUrl: category.iconUrl,
              height: 104,
              width: 104,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  category.name,
                  style: AppTextStyles.s14h000000n,
                ),
                Text(
                  category.id,
                  style: AppTextStyles.s12hE7E7E7n,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pushNamed(
                          Routers.pathCategoryUpdateScreen,
                          extra: category.id,
                        );
                      },
                      icon: SvgPicture.asset(
                        AppAssets.iconEdit,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        deleteAction() {
                          context.read<CategoriesBloc>().add(
                                CategoriesDelete(categoryId: category.id),
                              );
                        }

                        final isResult =
                            await showDeleteBottomSheet(context: context);

                        if (isResult == true) {
                          deleteAction();
                        }
                      },
                      icon: SvgPicture.asset(
                        AppAssets.iconDelete,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

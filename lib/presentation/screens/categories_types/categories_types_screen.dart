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
import 'package:stories_admin/presentation/screens/categories_types/bloc/categories_types_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_data/models/category_type_model.dart';

class CategoriesTypesScreen extends StatelessWidget {
  const CategoriesTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Типы категории'),
        // actions: [
        //   IconButton(
        //     // onPressed: null,
        //     onPressed: () => context.read<CategoriesTypesBloc>().add(
        //           const CategoriesTypesDeleteAll(),
        //         ),
        //     icon: SvgPicture.asset(AppAssets.iconDelete),
        //   ),
        //   IconButton(
        //     onPressed: null,
        //     icon: SvgPicture.asset(AppAssets.iconSearch),
        //   ),
        // ],
      ),
      body: BlocConsumer<CategoriesTypesBloc, CategoriesTypesState>(
        listener: (context, state) {
          if (state.status == CategoriesTypesStatus.failure) {
            rootScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(state.exception?.message ?? ""),
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          if (current.status == CategoriesTypesStatus.failure) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          switch (state.status) {
            case CategoriesTypesStatus.initial:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            case CategoriesTypesStatus.success:
              return const CategoriesTypesScreenBody();
            case CategoriesTypesStatus.failure:
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

class CategoriesTypesScreenBody extends StatelessWidget {
  const CategoriesTypesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoriesTypesBloc, CategoriesTypesState,
        List<CategoryTypeModel>>(
      selector: (state) {
        return state.categoriesTypes;
      },
      builder: (context, categoriesTypes) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: categoriesTypes.length,
              itemBuilder: (context, index) {
                final categoryType = categoriesTypes[index];
                return CategoryTypeWidget(
                  key: ValueKey(categoryType.id),
                  categoryType: categoryType,
                );
              },
            ),
            const ButtonAddCategoryType(),
          ],
        );
      },
    );
  }
}

class ButtonAddCategoryType extends StatelessWidget {
  const ButtonAddCategoryType({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      child: Text(
        'Создать тип категории',
        style: AppTextStyles.s16hFFFFFFn,
      ),
      onTap: () => context.pushNamed(
        Routers.pathCategoryTypeCreateScreen,
      ),
    );
  }
}

class CategoryTypeWidget extends StatelessWidget {
  const CategoryTypeWidget({super.key, required this.categoryType});
  final CategoryTypeModel categoryType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.hexE7E7E7,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categoryType.name,
            style: AppTextStyles.s14h000000n,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  context.pushNamed(
                    Routers.pathCategoryTypeUpdateScreen,
                    extra: categoryType.id,
                  );
                },
                icon: SvgPicture.asset(
                  AppAssets.iconEdit,
                ),
              ),
              IconButton(
                onPressed: () async {
                  deleteAction() {
                    context.read<CategoriesTypesBloc>().add(
                          CategoriesTypesDelete(typeId: categoryType.id),
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
          ),
        ],
      ),
    );
  }
}

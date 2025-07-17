import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/application.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screens/categories/bloc/categories_bloc.dart';
import 'package:stories_admin/presentation/screens/category_update/bloc/category_update_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_admin/presentation/widgets/select_icon_storage.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/category_repository.dart';

class CategoryUpdateScreen extends StatelessWidget {
  const CategoryUpdateScreen({super.key, required this.categoryId});
  final String categoryId;
  @override
  Widget build(BuildContext context) {
    final categoryRepository = diStoriesData<CategoryRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обновить категорию'),
      ),
      body: BlocProvider(
        create: (context) => CategoryUpdateBloc(categoryRepository)
          ..add(
            CategoryUpdateInitial(
              categoryId: categoryId,
            ),
          ),
        child: BlocConsumer<CategoryUpdateBloc, CategoryUpdateState>(
          listener: (context, state) {
            if (state.status == CategoryUpdateStatus.update) {
              //Изменениz в листе категорий
              context.read<CategoriesBloc>().add(CategoriesUpdate(
                    categoryModel: state.updateCategoryModel!,
                  ));
              context.pop();
            }
            if (state.status == CategoryUpdateStatus.failure) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.exception?.message ?? ""),
                ),
              );
            }
            if (state.isValidateData) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('Нет данных для обновления'),
                ),
              );
            }
          },
          buildWhen: (previous, current) {
            if (current.status == CategoryUpdateStatus.update) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            switch (state.status) {
              case CategoryUpdateStatus.initial:
              case CategoryUpdateStatus.update:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case CategoryUpdateStatus.success:
                return const CategoryUpdateScreenBody();
              case CategoryUpdateStatus.failure:
                return Center(
                  child: Text(
                    state.exception?.message ?? "",
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class CategoryUpdateScreenBody extends StatelessWidget {
  const CategoryUpdateScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CategoryUpdateBloc>();
    return SingleChildScrollView(
      child: Column(
        children: [
          const SelectIconCategory(),
          AppTextField(
            initialValue: bloc.state.categoryModel?.name,
            name: 'Name',
            hintText: 'Имя категории',
            onChanged: (name) {
              bloc.add(CategoryUpdateName(name: name));
            },
          ),
          const ButtonCategoryUpdate(),
        ],
      ),
    );
  }
}

class SelectIconCategory extends StatelessWidget {
  const SelectIconCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CategoryUpdateBloc>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectIconStorageWidget(
        icon: bloc.state.categoryModel?.iconUrl,
        onPatchIcon: (icon) {
          if (icon != null) {
            bloc.add(CategoryUpdateIcon(icon: icon));
          }
        },
      ),
    );
  }
}

class ButtonCategoryUpdate extends StatelessWidget {
  const ButtonCategoryUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryUpdateBloc, CategoryUpdateState>(
      builder: (context, state) {
        return AppButton(
          onTap: state.isSubmitting
              ? null
              : () => context.read<CategoryUpdateBloc>().add(
                    const CategoryUpdate(),
                  ),
          child: state.isSubmitting
              ? const CircularProgressIndicator()
              : Text(
                  'Обновить',
                  style: AppTextStyles.s16hFFFFFFn,
                ),
        );
      },
    );
  }
}

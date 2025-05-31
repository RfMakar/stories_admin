import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/aplication.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screen/categories/bloc/categories_bloc.dart';
import 'package:stories_admin/presentation/screen/category_update/bloc/category_update_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_admin/presentation/widgets/select_image_stotage.dart';
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
        title: Text('Обновить категорию'),
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
                SnackBar(
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
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case CategoryUpdateStatus.success:
                return CategoryUpdateScreenBody();
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
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        SelectIconCategory(),
        AppTextField(
          initialValue: bloc.state.categoryModel?.name,
          name: 'Name',
          hintText: 'Имя категории',
          onChanged: (name) {
            bloc.add(CategoryUpdateName(name: name));
          },
        ),
        ButtonCategoryUpdate(),
      ],
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
      child: SelectImageStorageWidget(
        image: bloc.state.categoryModel?.iconUrl,
        onPatchImage: (icon) {
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
                    CategoryUpdate(),
                  ),
          child: state.isSubmitting
              ? CircularProgressIndicator()
              : Text(
                  'Обновить',
                  style: AppTextStyles.s16hFFFFFFn,
                ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/aplication.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screen/categories/bloc/categories_bloc.dart';
import 'package:stories_admin/presentation/screen/category_create/bloc/category_create_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_admin/presentation/widgets/select_image_stotage.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/category_repository.dart';

class CategoryCreateScreen extends StatelessWidget {
  const CategoryCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryRepository = diStoriesData<CategoryRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create category'),
      ),
      body: BlocProvider(
        create: (context) => CategoryCreateBloc(categoryRepository),
        child: BlocConsumer<CategoryCreateBloc, CategoryCreateState>(
          listener: (context, state) {
            if (state.status == CategoryCreateStatus.success) {
              //Добавление в лист категорий
              context.read<CategoriesBloc>().add(CategoriesAdd(
                    categoryModel: state.categoryModel!,
                  ));
              context.pop();
            }
            if (state.status == CategoryCreateStatus.failure) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.exception?.message ?? ""),
                ),
              );
            }
            if (state.isValidateData) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text('Заполните все данные'),
                ),
              );
            }
          },
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            return CategoryCreateScreenBody();
          },
        ),
      ),
    );
  }
}

class CategoryCreateScreenBody extends StatelessWidget {
  const CategoryCreateScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SelectIconCategory(),
        AppTextField(
          name: 'Name',
          hintText: 'Имя категории',
          onChanged: (name) {
            context.read<CategoryCreateBloc>().add(
                  CategoryCreateName(
                    name: name,
                  ),
                );
          },
        ),
        ButtonCategoryCreate(),
      ],
    );
  }
}

class SelectIconCategory extends StatelessWidget {
  const SelectIconCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectImageStorageWidget(
        image: null,
        onPatchImage: (icon) {
          if (icon != null) {
            context.read<CategoryCreateBloc>().add(
                  CategoryCreateIcon(
                    icon: icon,
                  ),
                );
          }
        },
      ),
    );
  }
}

class ButtonCategoryCreate extends StatelessWidget {
  const ButtonCategoryCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCreateBloc, CategoryCreateState>(
      builder: (context, state) {
        return AppButton(
          onTap: state.isSubmitting
              ? null
              : () => context.read<CategoryCreateBloc>().add(
                    CategoryCreate(),
                  ),
          child: state.isSubmitting
              ? CircularProgressIndicator()
              : Text(
                  'Создать',
                  style: AppTextStyles.s16hFFFFFFn,
                ),
        );
        // return TextButton(
        //   onPressed: state.isSubmitting
        //       ? null
        //       : () => context.read<CategoryCreateBloc>().add(
        //             CategoryCreate(),
        //           ),
        //   child: state.isSubmitting
        //       ? CircularProgressIndicator()
        //       : Text('Создать'),
        // );
      },
    );
  }
}

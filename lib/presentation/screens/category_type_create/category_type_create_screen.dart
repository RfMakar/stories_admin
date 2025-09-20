import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/application.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screens/categories_types/bloc/categories_types_bloc.dart';
import 'package:stories_admin/presentation/screens/category_type_create/bloc/category_type_create_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/category_type_repository.dart';

class CategoryTypeCreateScreen extends StatelessWidget {
  const CategoryTypeCreateScreen({super.key});

   @override
  Widget build(BuildContext context) {
    final categoryTypeRepository = diStoriesData<CategoryTypeRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать тип категории'),
      ),
      body: BlocProvider(
        create: (context) => CategoryTypeCreateBloc(categoryTypeRepository),
        child: BlocConsumer<CategoryTypeCreateBloc, CategoryTypeCreateState>(
          listener: (context, state) {
            if (state.status == CategoryTypeCreateStatus.success) {
              //Добавление в лист типов категорий
              context.read<CategoriesTypesBloc>().add(CategoriesTypesAdd(
                    categoryTypeModel: state.categoryTypeModel!,
                  ));
              context.pop();
            }
            if (state.status == CategoryTypeCreateStatus.failure) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.exception?.message ?? ""),
                ),
              );
            }
            if (state.isValidateData) {
              rootScaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('Заполните все данные'),
                ),
              );
            }
          },
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            return const CategoryTypeCreateScreenBody();
          },
        ),
      ),
    );
  }
}

class CategoryTypeCreateScreenBody extends StatelessWidget {
  const CategoryTypeCreateScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppTextField(
            name: 'Name',
            hintText: 'Имя типа категории',
            onChanged: (name) {
              context.read<CategoryTypeCreateBloc>().add(
                    CategoryTypeCreateName(
                      name: name,
                    ),
                  );
            },
          ),
          const ButtonCategoryTypeCreate(),
        ],
      ),
    );
  }
}

class ButtonCategoryTypeCreate extends StatelessWidget {
  const ButtonCategoryTypeCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryTypeCreateBloc, CategoryTypeCreateState>(
      builder: (context, state) {
        return AppButton(
          onTap: state.isSubmitting
              ? null
              : () => context.read<CategoryTypeCreateBloc>().add(
                    const CategoryTypeCreate(),
                  ),
          child: state.isSubmitting
              ? const CircularProgressIndicator()
              : Text(
                  'Создать',
                  style: AppTextStyles.s16hFFFFFFn,
                ),
        );
      },
    );
  }
}

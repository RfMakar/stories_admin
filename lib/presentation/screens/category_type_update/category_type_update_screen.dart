import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/application.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';
import 'package:stories_admin/presentation/screens/categories_types/bloc/categories_types_bloc.dart';
import 'package:stories_admin/presentation/screens/category_type_update/bloc/category_type_update_bloc.dart';
import 'package:stories_admin/presentation/widgets/app_button.dart';
import 'package:stories_admin/presentation/widgets/app_text_field.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/category_type_repository.dart';

class CategoryTypeUpdateScreen extends StatelessWidget {
  const CategoryTypeUpdateScreen({super.key, required this.typeId});
  final String typeId;
  @override
  Widget build(BuildContext context) {
    final categoryTypeRepository = diStoriesData<CategoryTypeRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обновить тип категории'),
      ),
      body: BlocProvider(
        create: (context) => CategoryTypeUpdateBloc(categoryTypeRepository)
          ..add(
            CategoryTypeUpdateInitial(
              typeId: typeId,
            ),
          ),
        child: BlocConsumer<CategoryTypeUpdateBloc, CategoryTypeUpdateState>(
          listener: (context, state) {
            if (state.status == CategoryTypeUpdateStatus.update) {
              //Изменения в листе типов категорий
              context.read<CategoriesTypesBloc>().add(CategoriesTypesUpdate(
                    categoryTypeModel: state.updateCategoryTypeModel!,
                  ));
              context.pop();
            }
            if (state.status == CategoryTypeUpdateStatus.failure) {
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
            if (current.status == CategoryTypeUpdateStatus.update) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            switch (state.status) {
              case CategoryTypeUpdateStatus.initial:
              case CategoryTypeUpdateStatus.update:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case CategoryTypeUpdateStatus.success:
                return const CategoryTypeUpdateScreenBody();
              case CategoryTypeUpdateStatus.failure:
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

class CategoryTypeUpdateScreenBody extends StatelessWidget {
  const CategoryTypeUpdateScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CategoryTypeUpdateBloc>();
    return SingleChildScrollView(
      child: Column(
        children: [
          AppTextField(
            initialValue: bloc.state.categoryTypeModel?.name,
            name: 'Name',
            hintText: 'Имя типа категории',
            onChanged: (name) {
              bloc.add(CategoryTypeUpdateName(name: name));
            },
          ),
          const ButtonCategoryTypeUpdate(),
        ],
      ),
    );
  }
}
class ButtonCategoryTypeUpdate extends StatelessWidget {
  const ButtonCategoryTypeUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryTypeUpdateBloc, CategoryTypeUpdateState>(
      builder: (context, state) {
        return AppButton(
          onTap: state.isSubmitting
              ? null
              : () => context.read<CategoryTypeUpdateBloc>().add(
                    const CategoryTypeUpdate(),
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
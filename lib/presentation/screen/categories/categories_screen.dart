import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/aplication.dart';
import 'package:stories_admin/config/router/routers.dart';
import 'package:stories_admin/presentation/screen/categories/bloc/categories_bloc.dart';
import 'package:stories_data/models/category_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
        actions: [
          ButtonDeleteCategories(),
        ],
      ),
      floatingActionButton: ButtonAddCategory(),
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
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            case CategoriesStatus.success:
              return CategoriesScreenBody();
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

class ButtonAddCategory extends StatelessWidget {
  const ButtonAddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => context.pushNamed(
        Routers.pathCategoryCreateScreen,
      ),
    );
  }
}

class ButtonDeleteCategories extends StatelessWidget {
  const ButtonDeleteCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<CategoriesBloc>().add(
            CategoriesDeleteAll(),
          ),
      icon: Icon(Icons.delete),
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
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryWidget(
              category: category,
            );
          },
        );
      },
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // onTap: () {},
      leading: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(16),
        child: Image.network(
          height: 50,
          width: 50,
          category.iconUrl,
          fit: BoxFit.fill,
        ),
      ),
      title: Text(category.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              context.pushNamed(
                Routers.pathCategoryUpdateScreen,
                extra: category.id,
              );
            },
            icon: Icon(Icons.create),
          ),
          IconButton(
            onPressed: () {
              context.read<CategoriesBloc>().add(CategoriesDelete(
                    categoryId: category.id,
                  ));
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

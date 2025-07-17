part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {
  const CategoriesEvent();
}

final class CategoriesInitial extends CategoriesEvent {
  const CategoriesInitial();
}

final class CategoriesDelete extends CategoriesEvent {
  const CategoriesDelete({required this.categoryId});
  final String categoryId;
}

final class CategoriesDeleteAll extends CategoriesEvent {
  const CategoriesDeleteAll();
}

final class CategoriesAdd extends CategoriesEvent {
  const CategoriesAdd({required this.categoryModel});
  final CategoryModel categoryModel;
}

final class CategoriesUpdate extends CategoriesEvent {
  const CategoriesUpdate({required this.categoryModel});
  final CategoryModel categoryModel;
}

part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {
  const CategoriesEvent();
}

final class CategoriesInitial extends CategoriesEvent {
  const CategoriesInitial();
}


final class CategoriesDelete extends CategoriesEvent {
  const CategoriesDelete();
}

final class CategoriesDeleteAll extends CategoriesEvent {
  const CategoriesDeleteAll();
}



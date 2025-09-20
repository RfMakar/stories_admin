part of 'categories_types_bloc.dart';

@immutable
sealed class CategoriesTypesEvent {
  const CategoriesTypesEvent();
}

final class CategoriesTypesInitial extends CategoriesTypesEvent {
  const CategoriesTypesInitial();
}

final class CategoriesTypesDelete extends CategoriesTypesEvent {
  const CategoriesTypesDelete({required this.typeId});
  final String typeId;
}

final class CategoriesTypesDeleteAll extends CategoriesTypesEvent {
  const CategoriesTypesDeleteAll();
}

final class CategoriesTypesAdd extends CategoriesTypesEvent {
  const CategoriesTypesAdd({required this.categoryTypeModel});
  final CategoryTypeModel categoryTypeModel;
}

final class CategoriesTypesUpdate extends CategoriesTypesEvent {
  const CategoriesTypesUpdate({required this.categoryTypeModel});
  final CategoryTypeModel categoryTypeModel;
}

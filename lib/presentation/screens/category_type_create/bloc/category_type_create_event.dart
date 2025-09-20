part of 'category_type_create_bloc.dart';

@immutable
sealed class CategoryTypeCreateEvent {
  const CategoryTypeCreateEvent();
}

final class CategoryTypeCreateName extends CategoryTypeCreateEvent {
  const CategoryTypeCreateName({required this.name});
  final String name;
}

final class CategoryTypeCreate extends CategoryTypeCreateEvent {
  const CategoryTypeCreate();
}

part of 'category_create_bloc.dart';

@immutable
sealed class CategoryCreateEvent {
  const CategoryCreateEvent();
}

final class CategoryCreateName extends CategoryCreateEvent {
  const CategoryCreateName({required this.name});
  final String name;
}

final class CategoryCreateIcon extends CategoryCreateEvent {
  const CategoryCreateIcon({required this.icon});
  final File icon;
}

final class CategoryCreate extends CategoryCreateEvent {
  const CategoryCreate();
}

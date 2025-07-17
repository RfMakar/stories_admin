part of 'category_update_bloc.dart';

@immutable
sealed class CategoryUpdateEvent {
  const CategoryUpdateEvent();
}

final class CategoryUpdateInitial extends CategoryUpdateEvent{
  const CategoryUpdateInitial({required this.categoryId});
  final String categoryId;
}

final class CategoryUpdateName extends CategoryUpdateEvent{
  const CategoryUpdateName({required this.name});
  final String name;
}

final class CategoryUpdateIcon extends CategoryUpdateEvent{
  const CategoryUpdateIcon({required this.icon});
  final File icon;
}

final class CategoryUpdate extends CategoryUpdateEvent{
  const CategoryUpdate();
}


part of 'category_type_update_bloc.dart';

@immutable
sealed class CategoryTypeUpdateEvent {
  const CategoryTypeUpdateEvent();
}

final class CategoryTypeUpdateInitial extends CategoryTypeUpdateEvent{
  const CategoryTypeUpdateInitial({required this.typeId});
  final String typeId;
}

final class CategoryTypeUpdateName extends CategoryTypeUpdateEvent{
  const CategoryTypeUpdateName({required this.name});
  final String name;
}


final class CategoryTypeUpdate extends CategoryTypeUpdateEvent{
  const CategoryTypeUpdate();
}
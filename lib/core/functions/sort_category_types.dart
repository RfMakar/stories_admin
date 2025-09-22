import 'package:stories_data/models/category_type_model.dart';

List<CategoryTypeModel> sortCategoryTypes(List<CategoryTypeModel> types) {
  // Кастомный порядок для верхнего уровня
  final order = [
    "Тип сказки",
    "Герои сказок",
    "Тема сказки",
    "Для возраста",
    "Длительность",
    "Время прослушивания",
  ];

  // Сортируем верхний уровень
  types.sort((a, b) {
    final aIndex = order.indexOf(a.name);
    final bIndex = order.indexOf(b.name);

    if (aIndex == -1 && bIndex == -1) return 0; // оба не в списке
    if (aIndex == -1) return 1; // a не в списке — после b
    if (bIndex == -1) return -1; // b не в списке — после a
    return aIndex.compareTo(bIndex); // оба в списке — сортируем по индексу
  });

  return types;
}

part of 'category_create_bloc.dart';

enum CategoryCreateStatus { initial, success, failure }

final class CategoryCreateState {
  const CategoryCreateState({
    this.status = CategoryCreateStatus.initial,
    this.name,
    this.icon,
    this.categoryTypeSelected,
    this.categoryModel,
    this.isSubmitting = false,
    this.isValidateData = false,
    this.categoriesTypesModel = const [],
    this.exception,
  });
  final CategoryCreateStatus status;
  final String? name;
  final File? icon;
  final String? categoryTypeSelected;
  final CategoryModel? categoryModel;
  final bool isSubmitting;
  final bool isValidateData;
  final List<CategoryTypeModel> categoriesTypesModel;
  final DioException? exception;

  CategoryCreateState copyWith({
    CategoryCreateStatus? status,
    String? name,
    File? icon,
    String? categoryTypeSelected,
    CategoryModel? categoryModel,
    bool? isSubmitting,
    bool? isValidateData,
    List<CategoryTypeModel>? categoriesTypesModel,
    DioException? exception,
  }) {
    return CategoryCreateState(
      status: status ?? this.status,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      categoryTypeSelected: categoryTypeSelected ?? this.categoryTypeSelected,
      categoryModel: categoryModel ?? this.categoryModel,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidateData: isValidateData ?? this.isValidateData,
      categoriesTypesModel: categoriesTypesModel ?? this.categoriesTypesModel,
      exception: exception ?? this.exception,
    );
  }
}

part of 'category_update_bloc.dart';

enum CategoryUpdateStatus { initial, success, update, failure }

final class CategoryUpdateState {
  const CategoryUpdateState({
    this.status = CategoryUpdateStatus.initial,
    this.name,
    this.icon,
    this.categoryTypeSelected,
    this.categoryModel,
    this.updateCategoryModel,
    this.isSubmitting = false,
    this.isValidateData = false,
    this.categoriesTypesModel = const [],
    this.exception,
  });
  final CategoryUpdateStatus status;
  final String? name;
  final File? icon;
  final String? categoryTypeSelected;
  final CategoryModel? categoryModel;
  final CategoryModel? updateCategoryModel;
  final bool isSubmitting;
  final bool isValidateData;
  final List<CategoryTypeModel> categoriesTypesModel;
  final DioException? exception;

  CategoryUpdateState copyWith({
    CategoryUpdateStatus? status,
    String? name,
    File? icon,
    String? categoryTypeSelected,
    CategoryModel? categoryModel,
    CategoryModel? updateCategoryModel,
    bool? isSubmitting,
    bool? isValidateData,
    List<CategoryTypeModel>? categoriesTypesModel,
    DioException? exception,
  }) {
    return CategoryUpdateState(
      status: status ?? this.status,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      categoryTypeSelected: categoryTypeSelected ?? this.categoryTypeSelected,
      categoryModel: categoryModel ?? this.categoryModel,
      updateCategoryModel: updateCategoryModel ?? this.updateCategoryModel,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidateData: isValidateData ?? this.isValidateData,
      categoriesTypesModel: categoriesTypesModel ?? this.categoriesTypesModel,
      exception: exception ?? this.exception,
    );
  }
}

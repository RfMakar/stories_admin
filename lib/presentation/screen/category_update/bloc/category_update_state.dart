part of 'category_update_bloc.dart';

enum CategoryUpdateStatus { initial, success, update, failure }

final class CategoryUpdateState {
  const CategoryUpdateState({
    this.status = CategoryUpdateStatus.initial,
    this.name,
    this.icon,
    this.categoryModel,
    this.updateCategoryModel,
    this.isSubmitting = false,
    this.isValidateData = false,
    this.exception,
  });
  final CategoryUpdateStatus status;
  final String? name;
  final File? icon;
  final CategoryModel? categoryModel;
  final CategoryModel? updateCategoryModel;
  final bool isSubmitting;
  final bool isValidateData;
  final DioException? exception;

  CategoryUpdateState copyWith({
    CategoryUpdateStatus? status,
    String? name,
    File? icon,
    CategoryModel? categoryModel,
    CategoryModel? updateCategoryModel,
    bool? isSubmitting,
    bool? isValidateData,
    DioException? exception,
  }) {
    return CategoryUpdateState(
      status: status ?? this.status,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      categoryModel: categoryModel ?? this.categoryModel,
      updateCategoryModel: updateCategoryModel ?? this.updateCategoryModel,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidateData: isValidateData ?? this.isValidateData,
      exception: exception ?? this.exception,
    );
  }
}

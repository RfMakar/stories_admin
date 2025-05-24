part of 'category_create_bloc.dart';

enum CategoryCreateStatus { initial, success, failure }

final class CategoryCreateState {
  const CategoryCreateState({
    this.status = CategoryCreateStatus.initial,
    this.name,
    this.icon,
    this.categoryModel,
    this.isSubmitting = false,
    this.isValidateData = false,
    this.exception,
  });
  final CategoryCreateStatus status;
  final String? name;
  final File? icon;
  final CategoryModel? categoryModel;
  final bool isSubmitting;
  final bool isValidateData;
  final DioException? exception;

  CategoryCreateState copyWith({
    CategoryCreateStatus? status,
    String? name,
    File? icon,
    CategoryModel? categoryModel,
    bool? isSubmitting,
    bool? isValidateData,
    DioException? exception,
  }) {
    return CategoryCreateState(
      status: status ?? this.status,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      categoryModel: categoryModel ?? this.categoryModel,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidateData: isValidateData ?? this.isValidateData,
      exception: exception ?? this.exception,
    );
  }
}

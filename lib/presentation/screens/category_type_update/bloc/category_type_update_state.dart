part of 'category_type_update_bloc.dart';

enum CategoryTypeUpdateStatus { initial, success, update, failure }

final class CategoryTypeUpdateState {
  const CategoryTypeUpdateState({
    this.status = CategoryTypeUpdateStatus.initial,
    this.name,
    this.categoryTypeModel,
    this.updateCategoryTypeModel,
    this.isSubmitting = false,
    this.isValidateData = false,
    this.exception,
  });
  final CategoryTypeUpdateStatus status;
  final String? name;
  final CategoryTypeModel? categoryTypeModel;
  final CategoryTypeModel? updateCategoryTypeModel;
  final bool isSubmitting;
  final bool isValidateData;
  final DioException? exception;

  CategoryTypeUpdateState copyWith({
    CategoryTypeUpdateStatus? status,
    String? name,
    CategoryTypeModel? categoryTypeModel,
    CategoryTypeModel? updateCategoryTypeModel,
    bool? isSubmitting,
    bool? isValidateData,
    DioException? exception,
  }) {
    return CategoryTypeUpdateState(
      status: status ?? this.status,
      name: name ?? this.name,
      categoryTypeModel: categoryTypeModel ?? this.categoryTypeModel,
      updateCategoryTypeModel: updateCategoryTypeModel ?? this.updateCategoryTypeModel,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidateData: isValidateData ?? this.isValidateData,
      exception: exception ?? this.exception,
    );
  }
}


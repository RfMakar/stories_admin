part of 'category_type_create_bloc.dart';

enum CategoryTypeCreateStatus { initial, success, failure }

final class CategoryTypeCreateState {
  const CategoryTypeCreateState({
    this.status = CategoryTypeCreateStatus.initial,
    this.name,
    this.categoryTypeModel,
    this.isSubmitting = false,
    this.isValidateData = false,
    this.exception,
  });
  final CategoryTypeCreateStatus status;
  final String? name;
  final CategoryTypeModel? categoryTypeModel;
  final bool isSubmitting;
  final bool isValidateData;
  final DioException? exception;

  CategoryTypeCreateState copyWith({
    CategoryTypeCreateStatus? status,
    String? name,
    CategoryTypeModel? categoryTypeModel,
    bool? isSubmitting,
    bool? isValidateData,
    DioException? exception,
  }) {
    return CategoryTypeCreateState(
      status: status ?? this.status,
      name: name ?? this.name,
      categoryTypeModel: categoryTypeModel ?? this.categoryTypeModel,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidateData: isValidateData ?? this.isValidateData,
      exception: exception ?? this.exception,
    );
  }
}

part of 'categories_bloc.dart';

enum CategoriesStatus { initial, success, failure }

final class CategoriesState {
  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categories = const [],
    this.exception,
  });
  final CategoriesStatus status;
  final List<CategoryModel> categories;
  final DioException? exception;

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryModel>? categories,
    DioException? exception,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      exception: exception ?? this.exception,
    );
  }
}

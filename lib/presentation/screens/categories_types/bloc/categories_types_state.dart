part of 'categories_types_bloc.dart';

enum CategoriesTypesStatus { initial, success, failure }

final class CategoriesTypesState extends Equatable{
  const CategoriesTypesState({
    this.status = CategoriesTypesStatus.initial,
    this.categoriesTypes = const [],
    this.exception,
  });
  final CategoriesTypesStatus status;
  final List<CategoryTypeModel> categoriesTypes;
  final DioException? exception;

  CategoriesTypesState copyWith({
    CategoriesTypesStatus? status,
    List<CategoryTypeModel>? categoriesTypes,
    DioException? exception,
  }) {
    return CategoriesTypesState(
      status: status ?? this.status,
      categoriesTypes: categoriesTypes ?? this.categoriesTypes,
      exception: exception ?? this.exception,
    );
  }
  
  @override
  List<Object?> get props => [status, categoriesTypes, exception];
}

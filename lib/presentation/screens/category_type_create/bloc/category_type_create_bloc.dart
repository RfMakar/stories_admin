import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_type_model.dart';
import 'package:stories_data/repositories/category_type_repository.dart';

part 'category_type_create_event.dart';
part 'category_type_create_state.dart';

class CategoryTypeCreateBloc
    extends Bloc<CategoryTypeCreateEvent, CategoryTypeCreateState> {
  CategoryTypeCreateBloc(this._categoryTypeRepository)
      : super(const CategoryTypeCreateState()) {
    on<CategoryTypeCreateName>(_createName);
    on<CategoryTypeCreate>(_createCategoryType);
  }

  final CategoryTypeRepository _categoryTypeRepository;

  Future<void> _createName(
    CategoryTypeCreateName event,
    Emitter<CategoryTypeCreateState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _createCategoryType(
    CategoryTypeCreate event,
    Emitter<CategoryTypeCreateState> emit,
  ) async {
    if (state.name == null || state.name == '') {
      emit(state.copyWith(isValidateData: true));
      //сброс валидации
      emit(state.copyWith(isValidateData: false));
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    try {
      final data = await _categoryTypeRepository.createCategoryType(
        name: state.name!,
      );
      emit(state.copyWith(
        status: CategoryTypeCreateStatus.success,
        categoryTypeModel: data,
      ));
    } on DioException catch (exception) {
      //Чтобы показовалось один раз ошибка
      emit(state.copyWith(
        status: CategoryTypeCreateStatus.failure,
        isSubmitting: false,
        exception: exception,
      ));
      //Сбрасываем стейт
      emit(state.copyWith(
        status: CategoryTypeCreateStatus.initial,
        exception: null,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_type_model.dart';
import 'package:stories_data/repositories/category_type_repository.dart';

part 'category_type_update_event.dart';
part 'category_type_update_state.dart';

class CategoryTypeUpdateBloc
    extends Bloc<CategoryTypeUpdateEvent, CategoryTypeUpdateState> {
  CategoryTypeUpdateBloc(this._categoryTypeRepository)
      : super(const CategoryTypeUpdateState()) {
    on<CategoryTypeUpdateInitial>(_initial);
    on<CategoryTypeUpdateName>(_updateName);
    on<CategoryTypeUpdate>(_updateCategoryType);
  }

  final CategoryTypeRepository _categoryTypeRepository;

  Future<void> _initial(
    CategoryTypeUpdateInitial event,
    Emitter<CategoryTypeUpdateState> emit,
  ) async {
    try {
      final data = await _categoryTypeRepository.getCategoryType(
        id: event.typeId,
      );
      emit(state.copyWith(
        status: CategoryTypeUpdateStatus.success,
        categoryTypeModel: data,
      ));
    } on DioException catch (exception) {
      emit(state.copyWith(
        status: CategoryTypeUpdateStatus.failure,
        exception: exception,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> _updateName(
    CategoryTypeUpdateName event,
    Emitter<CategoryTypeUpdateState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _updateCategoryType(
    CategoryTypeUpdate event,
    Emitter<CategoryTypeUpdateState> emit,
  ) async {
    if ( state.name == null || state.name == '') {
      emit(state.copyWith(isValidateData: true));
      //сброс валидации
      emit(state.copyWith(isValidateData: false));
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final data = await _categoryTypeRepository.updateCategoryType(
        id: state.categoryTypeModel!.id,
        name: state.name!,
      );
      emit(state.copyWith(
        status: CategoryTypeUpdateStatus.update,
        updateCategoryTypeModel: data,
      ));
    } on DioException catch (exception) {
      //Чтобы показовалось один раз ошибка
      emit(state.copyWith(
        status: CategoryTypeUpdateStatus.failure,
        isSubmitting: false,
        exception: exception,
      ));
      //Сбрасываем стейт
      emit(state.copyWith(
        status: CategoryTypeUpdateStatus.success,
        exception: null,
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}

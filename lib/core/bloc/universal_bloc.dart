import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuro_math/core/bloc/universal_state.dart';

class UniversalCubit<T> extends Cubit<UniversalState<T>> {
  UniversalCubit() : super(const UniversalState.initial());

  void setInitial() => emit(const UniversalState.initial());
  void setLoading() => emit(const UniversalState.loading());
  void setSuccess(T data) => emit(UniversalState.success(data));
  void setFailure(String error) => emit(UniversalState.failure(error));



  T? get data => state.maybeWhen(
    success: (data) => data,
    orElse: () => null,
  );


  bool get hasData => data != null;

  bool get isLoading => state.maybeWhen(
    loading: () => true,
    orElse: () => false,
  );

  bool get isSuccess => state.maybeWhen(
    success: (data) => true,
    orElse: () => false,
  );

  bool get isError => state.maybeWhen(
    failure: (error) => true,
    orElse: () => false,
  );

}
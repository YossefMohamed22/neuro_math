import 'package:freezed_annotation/freezed_annotation.dart';

part 'universal_state.freezed.dart';

@freezed
class UniversalState<T> with _$UniversalState<T> {
  const factory UniversalState.initial() = _Initial<T>;
  const factory UniversalState.loading() = _Loading<T>;
  const factory UniversalState.success(T data) = _Success<T>;
  const factory UniversalState.failure(String error) = _Failure<T>;
}
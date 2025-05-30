import 'package:flutter/cupertino.dart';
import 'package:neuro_math/core/bloc/universal_bloc.dart';
import 'dart:math';

class MultiOperationLogic {
  MultiOperationLogic() {
    shuffleNumbers();
    durationFastCubit.setSuccess(1);
  }

  List<String> numbers = List.generate(90, (index) => index.toString());
  List<int> userSelectNumbers = [];

  final UniversalCubit<String> resultCubit = UniversalCubit();
  final UniversalCubit<int> durationFastCubit = UniversalCubit<int>();

  final ScrollController scrollController = ScrollController();

  void inCreaseSpeed() {
    var previousDuration = durationFastCubit.data!;
    if (previousDuration < 3) {
      durationFastCubit.setSuccess(previousDuration + 1);
    }
  }

  void updateResult(String selectedNumber) {
    final String currentValue = resultCubit.data!;
    resultCubit.setSuccess("$currentValue$selectedNumber");
  }

  void shuffleNumbers() {
    final random = Random();
    numbers.shuffle(random);
    userSelectNumbers = numbers.take(7).map((e) => int.parse(e)).toList();
  }
}

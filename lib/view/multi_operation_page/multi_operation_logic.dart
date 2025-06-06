
import 'package:flutter/cupertino.dart';
import 'package:neuro_math/core/bloc/universal_bloc.dart';
import 'dart:math';

class MultiOperationLogic {
  MultiOperationLogic() {
    // Initialize resultCubit with an empty string
    resultCubit.setSuccess(''); 
    shuffleNumbers();
    durationFastCubit.setSuccess(1);
  }

  List<String> numbers = List.generate(90, (index) => index.toString());
  List<int> userSelectNumbers = [];

  final UniversalCubit<String> resultCubit = UniversalCubit();
  final UniversalCubit<int> durationFastCubit = UniversalCubit<int>();

  final ScrollController scrollController = ScrollController();

  void inCreaseSpeed() {
    var previousDuration = durationFastCubit.data ?? 1; // Handle null case
    if (previousDuration < 3) {
      durationFastCubit.setSuccess(previousDuration + 1);
    } else {
      // Cycle back to speed 1 after reaching speed 3
      durationFastCubit.setSuccess(1); 
    }
  }

  void updateResult(String selectedNumber) {
    final String currentValue = resultCubit.data ?? ''; // Handle null case
    // Optional: Add length limit if needed
    // if (currentValue.length < 10) { 
      resultCubit.setSuccess("$currentValue$selectedNumber");
    // }
  }

  // Added deleteLastDigit function
  void deleteLastDigit() {
    final String currentValue = resultCubit.data ?? ''; // Handle null case
    if (currentValue.isNotEmpty) {
      resultCubit.setSuccess(currentValue.substring(0, currentValue.length - 1));
    }
  }

  // Added checkAnswer function (temporary logic: clears result)
  void checkAnswer() {
    // TODO: Implement actual answer checking logic later
    // For now, just clear the input field
    resultCubit.setSuccess(''); 
    // Optionally, could also trigger shuffling numbers or other actions
    // shuffleNumbers(); 
  }

  void shuffleNumbers() {
    final random = Random();
    numbers.shuffle(random);
    userSelectNumbers = numbers.take(7).map((e) => int.parse(e)).toList();
    // TODO: Update the UI (VerticalTicker) with the new numbers
  }

  // Dispose method to clean up resources
  void dispose() {
    resultCubit.close();
    durationFastCubit.close();
    scrollController.dispose();
  }
}


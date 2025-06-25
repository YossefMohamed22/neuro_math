import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuro_math/core/bloc/universal_bloc.dart';
import 'package:neuro_math/core/bloc/universal_state.dart';
import 'package:neuro_math/core/theme/app_themes.dart';
import 'dart:math';

// Competitions Logic Class
class CompetitionsLogic {
  CompetitionsLogic() {
    resultCubit.setSuccess('');
    generateNewProblem();
    scoreCubit.setSuccess(0);
    totalQuestionsCubit.setSuccess(0);
    isGameActiveCubit.setSuccess(false);
  }

  // Game state variables
  int currentNum1 = 0;
  int currentNum2 = 0;
  String currentOperation = '+';
  int correctAnswer = 0;

  // Cubits for state management
  final UniversalCubit<String> resultCubit = UniversalCubit();
  final UniversalCubit<int> scoreCubit = UniversalCubit<int>();
  final UniversalCubit<int> totalQuestionsCubit = UniversalCubit<int>();
  final UniversalCubit<bool> isGameActiveCubit = UniversalCubit<bool>();

  // Operations list for random selection
  final List<String> operations = ['+', '-', '×', '÷'];

  void startGame() {
    scoreCubit.setSuccess(0);
    totalQuestionsCubit.setSuccess(0);
    isGameActiveCubit.setSuccess(true);
    generateNewProblem();
  }

  void endGame() {
    isGameActiveCubit.setSuccess(false);
  }

  void generateNewProblem() {
    final random = Random();

    // Select random operation
    currentOperation = operations[random.nextInt(operations.length)];

    // Generate numbers based on operation
    switch (currentOperation) {
      case '+':
        currentNum1 = random.nextInt(50) + 1; // 1-50
        currentNum2 = random.nextInt(50) + 1; // 1-50
        correctAnswer = currentNum1 + currentNum2;
        break;
      case '-':
        currentNum1 = random.nextInt(50) + 25; // 25-74
        currentNum2 = random.nextInt(currentNum1); // 0 to currentNum1-1
        correctAnswer = currentNum1 - currentNum2;
        break;
      case '×':
        currentNum1 = random.nextInt(12) + 1; // 1-12
        currentNum2 = random.nextInt(12) + 1; // 1-12
        correctAnswer = currentNum1 * currentNum2;
        break;
      case '÷':
        // Generate division that results in whole numbers
        correctAnswer = random.nextInt(12) + 1; // 1-12
        currentNum2 = random.nextInt(12) + 1; // 1-12
        currentNum1 = correctAnswer * currentNum2;
        break;
    }
  }

  void updateResult(String selectedNumber) {
    final String currentValue = resultCubit.data ?? '';
    // Limit input length to prevent overflow
    if (currentValue.length < 6) {
      resultCubit.setSuccess("$currentValue$selectedNumber");
    }
  }

  void deleteLastDigit() {
    final String currentValue = resultCubit.data ?? '';
    if (currentValue.isNotEmpty) {
      resultCubit
          .setSuccess(currentValue.substring(0, currentValue.length - 1));
    }
  }

  void checkAnswer() {
    final String userAnswer = resultCubit.data ?? '';
    if (userAnswer.isEmpty) return;

    final int? userAnswerInt = int.tryParse(userAnswer);
    if (userAnswerInt == null) return;

    // Update total questions
    final int currentTotal = totalQuestionsCubit.data ?? 0;
    totalQuestionsCubit.setSuccess(currentTotal + 1);

    // Check if answer is correct
    if (userAnswerInt == correctAnswer) {
      final int currentScore = scoreCubit.data ?? 0;
      scoreCubit.setSuccess(currentScore + 1);
    }

    // Clear input and generate new problem
    resultCubit.setSuccess('');
    generateNewProblem();
  }

  // Get current score percentage
  double getScorePercentage() {
    final int score = scoreCubit.data ?? 0;
    final int total = totalQuestionsCubit.data ?? 0;
    if (total == 0) return 0.0;
    return (score / total) * 100;
  }

  // Dispose method to clean up resources
  void dispose() {
    resultCubit.close();
    scoreCubit.close();
    totalQuestionsCubit.close();
    isGameActiveCubit.close();
  }
}

class CompetitionsPage extends StatefulWidget {
  const CompetitionsPage({super.key});

  @override
  State<CompetitionsPage> createState() => _CompetitionsPageState();
}

class _CompetitionsPageState extends State<CompetitionsPage> {
  final CompetitionsLogic logic = CompetitionsLogic();
  bool _showCountdown = true;
  int _countdownValue = 3;
  Timer? _timer;
  Timer? _gameTimer;
  int _gameTimeLeft = 60; // 60 seconds game duration

  @override
  void initState() {
    super.initState();
    logic.resultCubit.setSuccess("");
    startPreGameCountdown();
  }

  void startPreGameCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdownValue > 1) {
          _countdownValue--;
        } else {
          _showCountdown = false;
          timer.cancel();
          startGame();
        }
      });
    });
  }

  void startGame() {
    logic.startGame();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_gameTimeLeft > 0) {
          _gameTimeLeft--;
        } else {
          timer.cancel();
          endGame();
        }
      });
    });
  }

  void endGame() {
    logic.endGame();
    showFinalScoreDialog();
  }

  void showFinalScoreDialog() {
    if (!mounted) return;
    _gameTimer?.cancel();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int score = logic.scoreCubit.data ?? 0;
    final int total = logic.totalQuestionsCubit.data ?? 0;
    final int wrongAnswers = total - score;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: theme.dialogBackgroundColor,
          title: Center(
            child: Text(
              "النتيجة النهائية",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultRow(
                  "الإجابات الصحيحة:", score.toString(), Colors.green.shade600),
              _buildResultRow("الإجابات الخاطئة:", wrongAnswers.toString(),
                  colorScheme.error),
              _buildResultRow("المسائل المحلولة:", total.toString(),
                  colorScheme.onSurfaceVariant),
              const Divider(height: 20, thickness: 1),
              _buildResultRow("الدرجة:", score.toString(), colorScheme.primary,
                  isScore: true),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("حسناً", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultRow(String label, String value, Color valueColor,
      {bool isScore = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isScore ? 18 : 16,
              fontWeight: isScore ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void restartGame() {
    setState(() {
      _showCountdown = true;
      _countdownValue = 3;
      _gameTimeLeft = 60;
    });
    logic.scoreCubit.setSuccess(0);
    logic.totalQuestionsCubit.setSuccess(0);
    logic.resultCubit.setSuccess("");
    startPreGameCountdown();
  }

  // Button Builder (similar to multiplied.dart)
  Widget buildKeypadButton(String text,
      {IconData? icon, Function()? onTap, Color? bgColor, Color? fgColor}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Default background/foreground based on theme, but allow overrides
    Color buttonColor = bgColor ??
        (theme.brightness == Brightness.dark
            ? colorScheme.surfaceVariant
            : Colors.white);
    Color textColor = fgColor ?? colorScheme.onSurface;
    Widget child;

    if (icon != null) {
      child = Icon(icon, color: textColor, size: 26);
    } else {
      child = Text(
        text,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [
            BoxShadow(
              // Use a darker shadow in light mode for the white panel
              color: theme.brightness == Brightness.light
                  ? Colors.grey.withOpacity(0.15)
                  : Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gameTimer?.cancel();
    logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<AppGradients>()!;

    // Adjusted flex values to make keypad smaller, matching multiplied.dart
    final questionAreaFlex = 3;
    final keypadAreaFlex = 4;

    // Calculate keypadAspectRatio based on multiplied.dart logic
    double topSectionHeight = screenSize.height * 0.3;
    double keypadAvailableHeight = screenSize.height -
        topSectionHeight -
        safeAreaPadding.top -
        safeAreaPadding.bottom -
        20;
    double keypadAspectRatio =
        (screenSize.width / 3) / (keypadAvailableHeight / 4);
    if (keypadAspectRatio <= 0) keypadAspectRatio = 1.0;

    // Define button colors from theme
    final backspaceButtonBgColor = colorScheme.errorContainer;
    final backspaceButtonFgColor = colorScheme.onErrorContainer;
    final checkButtonBgColor = colorScheme.primaryContainer;
    final checkButtonFgColor = colorScheme.onPrimaryContainer;
    // Use white for number buttons in light mode, surfaceVariant in dark mode
    final numberButtonBgColor = theme.brightness == Brightness.light
        ? Colors.white
        : colorScheme.surfaceVariant;
    final numberButtonFgColor = colorScheme.onSurfaceVariant;
    // Define colors for timer and close icon (always white for contrast on gradient)
    const Color topIconColor = Colors.white;
    const Color timerTextColor = Colors.white;
    const Color problemTextColor = Colors.white;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradients.start, gradients.end],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              if (_showCountdown)
                Center(
                  child: Text(
                    "$_countdownValue",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.3,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              if (!_showCountdown)
                Column(
                  children: [
                    // Top Bar (Timer and Close Button)
                    Padding(
                      padding: EdgeInsets.only(
                        top: safeAreaPadding.top + 10,
                        left: 25,
                        right: 25,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Timer
                          SizedBox(
                            width: 55,
                            height: 55,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 6,
                                  color: timerTextColor.withOpacity(0.2),
                                ),
                                CircularProgressIndicator(
                                  value: _gameTimeLeft / 60,
                                  strokeWidth: 6,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          timerTextColor),
                                ),
                                Text(
                                  "$_gameTimeLeft",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: timerTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Close Button
                          InkWell(
                            onTap: () {
                              showFinalScoreDialog();
                            },
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: topIconColor.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: topIconColor, size: 26),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Question Area
                    Expanded(
                      flex: questionAreaFlex,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${logic.currentNum1} ${logic.currentOperation} ${logic.currentNum2}",
                              style: TextStyle(
                                  fontSize: screenSize.width * 0.13,
                                  fontWeight: FontWeight.bold,
                                  color: problemTextColor,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 1,
                                        color: Colors.black.withOpacity(0.15),
                                        offset: Offset(1, 1))
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            // Container for the line and answer
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: screenSize.width * 0.5),
                              child: Column(
                                children: [
                                  Container(
                                    height: 1.5,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  const SizedBox(height: 10),
                                  BlocBuilder<UniversalCubit<String>,
                                      UniversalState<String>>(
                                    bloc: logic.resultCubit,
                                    builder: (context, state) {
                                      final answer = state.maybeWhen(
                                          success: (data) => data,
                                          orElse: () => "");
                                      return Text(
                                        answer.isEmpty ? " " : answer,
                                        style: TextStyle(
                                          fontSize: screenSize.width * 0.1,
                                          fontWeight: FontWeight.bold,
                                          color: problemTextColor,
                                          letterSpacing: 3,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Keypad Area - Restore white background panel
                    Expanded(
                      flex: keypadAreaFlex,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            // Use white in light mode, dark surface in dark mode
                            color: theme.brightness == Brightness.light
                                ? Colors.white
                                : colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                            boxShadow: [
                              // Keep shadow for separation
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              )
                            ]),
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          childAspectRatio: 1.3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          padding: const EdgeInsets.all(10),
                          children: [
                            ...List.generate(9, (index) {
                              return buildKeypadButton("${index + 1}",
                                  onTap: () =>
                                      logic.updateResult("${index + 1}"),
                                  bgColor: numberButtonBgColor,
                                  fgColor: numberButtonFgColor);
                            }),
                            buildKeypadButton(
                              "",
                              icon: Icons.backspace_outlined,
                              onTap: logic.deleteLastDigit,
                              bgColor: backspaceButtonBgColor,
                              fgColor: backspaceButtonFgColor,
                            ),
                            buildKeypadButton("0",
                                onTap: () => logic.updateResult("0"),
                                bgColor: numberButtonBgColor,
                                fgColor: numberButtonFgColor),
                            buildKeypadButton(
                              "",
                              icon: Icons.check_circle_outline,
                              onTap: logic.checkAnswer,
                              bgColor: checkButtonBgColor,
                              fgColor: checkButtonFgColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

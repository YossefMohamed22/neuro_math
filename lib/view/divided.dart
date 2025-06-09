import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:neuro_math/core/theme/app_themes.dart'; // Import AppThemes for gradient

class Divided extends StatefulWidget {
  const Divided({super.key});

  @override
  State<Divided> createState() => _DividedState();
}

class _DividedState extends State<Divided> {
  int num1 = 0;
  int num2 = 1; // Initialize num2 to 1 to avoid division by zero initially
  String operation = "÷"; // Division symbol
  String answer = "";
  int counter = 3;
  bool showTimer = true;

  int totalTime = 60;
  Timer? countdownTimer;

  int correctAnswers = 0;
  int wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (counter > 1) {
          counter--;
        } else {
          timer.cancel();
          showTimer = false;
          startCountdown();
        }
      });
    });
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (totalTime > 0) {
          totalTime--;
        } else {
          timer.cancel();
          showResultDialog();
        }
      });
    });
  }

  void generateQuestion() {
    // Generate division questions where the result is an integer
    int result = Random().nextInt(12) + 1; // Result from 1 to 12
    num2 = Random().nextInt(12) + 1; // Divisor from 1 to 12
    num1 = result * num2; // Calculate the dividend
    operation = "÷";
    answer = "";
  }

  int calculateAnswer() {
    // The answer is the pre-calculated result
    return num1 ~/ num2; // Use integer division
  }

  void checkAnswer() {
    if (answer.isEmpty) return;
    if (int.tryParse(answer) == calculateAnswer()) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }
    setState(() {
      generateQuestion();
    });
  }

  void deleteLastDigit() {
    if (answer.isNotEmpty) {
      setState(() {
        answer = answer.substring(0, answer.length - 1);
      });
    }
  }

  // Updated result dialog using Theme
  void showResultDialog() {
    if (!mounted) return;
    countdownTimer?.cancel();
    int totalQuestions = correctAnswers + wrongAnswers;
    int score = correctAnswers;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              _buildResultRow("الإجابات الصحيحة:", correctAnswers.toString(),
                  Colors.green.shade600),
              _buildResultRow("الإجابات الخاطئة:", wrongAnswers.toString(),
                  colorScheme.error),
              _buildResultRow("المسائل المحلولة:", totalQuestions.toString(),
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

  // Updated Button Builder using Theme
  Widget buildKeypadButton(String text,
      {IconData? icon, Function()? onTap, Color? bgColor, Color? fgColor}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Default background/foreground based on theme, but allow overrides
    Color buttonColor = bgColor ??
        (theme.brightness == Brightness.dark
            ? colorScheme.surfaceContainerHighest
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<AppGradients>()!;

    final questionAreaFlex = 2;
    final keypadAreaFlex = 5;

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
        : colorScheme.surfaceContainerHighest;
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
              if (showTimer)
                Center(
                  child: Text(
                    "$counter",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.3,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              if (!showTimer)
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
                                  color: timerTextColor.withOpacity(
                                      0.2), // Use white with opacity
                                ),
                                CircularProgressIndicator(
                                  value: totalTime / 60,
                                  strokeWidth: 6,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          timerTextColor), // Use white
                                ),
                                Text(
                                  "$totalTime",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: timerTextColor, // Use white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Close Button
                          InkWell(
                            onTap: () {
                              showResultDialog();
                            },
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: topIconColor.withOpacity(
                                    0.25), // Use white with opacity
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: topIconColor, size: 26), // Use white
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
                              "$num1 $operation $num2", // Display division question
                              style: TextStyle(
                                  fontSize: screenSize.width * 0.13,
                                  fontWeight: FontWeight.bold,
                                  color: problemTextColor, // Use white
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
                                  Text(
                                    answer.isEmpty ? " " : answer,
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      color: problemTextColor, // Use white
                                      letterSpacing: 3,
                                    ),
                                    textAlign: TextAlign.center,
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
                          childAspectRatio: keypadAspectRatio,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          padding: const EdgeInsets.all(10),
                          children: [
                            ...List.generate(9, (index) {
                              return buildKeypadButton("${index + 1}",
                                  onTap: () =>
                                      setState(() => answer += "${index + 1}"),
                                  bgColor: numberButtonBgColor,
                                  fgColor: numberButtonFgColor);
                            }),
                            buildKeypadButton(
                              "",
                              icon: Icons.backspace_outlined,
                              onTap: deleteLastDigit,
                              bgColor: backspaceButtonBgColor,
                              fgColor: backspaceButtonFgColor,
                            ),
                            buildKeypadButton("0",
                                onTap: () => setState(() => answer += "0"),
                                bgColor: numberButtonBgColor,
                                fgColor: numberButtonFgColor),
                            buildKeypadButton(
                              "",
                              icon: Icons.check,
                              onTap: checkAnswer,
                              bgColor: Colors.green,
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

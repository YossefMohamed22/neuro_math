import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:neuro_math/core/theme/app_themes.dart'; // Import AppThemes for gradient

class Marathon extends StatefulWidget {
  const Marathon({super.key});

  @override
  State<Marathon> createState() => _MarathonState();
}

// Represents a single number in the vertical list
class QuestionItem {
  final int number;
  final bool isNegative; // True if subtraction, false if addition

  QuestionItem({required this.number, required this.isNegative});
}

class _MarathonState extends State<Marathon> {
  List<QuestionItem> questionItems = []; // List to hold vertical numbers
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
    generateVerticalQuestion();
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

  // Generate a vertical question with 2 to 10 items
  void generateVerticalQuestion() {
    questionItems.clear();
    int numberOfItems = Random().nextInt(9) + 2; // 2 to 10 items
    int currentSum = 0;

    for (int i = 0; i < numberOfItems; i++) {
      int number = Random().nextInt(10) + 1; // Numbers from 1 to 10
      bool isNegative = Random().nextBool();

      if (i == 0) {
        isNegative = false; // First number is always positive
      }

      questionItems.add(QuestionItem(number: number, isNegative: isNegative));
      currentSum += (isNegative ? -number : number);
    }
    answer = "";
  }

  // Calculate the answer for the vertical list
  int calculateVerticalAnswer() {
    int sum = 0;
    for (var item in questionItems) {
      sum += (item.isNegative ? -item.number : item.number);
    }
    return sum;
  }

  void checkAnswer() {
    if (answer.isEmpty) return;
    // Handle negative sign input
    if (answer == "-") return; // Don't check if only negative sign

    int? parsedAnswer = int.tryParse(answer);
    if (parsedAnswer == null) return; // Invalid input

    if (parsedAnswer == calculateVerticalAnswer()) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }
    setState(() {
      generateVerticalQuestion();
    });
  }

  void deleteLastDigit() {
    if (answer.isNotEmpty) {
      setState(() {
        answer = answer.substring(0, answer.length - 1);
      });
    }
  }

  // Add negative sign or toggle it
  void toggleNegativeSign() {
    setState(() {
      if (answer.startsWith("-")) {
        answer = answer.substring(1);
      } else if (answer.isNotEmpty) {
        // Only add if there are digits
        answer = "-$answer";
      } else {
        // Allow starting with negative sign
        answer = "-";
      }
    });
  }

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
                Navigator.pop(context); // Go back from marathon page
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
      child = Icon(icon, color: textColor, size: 28);
    } else {
      child = Text(
        text,
        style: TextStyle(
          fontSize: 28,
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

  // Function to calculate dynamic font size based on number of items
  double _calculateDynamicFontSize(int numItems, double screenWidth) {
    const double maxMultiplier = 0.09;
    const double minMultiplier = 0.06;
    const double absoluteMinSize = 22.0;
    const double absoluteMaxSize = 40.0;

    int clampedNumItems = numItems.clamp(2, 10);
    double scaleFactor = (clampedNumItems - 2) / (10 - 2);
    double currentMultiplier =
        maxMultiplier - (maxMultiplier - minMultiplier) * scaleFactor;
    double calculatedSize = screenWidth * currentMultiplier;
    return calculatedSize.clamp(absoluteMinSize, absoluteMaxSize);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<AppGradients>()!;

    // --- Layout Adjustments ---
    double questionFontSize =
        _calculateDynamicFontSize(questionItems.length, screenSize.width);
    double questionLineHeight = 1.4 - (questionFontSize - 22) * 0.01;
    questionLineHeight = questionLineHeight.clamp(1.1, 1.4);

    // Define colors for timer and close icon (always white for contrast on gradient)
    const Color topIconColor = Colors.white;
    const Color timerTextColor = Colors.white;
    const Color problemTextColor = Colors.white;

    final questionTextStyle = TextStyle(
        fontSize: questionFontSize,
        fontWeight: FontWeight.bold,
        color: problemTextColor, // Use white
        height: questionLineHeight,
        shadows: [
          Shadow(
              blurRadius: 1,
              color: Colors.black.withOpacity(0.15),
              offset: Offset(1, 1))
        ]);

    final answerTextStyle = TextStyle(
      fontSize:
          questionFontSize * 0.9, // Slightly smaller than question numbers
      fontWeight: FontWeight.bold,
      color: problemTextColor, // Use white
      letterSpacing: 3,
    );

    double topBarHeight = 55 + safeAreaPadding.top + 20;
    double questionSectionHeightEstimate = screenSize.height * 0.5;
    double keypadAvailableHeight = screenSize.height -
        topBarHeight -
        questionSectionHeightEstimate -
        safeAreaPadding.bottom;
    if (keypadAvailableHeight < screenSize.height * 0.3) {
      keypadAvailableHeight = screenSize.height * 0.3;
    }

    double keypadButtonHeight = (keypadAvailableHeight / 4) - 12;
    double keypadButtonWidth = (screenSize.width - 40 - 20) / 3;
    double keypadAspectRatio = (keypadButtonWidth > 0 && keypadButtonHeight > 0)
        ? keypadButtonWidth / keypadButtonHeight
        : 1.2;
    // --- End Layout Adjustments ---

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
    // +/- button color
    final signButtonBgColor = theme.brightness == Brightness.light
        ? Colors.grey.shade200
        : colorScheme.surfaceContainerHighest.withOpacity(0.7);
    final signButtonFgColor = colorScheme.onSurfaceVariant;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        bottom: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                    // Question & Answer Area
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Vertical list of numbers
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: questionItems.map((item) {
                                String displayValue = item.isNegative
                                    ? "-${item.number}"
                                    : item.number.toString();
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0.5),
                                  child: Text(
                                    displayValue,
                                    style: questionTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            // Container for the line and answer
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: screenSize.width * 0.6),
                              child: Column(
                                children: [
                                  Divider(
                                    color: Colors.white.withOpacity(0.7),
                                    thickness: 1.5,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    answer.isEmpty ? " " : answer,
                                    style: answerTextStyle,
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
                    Container(
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
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

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

  // Define exact colors from reference image (approximated)
  final Color backspaceButtonColor = const Color(0xFFF87070); // Coral red
  final Color checkButtonColor = const Color(0xFF63C9A8); // Teal green
  final Color keypadTextColor = Colors.grey.shade800; // Darker grey
  final Color gradientStartColor = const Color(0xFF6A82FB); // Adjusted blue
  final Color gradientEndColor = const Color(0xFFB477F8); // Adjusted purple

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
    // Generate random number of items for actual use
    int numberOfItems = Random().nextInt(9) + 2; // 2 to 10 items
    // int numberOfItems = 10; // Force 10 items for testing layout
    // int numberOfItems = 2; // Force 2 items for testing layout
    int currentSum = 0;

    for (int i = 0; i < numberOfItems; i++) {
      int number = Random().nextInt(10) + 1; // Numbers from 1 to 10
      bool isNegative = Random().nextBool();

      // Ensure the first number is positive for simplicity
      if (i == 0) {
        isNegative = false;
      }
      // Optional: Add logic to prevent sum going too negative if desired

      questionItems.add(QuestionItem(number: number, isNegative: isNegative));
      currentSum += (isNegative ? -number : number);
    }

    // Ensure the final sum is reasonable (e.g., not excessively large or small)
    // This basic version doesn't constrain the sum, might need refinement

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
    // Allow negative sign as valid input for comparison
    if (int.tryParse(answer) == calculateVerticalAnswer()) {
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

  void showResultDialog() {
    if (!mounted) return;
    countdownTimer?.cancel();
    int totalQuestions = correctAnswers + wrongAnswers;
    int score = correctAnswers;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              "النتيجة النهائية",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultRow("الإجابات الصحيحة:", correctAnswers.toString(), Colors.green.shade600),
              _buildResultRow("الإجابات الخاطئة:", wrongAnswers.toString(), Colors.red.shade600),
              _buildResultRow("المسائل المحلولة:", totalQuestions.toString(), Colors.black87),
              const Divider(height: 20, thickness: 1),
              _buildResultRow("الدرجة:", score.toString(), gradientEndColor, isScore: true),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: gradientEndColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back from marathon page
              },
              child: const Text("حسناً", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultRow(String label, String value, Color valueColor, {bool isScore = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
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

  // Updated Button Builder
  Widget buildKeypadButton(String text, {IconData? icon, Function()? onTap, Color? bgColor, Color? fgColor}) {
    Color buttonColor = bgColor ?? Colors.white;
    Color textColor = fgColor ?? keypadTextColor;
    Widget child;

    if (icon != null) {
      child = Icon(icon, color: textColor, size: 28); // Slightly larger icon size
    } else {
      child = Text(
        text,
        style: TextStyle(
          fontSize: 28, // Slightly larger font size
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
              color: Colors.grey.withOpacity(0.15),
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
    // Define max/min multipliers relative to screen width
    const double maxMultiplier = 0.09; // For 2 items
    const double minMultiplier = 0.06; // For 10 items
    // Define absolute min/max font sizes
    const double absoluteMinSize = 22.0;
    const double absoluteMaxSize = 40.0;

    // Clamp number of items between 2 and 10
    int clampedNumItems = numItems.clamp(2, 10);

    // Calculate scale factor (0 for 2 items, 1 for 10 items)
    double scaleFactor = (clampedNumItems - 2) / (10 - 2);

    // Interpolate the multiplier
    double currentMultiplier = maxMultiplier - (maxMultiplier - minMultiplier) * scaleFactor;

    // Calculate font size based on screen width and multiplier
    double calculatedSize = screenWidth * currentMultiplier;

    // Clamp the final size between absolute min and max
    return calculatedSize.clamp(absoluteMinSize, absoluteMaxSize);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;

    // --- Layout Adjustments --- 
    // Calculate dynamic font size based on current number of items
    double questionFontSize = _calculateDynamicFontSize(questionItems.length, screenSize.width);

    // Calculate dynamic line height based on font size
    double questionLineHeight = 1.4 - (questionFontSize - 22) * 0.01; // Example: taller for smaller fonts
    questionLineHeight = questionLineHeight.clamp(1.1, 1.4); // Clamp line height

    final questionTextStyle = TextStyle(
      fontSize: questionFontSize, 
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: questionLineHeight, // Use dynamic line height
      shadows: [Shadow(blurRadius: 1, color: Colors.black.withOpacity(0.15), offset: Offset(1,1))]
    );

    // Calculate available height for keypad (remains similar)
    double topBarHeight = 55 + safeAreaPadding.top + 20; // Approx height of top bar + padding
    double questionSectionHeightEstimate = screenSize.height * 0.5; // Give more space to question area
    double keypadAvailableHeight = screenSize.height - topBarHeight - questionSectionHeightEstimate - safeAreaPadding.bottom;
    if (keypadAvailableHeight < screenSize.height * 0.3) keypadAvailableHeight = screenSize.height * 0.3;
    
    double keypadButtonHeight = (keypadAvailableHeight / 4) - 12; // 4 rows, adjust spacing
    double keypadButtonWidth = (screenSize.width - 40 - 20) / 3; // width - horizontal padding - grid spacing
    double keypadAspectRatio = (keypadButtonWidth > 0 && keypadButtonHeight > 0) ? keypadButtonWidth / keypadButtonHeight : 1.2; // Default aspect ratio
    // --- End Layout Adjustments ---

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent keyboard overlap issues
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientStartColor, gradientEndColor],
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
                    // Top Bar (Timer and Close Button) - Remains at the top
                    Padding(
                      padding: EdgeInsets.only(
                        top: safeAreaPadding.top + 10,
                        left: 25,
                        right: 25,
                        bottom: 5, // Reduced bottom padding
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 55, height: 55,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 6,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                CircularProgressIndicator(
                                  value: totalTime / 60,
                                  strokeWidth: 6,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                                Text(
                                  "$totalTime",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 26),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Question & Answer Area - Takes remaining space above keypad
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter, // Align content to the top center
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0), // Removed vertical padding
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Take minimum space needed
                          children: [
                            // Vertical list of numbers - Starts right below top bar
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: questionItems.map((item) {
                                String displayValue = item.isNegative
                                    ? "-${item.number}"
                                    : item.number.toString();
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.5), // Further reduce vertical padding
                                  child: Text(
                                    displayValue,
                                    style: questionTextStyle, // Use dynamic text style
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10), // Reduced space before line
                            // Container for the line and answer
                            Container(
                              constraints: BoxConstraints(maxWidth: screenSize.width * 0.6), // Limit width
                              child: Column(
                                children: [
                                  // Ensure line is always visible
                                  Container(
                                    height: 2.0, // Make line slightly thicker
                                    color: Colors.white.withOpacity(0.9),
                                    margin: const EdgeInsets.only(bottom: 10.0), // Reduced margin below line
                                  ),
                                  // Answer Text
                                  Text(
                                    answer.isEmpty ? " " : answer,
                                    style: TextStyle(
                                      // Make answer font size relative to question font size
                                      fontSize: questionFontSize * 1.1, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                    // Keypad Area - Fixed height at the bottom
                    Container(
                      height: keypadAvailableHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: const BorderRadius.only(
                           topLeft: Radius.circular(35),
                           topRight: Radius.circular(35),
                         ),
                      ),
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        childAspectRatio: keypadAspectRatio,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        padding: const EdgeInsets.all(10),
                        children: [
                          // Numbers 1-9
                          ...List.generate(9, (index) {
                            return buildKeypadButton("${index + 1}", onTap: () {
                                if (answer.length < 6) {
                                  setState(() { answer += "${index + 1}"; });
                                }
                              });
                          }),
                          // Row 4: Backspace, 0, Checkmark
                          // Backspace Button (Left)
                          buildKeypadButton(
                            "",
                            icon: Icons.arrow_back, // Use back arrow icon
                            onTap: deleteLastDigit,
                            bgColor: backspaceButtonColor,
                            fgColor: Colors.white,
                          ),
                          // Number 0 (Center)
                          buildKeypadButton("0", onTap: () {
                             if (answer.length < 6) {
                               setState(() { answer += "0"; });
                             }
                           }),
                          // Checkmark Button (Right)
                          buildKeypadButton(
                            "",
                            icon: Icons.check,
                            onTap: checkAnswer,
                            bgColor: checkButtonColor,
                            fgColor: Colors.white,
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


import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Marathon extends StatefulWidget {
  const Marathon({super.key});

  @override
  State<Marathon> createState() => _MarathonState();
}

class _MarathonState extends State<Marathon> {
  int num1 = 0;
  int num2 = 0;
  String operation = "+";
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
    num1 = Random().nextInt(10);
    num2 = Random().nextInt(10);
    List<String> operations = ["+", "-"];
    operation = operations[Random().nextInt(operations.length)];
    if (operation == "-" && num1 < num2) {
      int temp = num1;
      num1 = num2;
      num2 = temp;
    }
    answer = "";
  }

  int calculateAnswer() {
    return operation == "+" ? num1 + num2 : num1 - num2;
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
                color: Colors.grey.shade700, // Adjusted title color
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
                backgroundColor: gradientEndColor, // Use consistent color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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

  Widget buildNumberButton(String number, {Color? buttonColor, Color? textColor, IconData? icon, Function()? onTap}) {
    // Determine colors based on button type
    Color bgColor = Colors.white;
    Color fgColor = keypadTextColor;
    IconData? btnIcon;

    if (icon == Icons.backspace_outlined) {
      bgColor = backspaceButtonColor;
      fgColor = Colors.white;
      btnIcon = Icons.arrow_back; // Use simple back arrow
    } else if (icon == Icons.check) { // Changed icon check
      bgColor = checkButtonColor;
      fgColor = Colors.white;
      btnIcon = Icons.check;
    } else if (buttonColor != null) {
      bgColor = buttonColor;
    }

    if (textColor != null) {
      fgColor = textColor;
    }

    return InkWell(
      onTap: onTap ?? () {
        // Optimize button press response time by removing setState delay
        if (answer.length < 6) {
          setState(() {
            answer += number;
          });
        }
      },
      borderRadius: BorderRadius.circular(18.0), // Slightly more rounded corners like image
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18.0), // Slightly more rounded corners like image
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15), // Adjusted shadow
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: btnIcon != null
            ? Icon(btnIcon, color: fgColor, size: 26) // Adjusted icon size
            : Text(
                number,
                style: TextStyle(
                  fontSize: 26, // Adjusted font size
                  fontWeight: FontWeight.w500, // Adjusted font weight
                  color: fgColor,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    
    // Adjust flex ratio to raise number pad
    final questionAreaFlex = 2; // Reduced from 3 to 2
    final keypadAreaFlex = 5; // Increased from 4 to 5
    
    // Calculate aspect ratio for keypad buttons
    double keypadAspectRatio = (screenSize.width / 3) / (screenSize.height * 0.1);
    double topSectionHeight = screenSize.height * 0.3; // Reduced from 0.4 to 0.3
    double keypadAvailableHeight = screenSize.height - topSectionHeight - safeAreaPadding.top - safeAreaPadding.bottom - 20;
    keypadAspectRatio = (screenSize.width / 3) / (keypadAvailableHeight / 4);

    return Scaffold(
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
                    // Top Bar (Timer and Close Button)
                    Padding(
                      padding: EdgeInsets.only(
                        top: safeAreaPadding.top + 10, // Reduced from 15 to 10
                        left: 25,
                        right: 25,
                        bottom: 10, // Reduced from 15 to 10
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Timer
                          SizedBox(
                            width: 55, height: 55, // Slightly larger timer
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 1.0, // Static background track
                                  strokeWidth: 6, // Thicker track
                                  color: Colors.white.withOpacity(0.2), // Fainter background
                                ), 
                                CircularProgressIndicator(
                                  value: totalTime / 60,
                                  strokeWidth: 6, // Thicker progress arc
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
                          // Close Button
                          InkWell(
                            onTap: () {
                              showResultDialog();
                            },
                            borderRadius: BorderRadius.circular(25), // More rounded
                            child: Container(
                              padding: const EdgeInsets.all(10), // Adjusted padding
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25), // Adjusted opacity
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 26), // Adjusted size
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Question Area
                    Expanded(
                      flex: questionAreaFlex, // Reduced flex to make room for keypad
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$num1 $operation $num2",
                              style: TextStyle(
                                fontSize: screenSize.width * 0.13, // Slightly larger font
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [Shadow(blurRadius: 1, color: Colors.black.withOpacity(0.15), offset: Offset(1,1))]
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15), // Reduced from 20 to 15
                            // Container for the line and answer
                            Container(
                              constraints: BoxConstraints(maxWidth: screenSize.width * 0.5), // Adjusted width
                              child: Column(
                                children: [
                                  // Line only
                                  Container(
                                    height: 1.5, // Line thickness
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  const SizedBox(height: 10), // Space between line and answer
                                  // Answer below the line
                                  Text(
                                    answer.isEmpty ? " " : answer, // Show space if empty for height consistency
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.1, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 3, // Add letter spacing if needed
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
                    // Keypad Area
                    Expanded(
                      flex: keypadAreaFlex, // Increased flex to make keypad taller
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reduced vertical padding from 15 to 10
                        decoration: BoxDecoration(
                           color: Colors.white, // Solid white background
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
                          mainAxisSpacing: 10, // Increased spacing
                          crossAxisSpacing: 10, // Increased spacing
                          padding: const EdgeInsets.all(10), // Reduced padding from 15 to 10
                          children: [
                            ...List.generate(9, (index) {
                              return buildNumberButton("${index + 1}");
                            }),
                            buildNumberButton(
                              "",
                              icon: Icons.backspace_outlined,
                              onTap: deleteLastDigit,
                            ),
                            buildNumberButton("0"),
                            buildNumberButton(
                              "",
                              icon: Icons.check,
                              onTap: checkAnswer,
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

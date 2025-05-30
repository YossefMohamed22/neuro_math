import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:neuro_math/view/sprint_page/sprint_page_logic.dart';

class Sprint extends StatefulWidget {
  const Sprint({super.key});

  @override
  State<Sprint> createState() => _Page1State();
}

class _Page1State extends State<Sprint> {
  List<int> numbers = [];
  List<String> operations = [];
  String answer = "";
  int counter = 3;
  bool showTimer = true;

  int totalTime = 60;
  Timer? countdownTimer;

  int correctAnswers = 0;
  int wrongAnswers = 0;

  SprintPageLogic logic = SprintPageLogic();

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
    logic.cubit.setSuccess("data from sucess");
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          if (counter > 1) {
            counter--;
          } else {
            timer.cancel();
            showTimer = false;
            startCountdown();
          }
        });
      }
    });
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          if (totalTime > 0) {
            totalTime--;
          } else {
            timer.cancel();
            showResultDialog();
          }
        });
      }
    });
  }

  void generateQuestion() {
    List<String> operators = ["+", "-", "×", "÷"];
    int numberCount = Random().nextInt(3) + 2; // 2 أو 3 أو 4 أرقام
    bool hasDivision = false;

    numbers = [];
    operations = [];

    for (int i = 0; i < numberCount; i++) {
      if (i > 0) {
        int opIndex = Random().nextInt(10); // نطاق من 0 إلى 9
        if (!hasDivision && opIndex < 2) {
          // 20% فرصة للقسمة إذا لم تظهر بعد
          operations.add("÷");
          hasDivision = true;
        } else if (opIndex < 5) {
          operations.add("×");
        } else {
          operations.add(operators[Random().nextInt(2)]); // + أو -
        }
      }

      int newNum;
      if (i > 0 && operations.last == "÷") {
        // التأكد من أن القسمة لا تُنتج كسور
        int divisor = Random().nextInt(9) + 1;
        int quotient = Random().nextInt(5) + 1;
        newNum = divisor * quotient;
      } else if (i > 0 && operations.last == "-") {
        // التأكد من أن الناتج لن يكون سالبًا
        newNum = Random().nextInt(numbers.last) + 1;
      } else {
        newNum = Random().nextInt(10) + 1;
      }
      numbers.add(newNum);
    }

    // التأكد من أن الضرب لا يحدث إلا مرة واحدة
    int multiplyCount = operations.where((op) => op == "×").length;
    while (multiplyCount > 1) {
      for (int j = 0; j < operations.length; j++) {
        if (operations[j] == "×" && multiplyCount > 1) {
          operations[j] = operators[Random().nextInt(2)]; // استبدال بـ + أو -
          multiplyCount--;
        }
      }
    }

    answer = "";
  }

  int calculateAnswer() {
    List<int> tempNumbers = List.from(numbers);
    List<String> tempOperations = List.from(operations);

    for (int i = 0; i < tempOperations.length;) {
      if (tempOperations[i] == "×" || tempOperations[i] == "÷") {
        int left = tempNumbers[i];
        int right = tempNumbers[i + 1];
        int result = tempOperations[i] == "×" ? left * right : left ~/ right;
        tempNumbers[i] = result;
        tempNumbers.removeAt(i + 1);
        tempOperations.removeAt(i);
      } else {
        i++;
      }
    }

    int finalResult = tempNumbers[0];
    for (int i = 0; i < tempOperations.length; i++) {
      int nextNum = tempNumbers[i + 1];
      if (tempOperations[i] == "+") {
        finalResult += nextNum;
      } else if (tempOperations[i] == "-") {
        finalResult -= nextNum;
        // منع الأرقام السالبة
        if (finalResult < 0) return 0;
      }
    }

    return finalResult;
  }

  void checkAnswer() {
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
    int totalQuestions = correctAnswers + wrongAnswers;
    int score = correctAnswers;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("النتيجة"),
          content: Text(
            "عدد الإجابات الصحيحة: $correctAnswers\nعدد الإجابات الخاطئة: $wrongAnswers\nعدد المسائل المحلولة: $totalQuestions\nالدرجة: $score",
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget buildNumberButton(String number) {
    return GestureDetector(
      onTap: () {
        setState(() {
          answer += number;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.08,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // بناء المسألة بشكل صحيح
    String question = "";
    for (int i = 0; i < numbers.length; i++) {
      question += "${numbers[i]}";
      if (i < operations.length) {
        question += " ${operations[i]} ";
      }
    }
    question += " = $answer";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (showTimer)
            Center(
              child: Text(
                "$counter",
                style: TextStyle(
                  fontSize: screenWidth * 0.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          if (!showTimer)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.12),
                  alignment: Alignment.center,
                  child: Text(
                    question,
                    style: TextStyle(
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.6,
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: List.generate(9, (index) {
                            return buildNumberButton("${index + 1}");
                          }),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: deleteLastDigit,
                              child: Container(
                                height: screenHeight * 0.11,
                                color: Colors.red,
                                child: const Center(
                                  child: Icon(
                                    Icons.backspace,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  answer += "0";
                                });
                              },
                              child: Container(
                                height: screenHeight * 0.11,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                ),
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.08,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: checkAnswer,
                              child: Container(
                                height: screenHeight * 0.11,
                                color: Colors.green,
                                child: const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.05,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: totalTime / 60,
                  strokeWidth: 6,
                  color: Colors.black,
                ),
                Text(
                  "$totalTime",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                showResultDialog();
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Marathon extends StatefulWidget {
  const Marathon({super.key});

  @override
  State<Marathon> createState() => _Page1State();
}

class _Page1State extends State<Marathon> {
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

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
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
    int score = correctAnswers; // كل سؤال بدرجة واحدة
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
              children: [
                Container(
                  padding: EdgeInsets.only(top: kToolbarHeight+50),
                  alignment: Alignment.center,
                  child: Column(
                    spacing: 5,
                    children: [
                      Text(
                        "$num1",
                        style: TextStyle(
                          fontSize: screenWidth * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "$operation $num2",
                        style: TextStyle(
                          fontSize: screenWidth * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Divider( thickness: 2,color: Colors.black,),
                      ),
                      Text(
                        answer,
                        style: TextStyle(
                          fontSize: screenWidth * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
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

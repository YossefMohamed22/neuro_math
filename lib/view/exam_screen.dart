

// import 'dart:async';
// import 'package:flutter/material.dart';

// import 'home/home_page.dart';


// class ExamPage extends StatefulWidget {
//   final List<Map<String, String>> questions; // قائمة الأسئلة القادمة من الإدمن
//   final int examTime; // وقت الامتحان الذي يحدده الإدمن

//   const ExamPage({super.key, required this.questions, required this.examTime});

//   @override
//   State<ExamPage> createState() => _ExamPageState();
// }

// class _ExamPageState extends State<ExamPage> {
//   int currentQuestionIndex = 0;
//   String answer = "";
//   bool showTimer = true;
//   int counter = 3; // عداد البداية
//   Timer? countdownTimer;
//   int totalTime = 0; // سيتم تحديثه بقيمة `examTime`
//   List<String> studentAnswers = [];
//   int correctAnswers = 0;
//   int wrongAnswers = 0;

//   @override
//   void initState() {
//     super.initState();
//     totalTime = widget.examTime; // تحديد وقت الامتحان من الإدمن
//     startCountdown();
//   }

//   void startCountdown() {
//     Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       if (mounted) {
//         setState(() {
//           if (counter > 1) {
//             counter--;
//           } else {
//             timer.cancel();
//             showTimer = false;
//             startExamTimer();
//           }
//         });
//       }
//     });
//   }

//   void startExamTimer() {
//     countdownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       if (mounted) {
//         setState(() {
//           if (totalTime > 0) {
//             totalTime--;
//           } else {
//             timer.cancel();
//             submitExam();
//           }
//         });
//       }
//     });
//   }

//   void submitAnswer() {
//     if (answer.isNotEmpty) {
//       studentAnswers.add(answer);
//       // التحقق من صحة الإجابة
//       String correctAnswer = widget.questions[currentQuestionIndex]['answer']!;
//       if (answer == correctAnswer) {
//         correctAnswers++;
//       } else {
//         wrongAnswers++;
//       }

//       answer = "";
//       if (currentQuestionIndex < widget.questions.length - 1) {
//         setState(() {
//           currentQuestionIndex++;
//         });
//       } else {
//         submitExam();
//       }
//     }
//   }

//   void submitExam() {
//     countdownTimer?.cancel(); // إيقاف المؤقت

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("نتيجة الامتحان"),
//           content: Text(
//             "عدد الإجابات الصحيحة: $correctAnswers\n"
//             "عدد الإجابات الخاطئة: $wrongAnswers\n"
//             "إجمالي الأسئلة: ${widget.questions.length}\n"
//             "الدرجة النهائية: $correctAnswers",
//             style:
//                 TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context) => const HomePage()),
//                   (Route<dynamic> route) => false,
//                 );
//               },
//               child: const Text("موافق"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void deleteLastDigit() {
//     if (answer.isNotEmpty) {
//       setState(() {
//         answer = answer.substring(0, answer.length - 1);
//       });
//     }
//   }

//   Widget buildNumberButton(String number) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           answer += number;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black, width: 0.5),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           number,
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.08,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     var screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           if (showTimer)
//             Center(
//               child: Text(
//                 "$counter",
//                 style: TextStyle(
//                   fontSize: screenWidth * 0.2,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           if (!showTimer)
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(screenWidth * 0.12),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "${widget.questions[currentQuestionIndex]['question']} = $answer",
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.1,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(
//                   height: screenHeight * 0.6,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: GridView.count(
//                           padding: EdgeInsets.zero,
//                           crossAxisCount: 3,
//                           childAspectRatio: 1.2,
//                           mainAxisSpacing: 2,
//                           crossAxisSpacing: 2,
//                           children: List.generate(9, (index) {
//                             return buildNumberButton("${index + 1}");
//                           }),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: deleteLastDigit,
//                               child: Container(
//                                 height: screenHeight * 0.11,
//                                 color: Colors.red,
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.backspace,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   answer += "0";
//                                 });
//                               },
//                               child: Container(
//                                 height: screenHeight * 0.11,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: Colors.black, width: 0.5),
//                                 ),
//                                 child: Text(
//                                   "0",
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.08,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: submitAnswer,
//                               child: Container(
//                                 height: screenHeight * 0.11,
//                                 color: Colors.green,
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.check,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           Positioned(
//             top: screenHeight * 0.05,
//             left: screenWidth * 0.05,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   value: totalTime / widget.examTime,
//                   strokeWidth: 6,
//                   color: Colors.black,
//                 ),
//                 Text(
//                   "$totalTime",
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.05,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: screenHeight * 0.05,
//             right: screenWidth * 0.05,
//             child: IconButton(
//               icon: const Icon(
//                 Icons.close,
//                 color: Colors.black,
//               ),
//               onPressed: submitExam,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:neuro_math/view/admin_page/tabs/make_exam_tab/make_exam.dart'; // Import the MakeExam widget
// import 'package:neuro_math/view/admin_page/tabs/make_training_tab/make_training.dart'; // Import the new MakeTraining widget
// import 'package:neuro_math/view/admin_page/widgets/students_number_widget.dart';
// import 'package:neuro_math/view/auth/views/login/login.dart';

// class AdminScreen extends StatefulWidget {
//   const AdminScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _AdminScreenState createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   // Removed unused variables related to old exam/student setup
//   // TextEditingController usernameController = TextEditingController();
//   // TextEditingController passwordController = TextEditingController();
//   // List<Map<String, String>> questions = [];
//   // TextEditingController questionController = TextEditingController();
//   // TextEditingController correctAnswerController = TextEditingController();
//   // TextEditingController timeController = TextEditingController();
//   // List<String> selectedStudents = [];
//   // List<String> allStudents = ['student1', 'student2', 'student3'];

//   // بيانات الطلاب (مؤقتًا للتجربة) - Kept for the student data tab
//   List<Map<String, dynamic>> studentData = [
//     {
//       "name": "student1",
//       "correctAnswers": 5,
//       "wrongAnswers": 2,
//       "level": 15,
//       "lastLogin": "2025-02-25 10:30"
//     },
//     {
//       "name": "student2",
//       "correctAnswers": 3,
//       "wrongAnswers": 4,
//       "level": 10,
//       "lastLogin": "2025-02-26 12:45"
//     },
//     {
//       "name": "student3",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student4",
//       "correctAnswers": 8,
//       "wrongAnswers": 0,
//       "level": 10,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student5",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student6",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student7",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student8",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student9",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student10",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student11",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student12",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student13",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//     {
//       "name": "student14",
//       "correctAnswers": 6,
//       "wrongAnswers": 1,
//       "level": 8,
//       "lastLogin": "2025-02-27 08:20"
//     },
//   ];

//   @override
//   void dispose() {
//     // Dispose only necessary controllers if any are added back
//     super.dispose();
//   }

//   // Removed unused methods: createStudentAccount, addQuestion, deleteQuestion, sendExam

//   // دالة لتسجيل الخروج
//   void logout() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => const LoginScreen()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // Updated length to 3 for the new tab
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text("لوحة تحكم الأدمن"),
//           backgroundColor: Colors.white,
//           actions: [
//             IconButton(
//                 icon: const Icon(Icons.logout),
//                 onPressed: logout,
//                 tooltip: "تسجيل الخروج"),
//           ],
//           bottom: const TabBar(
//             tabs: [
//               Tab(icon: Icon(Icons.quiz), text: "إعداد امتحان"),
//               Tab(
//                   icon: Icon(Icons.model_training),
//                   text: "إعداد تدريبات"), // New Tab for Training Setup
//               Tab(icon: Icon(Icons.person), text: "بيانات الطلاب"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Tab 1: Exam Setup (Using the new MakeExam widget)
//             const MakeExam(),

//             // Tab 2: Training Setup (Using the new MakeTraining widget)
//             const MakeTraining(),

//             // Tab 3: Student Data (Existing implementation)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 StudentsNumberWidget(
//                   studentsNumber: studentData.length,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: studentData.length,
//                     itemBuilder: (context, index) {
//                       final student = studentData[index];
//                       return Container(
//                         padding: const EdgeInsetsDirectional.only(
//                             start: 18, top: 16, bottom: 16),
//                         margin: const EdgeInsets.only(bottom: 10),
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                   color:
//                                       const Color(0xFF000000).withOpacity(0.25),
//                                   offset: const Offset(0, 4),
//                                   blurRadius: 4)
//                             ],
//                             border: Border.all(
//                               color: const Color(0xFF9EA2A6),
//                             )),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           // spacing: 5, // Column doesn't have spacing, use SizedBox instead if needed
//                           children: [
//                             Text("${student['name']}",
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w400,
//                                 )),
//                             Text(
//                               " المستوى :${student['level']}",
//                               textAlign: TextAlign.start,
//                             ),
//                             Text(
//                                 "عدد الإجابات الصحيحة: ${student['correctAnswers']}"),
//                             Text(
//                                 "عدد الإجابات الخاطئة: ${student['wrongAnswers']}"),
//                             Text("آخر تسجيل دخول: ${student['lastLogin']}"),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

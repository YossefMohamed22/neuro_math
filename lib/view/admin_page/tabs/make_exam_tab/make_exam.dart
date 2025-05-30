// import 'package:flutter/material.dart';

// class MakeExam extends StatefulWidget {
//   const MakeExam({super.key});

//   @override
//   State<MakeExam> createState() => _MakeExamState();
// }

// class _MakeExamState extends State<MakeExam> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _questionController = TextEditingController();
//   final TextEditingController _answerController = TextEditingController();
//   int? _selectedLevel;
//   final List<int> _levels = List<int>.generate(10, (index) => index + 1); // Levels 1 to 10

//   @override
//   void dispose() {
//     _questionController.dispose();
//     _answerController.dispose();
//     super.dispose();
//   }

//   void _submitExamQuestion() {
//     if (_formKey.currentState!.validate()) {
//       // TODO: Implement logic to save the exam question, answer, and selected level
//       String question = _questionController.text;
//       String answer = _answerController.text;
//       int level = _selectedLevel!;

//       print('Saving Exam Question:');
//       print('Level: $level');
//       print('Question: $question');
//       print('Answer: $answer');

//       // Show a confirmation message (optional)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('تم حفظ سؤال الامتحان للمستوى $level')),
//       );

//       // Clear the form
//       _formKey.currentState!.reset();
//       _questionController.clear();
//       _answerController.clear();
//       setState(() {
//         _selectedLevel = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: ListView( // Use ListView to prevent overflow on smaller screens
//           children: [
//             Text(
//               'إضافة سؤال امتحان جديد',
//               style: Theme.of(context).textTheme.headlineSmall,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             // Question Input
//             TextFormField(
//               controller: _questionController,
//               decoration: const InputDecoration(
//                 labelText: 'السؤال',
//                 border: OutlineInputBorder(),
//                 alignLabelWithHint: true, // Better for multi-line
//               ),
//               maxLines: 3,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'الرجاء إدخال السؤال';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             // Answer Input
//             TextFormField(
//               controller: _answerController,
//               decoration: const InputDecoration(
//                 labelText: 'الإجابة الصحيحة',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'الرجاء إدخال الإجابة الصحيحة';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             // Level Selection
//             DropdownButtonFormField<int>(
//               value: _selectedLevel,
//               hint: const Text('اختر المستوى'),
//               decoration: const InputDecoration(
//                 labelText: 'المستوى',
//                 border: OutlineInputBorder(),
//               ),
//               items: _levels.map((int level) {
//                 return DropdownMenuItem<int>(
//                   value: level,
//                   child: Text('المستوى $level'),
//                 );
//               }).toList(),
//               onChanged: (int? newValue) {
//                 setState(() {
//                   _selectedLevel = newValue;
//                 });
//               },
//               validator: (value) {
//                 if (value == null) {
//                   return 'الرجاء اختيار المستوى';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 24),
//             // Submit Button
//             ElevatedButton(
//               onPressed: _submitExamQuestion,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: const Text('حفظ السؤال'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

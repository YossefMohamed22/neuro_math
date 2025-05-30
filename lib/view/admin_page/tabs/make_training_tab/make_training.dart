// import 'package:flutter/material.dart';

// class MakeTraining extends StatefulWidget {
//   const MakeTraining({super.key});

//   @override
//   State<MakeTraining> createState() => _MakeTrainingState();
// }

// class _MakeTrainingState extends State<MakeTraining> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _questionController = TextEditingController();
//   final TextEditingController _answerController = TextEditingController();
//   final TextEditingController _questionCountController = TextEditingController(); // Controller for question count
//   int? _selectedLevel;
//   final List<int> _levels = List<int>.generate(10, (index) => index + 1); // Levels 1 to 10

//   @override
//   void dispose() {
//     _questionController.dispose();
//     _answerController.dispose();
//     _questionCountController.dispose(); // Dispose the new controller
//     super.dispose();
//   }

//   void _submitTrainingQuestion() {
//     if (_formKey.currentState!.validate()) {
//       // TODO: Implement logic to save the training question, answer, level, and question count
//       String question = _questionController.text;
//       String answer = _answerController.text;
//       int level = _selectedLevel!;
//       int questionCount = int.tryParse(_questionCountController.text) ?? 0; // Get question count

//       print('Saving Training Question:');
//       print('Level: $level');
//       print('Question: $question');
//       print('Answer: $answer');
//       print('Questions per Session: $questionCount');

//       // Show a confirmation message (optional)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('تم حفظ سؤال التدريب للمستوى $level بعدد $questionCount سؤال لكل جلسة')),
//       );

//       // Clear the form
//       _formKey.currentState!.reset();
//       _questionController.clear();
//       _answerController.clear();
//       _questionCountController.clear();
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
//         child: ListView( // Use ListView to prevent overflow
//           children: [
//             Text(
//               'إضافة سؤال تدريب جديد',
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
//                 alignLabelWithHint: true,
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
//             // Question Count Input
//             TextFormField(
//               controller: _questionCountController,
//               decoration: const InputDecoration(
//                 labelText: 'عداد الأسئلة (لكل جلسة)', // Label for question count
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number, // Ensure numeric input
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'الرجاء إدخال عدد الأسئلة لكل جلسة';
//                 }
//                 if (int.tryParse(value) == null || int.parse(value) <= 0) {
//                   return 'الرجاء إدخال رقم صحيح أكبر من صفر';
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
//               onPressed: _submitTrainingQuestion,
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

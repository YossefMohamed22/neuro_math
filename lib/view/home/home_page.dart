import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neuro_math/view/home/home_logic.dart';
import 'package:neuro_math/view/multi_operation_page/multi_operations_page.dart';

import '../divided.dart';
import '../marathon.dart';
import '../multiplied.dart';
// Removed Sprint import as it was commented out
// import '../sprint_page/sprint.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  final HomeLogic logic = HomeLogic();

  // Placeholder for student name - replace with actual data retrieval later
  String studentName = "أحمد"; // Example Name

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // TODO: Add logic to upload/save the picked image
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;

    // Define items with labels for the new button design
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.calculate, // Placeholder, replace with actual asset or specific icon
        'label': 'جمع وطرح',
        'page': const Marathon(),
        'asset': 'assets/plus-minus.png' // Keep asset path if needed
      },
      {
        'icon': Icons.close, // Placeholder
        'label': 'ضرب',
        'page': const Multiplied(),
        'asset': 'assets/multiplication.png'
      },
      {
        'icon': Icons.percent, // Placeholder, division symbol often uses % or custom icon
        'label': 'قسمة',
        'page': const Divided(),
        'asset': 'assets/division.png'
      },
      {
        'icon': Icons.functions, // Placeholder
        'label': 'متعدد',
        'page': const MultiOperationsPage(),
        'asset': 'assets/math.png'
      },
    ];

    return Scaffold(
      // Apply the gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar with student data icon
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          logic.showStudentDataBottomSheet(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.person_outline, color: Colors.blueGrey.shade700, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Section
              Expanded(
                flex: 3, // Adjust flex for better spacing
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: screenSize.width * 0.15, // Slightly larger avatar
                        backgroundColor: Colors.white.withOpacity(0.8),
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : const AssetImage('assets/login-avatar_12123009.png') // Use a default avatar if needed
                                as ImageProvider,
                        child: _imageFile == null
                            ? Icon(
                                Icons.camera_alt,
                                size: screenSize.width * 0.1,
                                color: Colors.grey.shade400,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      "Hi, $studentName", // Use student name variable
                      style: TextStyle(
                        fontSize: screenSize.width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 3.0, color: Colors.black.withOpacity(0.3), offset: Offset(1, 1))]
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Text(
                      "Choose the type of calculation",
                      style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Grid Section
              Expanded(
                flex: 4, // Adjust flex
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05), // Add horizontal padding
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: screenSize.height * 0.02,
                      crossAxisSpacing: screenSize.width * 0.04,
                      childAspectRatio: 1.0, // Make buttons square
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildButton(
                        context,
                        items[index]['icon'],
                        items[index]['label'],
                        items[index]['page'],
                        items[index]['asset'], // Pass asset path
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Updated button widget
  Widget _buildButton(BuildContext context, IconData icon, String label, Widget page, String assetPath) {
    return Card(
      elevation: 8, // Increased elevation for more shadow
      shadowColor: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // More rounded corners
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Use Image.asset if specific assets are required, otherwise use Icon
              Image.asset(
                assetPath,
                height: 50, // Adjust size as needed
                color: Colors.blueGrey.shade700, // Optional: color tint for consistency
              ),
              // Icon(icon, size: 50, color: Colors.blueGrey.shade700),
              const SizedBox(height: 15),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


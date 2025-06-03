import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:neuro_math/view/home/home_logic.dart';
import 'package:neuro_math/view/multi_operation_page/multi_operations_page.dart';

import '../competitions_page.dart';
import '../divided.dart';
import '../marathon.dart';
import '../multiplied.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  final HomeLogic logic = HomeLogic();
  String studentName = "أحمد";

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('saved_image_path');

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_image_path', savedImage.path);

      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.calculate,
        'label': 'جمع وطرح',
        'page': const Marathon(),
        'asset': 'assets/plus-minus.png'
      },
      {
        'icon': Icons.close,
        'label': 'ضرب',
        'page': const Multiplied(),
        'asset': 'assets/multiplication.png'
      },
      {
        'icon': Icons.percent,
        'label': 'قسمة',
        'page': const Divided(),
        'asset': 'assets/division.png'
      },
      {
        'icon': Icons.functions,
        'label': 'متعدد',
        'page': const MultiOperationsPage(),
        'asset': 'assets/math.png'
      },
    ];

    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, right: 16.0, left: 16.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopBarButton(
                      context,
                      icon: Icons.emoji_events_outlined,
                      label: "المسابقات",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CompetitionsPage()),
                        );
                      },
                    ),
                    _buildTopBarButton(
                      context,
                      icon: Icons.person_outline,
                      onTap: () {
                        logic.showStudentDataBottomSheet(context);
                      },
                      isCircle: true,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: screenSize.width * 0.15,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : const AssetImage(
                                    'assets/login-avatar_12123009.png')
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
                      "Hi, $studentName",
                      style: TextStyle(
                        fontSize: screenSize.width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(1, 1))
                        ],
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Text(
                      "Choose the type of calculation",
                      style: TextStyle(
                          fontSize: screenSize.width * 0.045,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: screenSize.height * 0.02,
                      crossAxisSpacing: screenSize.width * 0.04,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildGridButton(
                        context,
                        items[index]['icon'],
                        items[index]['label'],
                        items[index]['page'],
                        items[index]['asset'],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBarButton(BuildContext context,
      {required IconData icon,
      String? label,
      required Function() onTap,
      bool isCircle = false}) {
    return Material(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(isCircle ? 25 : 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(isCircle ? 25 : 15),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: label != null ? 16.0 : 10.0, vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.blueGrey.shade700, size: 24),
              if (label != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, IconData icon, String label,
      Widget page, String assetPath) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assetPath,
                  height: 50, color: Colors.blueGrey.shade700),
              const SizedBox(height: 15),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade800)),
            ],
          ),
        ),
      ),
    );
  }
}

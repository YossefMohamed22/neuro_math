import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neuro_math/view/competitions_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neuro_math/core/theme/app_themes.dart';
import 'package:neuro_math/core/theme/theme_cubit.dart';
import 'package:neuro_math/view/home/home_logic.dart';
import 'package:neuro_math/view/multi_operation_page/multi_operations_page.dart';
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
  String studentName =
      "Yossef"; // Example Name - TODO: Replace with actual data

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
    // TODO: Load student name from appropriate source
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('saved_image_path');

    if (imagePath != null) {
      final file = File(imagePath);
      if (await file.exists()) {
        // Check if file exists before setting state
        setState(() {
          _imageFile = file;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
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
    } catch (e) {
      // Handle potential errors during image picking/saving
      print("Error picking/saving image: $e");
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء اختيار الصورة.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    // Access gradient colors from theme extension
    final gradients = theme.extension<AppGradients>()!;

    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.calculate,
        'label': 'جمع وطرح',
        'page': const MultiOperationsPage(),
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
        'page': const Marathon(),
        'asset': 'assets/math.png'
      },
    ];

    return Scaffold(
      // Use theme background color
      // backgroundColor: theme.colorScheme.background,
      // Keep gradient for now as requested, but ideally theme controls this
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradients.start, gradients.end], // Use theme gradients
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar with Competitions, Theme Toggle, and Student Data
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, right: 16.0, left: 16.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Competitions Button (Left)
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
                    // Group for Right-side Buttons (Theme Toggle + Student)
                    Row(
                      children: [
                        // Theme Toggle Button (New)
                        _buildTopBarButton(
                          context,
                          // Choose icon based on current theme
                          icon: isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          onTap: () {
                            // Toggle theme using ThemeCubit
                            context.read<ThemeCubit>().toggleTheme();
                          },
                          isCircle:
                              true, // Make it circular like the student button
                        ),
                        const SizedBox(
                            width:
                                8), // Space between toggle and student button
                        // Student Data Button (Right)
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
                  ],
                ),
              ),
              // Profile Section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: screenSize.width * 0.15,
                        backgroundColor:
                            theme.colorScheme.surface.withOpacity(0.8),
                        child: _imageFile != null
                            ? ClipOval(
                                child: SizedBox(
                                  width: screenSize.width * 0.28,
                                  height: screenSize.width * 0.28,
                                  child: Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child: SizedBox(
                                      width: screenSize.width * 0.25,
                                      height: screenSize.width * 0.25,
                                      child: Image.asset(
                                        'assets/login-avatar_128.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.camera_alt,
                                    size: screenSize.width * 0.1,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.5),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: _pickImage,
                    //   child: CircleAvatar(
                    //     radius: screenSize.width * 0.15,
                    //     // Use theme surface color with opacity for background
                    //     backgroundColor:
                    //         theme.colorScheme.surface.withOpacity(0.8),
                    //     backgroundImage: _imageFile != null
                    //         ? FileImage(_imageFile!)
                    //         : const AssetImage('assets/login-avatar_128.png')
                    //             as ImageProvider,
                    //     child: _imageFile == null
                    //         ? Icon(
                    //             Icons.camera_alt,
                    //             size: screenSize.width * 0.1,
                    //             // Use a less prominent color from theme
                    //             color: theme.colorScheme.onSurface
                    //                 .withOpacity(0.5),
                    //           )
                    //         : null,
                    //   ),
                    // ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      "Hi, $studentName",
                      style: TextStyle(
                        fontSize: screenSize.width * 0.07,
                        fontWeight: FontWeight.bold,
                        // Use primary text color from theme (likely white/light on gradient)
                        color: Colors.white, // Keep white for gradient contrast
                        shadows: [
                          Shadow(
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(1, 1))
                        ],
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    Text(
                      "Choose the type of calculation", // Consider translating
                      style: TextStyle(
                          fontSize: screenSize.width * 0.045,
                          // Use secondary text color (likely white70/light grey on gradient)
                          color: Colors
                              .white70), // Keep white70 for gradient contrast
                    ),
                  ],
                ),
              ),
              // Grid Section
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
                      childAspectRatio: 1.0, // Adjust aspect ratio if needed
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildGridButton(
                        context,
                        // items[index]['icon'], // Icon data is not used in the button anymore
                        items[index]['label'],
                        items[index]['page'],
                        items[index]['asset'],
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

  // Helper widget for top bar buttons (Competitions, Theme Toggle, Student Data)
  Widget _buildTopBarButton(BuildContext context,
      {required IconData icon,
      String? label,
      required Function() onTap,
      bool isCircle = false}) {
    final theme = Theme.of(context);
    // Use surface color for button background, onSurface for icon/text
    final backgroundColor = theme.colorScheme.surface.withOpacity(0.8);
    final foregroundColor = theme.colorScheme.onSurface.withOpacity(0.8);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(isCircle ? 25 : 15),
      elevation: 2, // Add slight elevation
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(isCircle ? 25 : 15),
        onTap: onTap,
        child: Padding(
          // Adjust padding based on whether it's circle or rectangle
          padding: EdgeInsets.symmetric(
              horizontal: label != null ? 16.0 : (isCircle ? 10.0 : 16.0),
              vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foregroundColor, size: 24),
              if (label != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                        color: foregroundColor,
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

  // Updated grid button widget using Theme
  Widget _buildGridButton(
      BuildContext context, String label, Widget page, String assetPath) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    // Use primary color for the asset icon for better visibility in both modes
    final assetColor = theme.colorScheme.primary;

    return Card(
      // Use cardTheme properties defined in AppThemes
      // elevation: theme.cardTheme.elevation,
      // shadowColor: theme.cardTheme.shadowColor,
      // shape: theme.cardTheme.shape,
      // color: cardColor, // Card color is handled by theme
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0), // Match card shape
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                assetPath,
                height: 50,
                color: assetColor, // Use themed color
              ),
              const SizedBox(height: 15),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor, // Use themed text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

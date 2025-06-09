import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:neuro_math/core/theme/app_themes.dart'; // Import AppThemes for gradient
import 'package:neuro_math/view/home/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Hashing function (keep for potential future use)
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _showErrorMessage(String message) {
    if (!mounted) return; // Check if the widget is still in the tree
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      String hashedPassword = _hashPassword(password);

      // TODO: Replace hardcoded check with API call for student login
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Simplified student login check (placeholder)
      if (username == "student" &&
          hashedPassword == _hashPassword("student123")) {
        // Navigate to the appropriate student page (e.g., HomePage)
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        _showErrorMessage("اسم المستخدم أو كلمة المرور غير صحيحة.");
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Access gradient colors from theme extension
    final gradients = theme.extension<AppGradients>()!;

    return Scaffold(
      body: Container(
        // Use Gradient from Theme
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradients.start, gradients.end],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome Text - Use white for contrast on gradient
                Text(
                  "مرحباً بعودتك!",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Keep white for gradient contrast
                      shadows: [
                        Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 2))
                      ]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "سجل الدخول للمتابعة",
                  style: TextStyle(
                      fontSize: 18,
                      color:
                          Colors.white70), // Keep white70 for gradient contrast
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Login Form Container - Use theme surface color
                Container(
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surface
                        .withOpacity(0.9), // Use surface color
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Username Field - Use theme input decoration
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: colorScheme.onSurface), // Text color
                          decoration: InputDecoration(
                            labelText: "اسم المستخدم",
                            labelStyle: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.person_outline,
                                color: colorScheme.onSurface.withOpacity(0.6)),
                            // Use fillColor from theme in dark mode, slightly off-white in light
                            filled: true,
                            fillColor: theme.brightness == Brightness.dark
                                ? colorScheme
                                    .surfaceContainerHighest // Use a variant in dark mode
                                : Colors.grey
                                    .shade100, // Keep light grey for light mode
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: colorScheme.primary, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء إدخال اسم المستخدم";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Password Field - Use theme input decoration
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(
                              color: colorScheme.onSurface), // Text color
                          decoration: InputDecoration(
                            labelText: "كلمة المرور",
                            labelStyle: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.lock_outline,
                                color: colorScheme.onSurface.withOpacity(0.6)),
                            filled: true,
                            fillColor: theme.brightness == Brightness.dark
                                ? colorScheme
                                    .surfaceContainerHighest // Use a variant in dark mode
                                : Colors.grey
                                    .shade100, // Keep light grey for light mode
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: colorScheme.primary, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الرجاء إدخال كلمة المرور";
                            } else if (value.length < 6) {
                              return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Login Button - Use theme button style
                        _isLoading
                            ? CircularProgressIndicator(
                                color: colorScheme.primary)
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      colorScheme.primary, // Use primary color
                                  foregroundColor: colorScheme
                                      .onPrimary, // Use onPrimary color
                                  minimumSize: Size(screenSize.width * 0.6, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                ),
                                child: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),

                // Optional: Add 'Forgot Password?' or 'Register' links if needed
                const SizedBox(height: 20),
                // TextButton(
                //   onPressed: () { /* TODO: Implement Forgot Password */ },
                //   child: Text("هل نسيت كلمة المرور؟", style: TextStyle(color: Colors.white70)),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuro_math/core/bloc/universal_bloc.dart';
import 'package:neuro_math/core/bloc/universal_state.dart';
import 'package:neuro_math/view/multi_operation_page/multi_operation_logic.dart';

class KeyboardInputWidget extends StatefulWidget {
  final MultiOperationLogic logic;

  const KeyboardInputWidget({super.key, required this.logic});

  @override
  State<KeyboardInputWidget> createState() => _KeyboardInputWidgetState();
}

class _KeyboardInputWidgetState extends State<KeyboardInputWidget> {
  Timer? countdownTimer;
  int totalTime = 60;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (totalTime > 0) {
          totalTime--;
        } else {
          timer.cancel();
          // Optionally trigger end state via logic
          // widget.logic.endChallenge();
        }
      });
    });
  }

  // Button Builder (adapted for landscape multi-op page)
  // Changed onTap type from Function()? to VoidCallback?
  Widget buildKeypadButton(String text,
      {IconData? icon,
      VoidCallback? onTap,
      Color? iconColor,
      double? fontSize,
      double? iconSize,
      Color? backgroundColor,
      Color? textColor}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Define colors based on theme
    final Color defaultTextColor = isDarkMode ? Colors.white : Colors.grey.shade800;
    final Color defaultIconColor = iconColor ?? defaultTextColor;
    final Color defaultBackgroundColor = backgroundColor ?? (isDarkMode ? Colors.black : Colors.white);
    
    // Use provided colors or defaults
    Color effectiveIconColor = iconColor ?? defaultIconColor;
    Color effectiveBackgroundColor = backgroundColor ?? defaultBackgroundColor;
    Color effectiveTextColor = textColor ?? defaultTextColor;
    
    Widget child;
    double effectiveFontSize = fontSize ?? 24; // Slightly smaller default font size
    double effectiveIconSize = iconSize ?? 24; // Slightly smaller default icon size

    if (icon != null) {
      child = Icon(icon, color: effectiveIconColor, size: effectiveIconSize);
    } else {
      child = Text(
        text,
        style: TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w500,
          color: effectiveTextColor,
        ),
      );
    }

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0), // Smaller radius
        child: Container(
          margin: const EdgeInsets.all(3.0), // Reduced margin
          decoration: BoxDecoration(
            color: effectiveBackgroundColor, // Use effective background color
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Define colors based on theme
    final Color backspaceIconColor = const Color(0xFFF87070); // Coral red for icon
    final Color checkIconColor = const Color(0xFF63C9A8); // Teal green for icon
    final Color keypadTextColor = isDarkMode ? Colors.white : Colors.grey.shade800;
    final Color buttonBackgroundColor = isDarkMode ? Colors.black : Colors.white;
    final Color speedButtonIconColor = isDarkMode ? Colors.white : Colors.grey.shade600;
    final Color closeButtonBackgroundColor = isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8);
    final Color closeButtonIconColor = isDarkMode ? Colors.white : Colors.grey.shade700;
    final Color containerBackgroundColor = isDarkMode ? Colors.black : Colors.white;
    final Color timerTextColor = isDarkMode ? Colors.white : Colors.grey.shade800;
    final Color dividerColor = isDarkMode ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.3);
    
    // Add slight padding around the entire right panel to show rounded corners
    return Padding(
      padding: const EdgeInsets.only(
          left: 5.0,
          top: 5.0,
          bottom: 5.0,
          right: 10.0), // Adjust padding as needed
      child: ClipRRect(
        // Use ClipRRect to ensure content respects the rounded corners
        borderRadius: BorderRadius.circular(15.0), // Apply rounded corners here
        child: Container(
          decoration: BoxDecoration(
            color: containerBackgroundColor, // Use theme-based background color
            borderRadius: BorderRadius.circular(15.0), // Apply rounded corners
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 40,
                    bottom: 10,
                    left: 10,
                    right: 10), // Add padding, leave space for close button
                child: Column(
                  children: [
                    // Top section: Answer display and Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Answer Display Area
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 15), // Increased horizontal padding
                            alignment: Alignment.center, // Align answer center
                            child: BlocBuilder<UniversalCubit<String>,
                                UniversalState<String>>(
                              bloc: widget.logic.resultCubit,
                              builder: (context, state) {
                                return Text(
                                  state.maybeWhen(
                                      success: (data) =>
                                          data.isEmpty ? " " : data,
                                      orElse: () => " "),
                                  style: TextStyle(
                                    fontSize:
                                        28, // Slightly larger size for centered text
                                    fontWeight: FontWeight.w600,
                                    color: keypadTextColor,
                                    letterSpacing:
                                        2.0, // Increased letter spacing
                                  ),
                                  textAlign: TextAlign
                                      .center, // Ensure text itself is centered
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                        ),
                        // Timer
                        Padding(
                          padding: const EdgeInsets.only(
                              right:
                                  10.0), // Add padding to the right of the timer
                          child: SizedBox(
                            width: 40, height: 40, // Adjust size
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 4,
                                  color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                                ),
                                CircularProgressIndicator(
                                  value: totalTime / 60,
                                  strokeWidth: 4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.8)), // Use theme color
                                ),
                                Text(
                                  "$totalTime",
                                  style: TextStyle(
                                    fontSize: 14, // Adjust size
                                    fontWeight: FontWeight.bold,
                                    color: timerTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 15, thickness: 1, color: dividerColor),
                    // Keypad Grid - Using Rows and Columns for precise layout
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Distribute rows evenly
                        children: [
                          // Row 1: 1, 2, 3, Backspace
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildKeypadButton("1",
                                    onTap: () =>
                                        widget.logic.updateResult("1"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                buildKeypadButton("2",
                                    onTap: () =>
                                        widget.logic.updateResult("2"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                buildKeypadButton("3",
                                    onTap: () =>
                                        widget.logic.updateResult("3"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                buildKeypadButton("",
                                    icon: Icons.backspace_outlined,
                                    onTap: widget.logic.deleteLastDigit,
                                    iconColor: Colors.white,
                                    backgroundColor: backspaceIconColor),
                              ],
                            ),
                          ),
                          // Row 2: 4, 5, 6, Check
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildKeypadButton("4",
                                    onTap: () =>
                                        widget.logic.updateResult("4"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                buildKeypadButton("5",
                                    onTap: () =>
                                        widget.logic.updateResult("5"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                buildKeypadButton("6",
                                    onTap: () =>
                                        widget.logic.updateResult("6"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                buildKeypadButton("",
                                    icon: Icons.check_circle_outline,
                                    onTap: widget.logic.checkAnswer,
                                    iconColor: Colors.white,
                                    backgroundColor: checkIconColor),
                              ],
                            ),
                          ),
                          // Row 3: 7, 8, 9, Speed
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildKeypadButton("7",
                                    onTap: () =>
                                        widget.logic.updateResult("7"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                buildKeypadButton("8",
                                    onTap: () =>
                                        widget.logic.updateResult("8"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                buildKeypadButton("9",
                                    onTap: () =>
                                        widget.logic.updateResult("9"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                BlocBuilder<UniversalCubit<int>,
                                    UniversalState<int>>(
                                  bloc: widget.logic.durationFastCubit,
                                  builder: (context, state) {
                                    int speed = state.maybeWhen(
                                        success: (data) => data,
                                        orElse: () => 1);
                                    Color speedButtonBgColor =
                                        isDarkMode ? Colors.black : Colors.white; // Default based on theme
                                    if (speed == 2) {
                                      speedButtonBgColor =
                                          Colors.yellow.shade600;
                                    } else if (speed == 3) {
                                      speedButtonBgColor = Colors.red.shade400;
                                    }
                                    // Use text for speed button for clarity
                                    return buildKeypadButton(
                                      "x$speed",
                                      icon: Icons.speed_outlined,
                                      onTap: widget.logic.inCreaseSpeed,
                                      iconColor: speed == 1
                                          ? speedButtonIconColor
                                          : Colors
                                              .white, // White icon on colored background
                                      iconSize: 20,
                                      backgroundColor:
                                          speedButtonBgColor, // Dynamic background color
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Row 4: (Empty), 0, (Empty), (Empty)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Spacer(), // Placeholder
                                buildKeypadButton("0",
                                    onTap: () =>
                                        widget.logic.updateResult("0"),
                                    textColor: keypadTextColor,
                                    backgroundColor: buttonBackgroundColor),
                                const Spacer(), // Placeholder
                                const Spacer(), // Placeholder
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Close Button (Positioned top-right INSIDE the white container)
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: closeButtonBackgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ]),
                    child: Icon(Icons.close,
                        color: closeButtonIconColor, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

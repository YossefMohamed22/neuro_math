
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neuro_math/core/theme/app_themes.dart'; // Import AppThemes for gradient
import 'package:neuro_math/view/multi_operation_page/multi_operation_logic.dart';
import 'package:neuro_math/view/multi_operation_page/widgets/keyboard_input_widget.dart';
import 'package:neuro_math/view/multi_operation_page/widgets/vertical_ticker.dart';

class MultiOperationsPage extends StatefulWidget {
  const MultiOperationsPage({super.key});

  @override
  State<MultiOperationsPage> createState() => _MultiOperationsPageState();
}

class _MultiOperationsPageState extends State<MultiOperationsPage> {
  final MultiOperationLogic logic = MultiOperationLogic();
  bool _showCountdown = true;
  int _countdownValue = 3;
  Timer? _timer;

  // Colors will be derived from Theme
  // final Color gradientStartColor = const Color(0xFF6A82FB);
  // final Color gradientEndColor = const Color(0xFFB477F8);

  @override
  void initState() {
    super.initState();
    logic.resultCubit.setSuccess("");
    // Ensure landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    startPreGameCountdown();
  }

  void startPreGameCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdownValue > 1) {
          _countdownValue--;
        } else {
          _showCountdown = false;
          timer.cancel();
          // Start the actual game logic/timers if needed here
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Revert to portrait when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // logic.dispose(); // Dispose logic resources if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<AppGradients>()!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradients.start, gradients.end], // Use theme gradients
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _showCountdown
              ? Center(
                  child: Text(
                    '$_countdownValue',
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Keep white for contrast on gradient
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    // Vertical Ticker on the left
                    Expanded(
                      flex: 1, // Adjust flex factor as needed
                      child: VerticalTicker(logic: logic),
                    ),
                    // Keyboard Input on the right
                    Expanded(
                      flex: 1, // Adjust flex factor as needed
                      child: KeyboardInputWidget(logic: logic),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}


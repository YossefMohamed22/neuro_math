import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    logic.resultCubit.setSuccess("");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(child: VerticalTicker(logic: logic)),
          Expanded(
              child: KeyboardInputWidget(
            logic: logic,
          ))
        ],
      ),
    );
  }
}

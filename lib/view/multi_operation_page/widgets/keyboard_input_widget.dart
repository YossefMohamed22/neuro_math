import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuro_math/core/bloc/universal_bloc.dart';
import 'package:neuro_math/core/bloc/universal_state.dart';
import 'package:neuro_math/view/multi_operation_page/multi_operation_logic.dart';
import 'package:neuro_math/view/multi_operation_page/widgets/cloce_icon_widget.dart';

class KeyboardInputWidget extends StatelessWidget {
  final MultiOperationLogic logic;

  const KeyboardInputWidget({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 99,
                child: BlocBuilder<UniversalCubit<String>, UniversalState<String>>(
                  bloc: logic.resultCubit,
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox(),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      success: (data) => Center(
                        child: Text(
                          data,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      failure: (error) => Text('Error: $error'),
                    );
                  },
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.68,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0.9,
                              ),
                              itemCount: 9,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () => logic.updateResult("${index + 1}"),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      top: BorderSide(color: Colors.black, width: 0.5),
                                      left: BorderSide(color: Colors.black, width: 0.5),
                                      right: (index + 1) % 3 == 0
                                          ? BorderSide.none
                                          : BorderSide(color: Colors.black, width: 0.5),
                                      bottom: BorderSide(color: Colors.black, width: 0.5),
                                    ),
                                  ),
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => logic.updateResult("0"),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black, width: 0),
                                    ),
                                    child: const Text(
                                      "0",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => logic.updateResult("."),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: _buildGrey(), border: Border.all(color: Colors.black, width: 0.5)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 23.4,
                          ),
                          GestureDetector(
                            onTap: () => logic.resultCubit.setSuccess(""),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 0.5),
                                color: Colors.red,
                              ),
                              child: const Icon(Icons.close, color: Colors.black, size: 20),
                            ),
                          ),
                          BlocBuilder<UniversalCubit<int>, UniversalState<int>>(
                            bloc: logic.durationFastCubit,
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () => logic.inCreaseSpeed(),
                                child: state.when(
                                  initial: () => SizedBox(),
                                  loading: () => SizedBox(),
                                  success: (data) {
                                    return Container(
                                      height: 80,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: _buildGrey(),
                                        border: Border.symmetric(
                                          vertical: BorderSide(color: Colors.black, width: 0.5),
                                        ),
                                      ),
                                      child: Text("Speed x$data",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                  failure: (error) => SizedBox(),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => logic.resultCubit.setSuccess(""),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(color: Colors.black, width: 0.5),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.check, color: Colors.black, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        CloceIconWidget()
      ],
    );
  }

  Color _buildGrey() => Colors.grey.withOpacity(0.2);
}

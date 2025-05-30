import 'package:flutter/material.dart';
import 'package:neuro_math/view/multi_operation_page/multi_operation_logic.dart';

class VerticalText extends StatelessWidget {
  final MultiOperationLogic logic;
  const VerticalText({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    // return ScrollableTextIndicator(
    //   text: Text(
    //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam pulvinar risus sit amet augue viverra ultrices. Aliquam erat volutpat. Proin sagittis ultricies blandit. Donec diam velit, vestibulum commodo leo eu, suscipit condimentum ante. Aenean laoreet sapien mauris. Praesent maximus sagittis felis auctor facilisis. In ullamcorper velit id leo semper, pellentesque luctus risus efficitur. Aenean et tristique diam, vitae volutpat mi. Morbi bibendum ut nibh a ornare. Nulla nec dolor pellentesque, gravida neque ut, condimentum augue. Phasellus mollis metus ac tincidunt venenatis. Aenean at ullamcorper massa. Vestibulum volutpat nunc ut ultrices facilisis. Cras dui lorem, vehicula eu hendrerit non, sollicitudin quis libero. Morbi dapibus libero tincidunt lobortis efficitur.',
    //     style: TextStyle(
    //       color: Colors.black,
    //       fontSize: 16.0,
    //     ),
    //   ),
    // );
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: logic.scrollController,
              child: Text(''),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          SizedBox(
            width: 6.0,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 1.0,
                  color: Colors.black,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

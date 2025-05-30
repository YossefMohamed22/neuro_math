import 'package:flutter/material.dart';

import 'package:neuro_math/core/http/general_states.dart';

import 'package:neuro_math/view/home/widgets/student_data_bottom_sheet_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeLogic {
  HomeLogic() {
    // setData();
  }

  void showStudentDataBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StudentDataBottomSheetWidget();
      },
    );
  }

  void setData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("token");
    GeneralStates.instance.set("token", token);
  }
}

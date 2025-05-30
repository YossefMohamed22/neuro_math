import 'package:flutter/material.dart';

class CloceIconWidget extends StatelessWidget {
  const CloceIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.pop(context),
      child: Container(
        width: 30, height: 30,
        margin: EdgeInsetsDirectional.only(top: 10,end: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle
        ),
        child: Icon(Icons.close_rounded,color: Colors.white,size: 20,),
      ),
    );
  }
}

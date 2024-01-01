import 'package:flutter/material.dart';

class AppStyles {
  static const titleTheme = TextStyle(
    color: Color(0xff015b42),
    fontFamily: 'notoSans',
    fontWeight: FontWeight.w600,
    fontSize: 25
  );
  static Widget AppIconButton({required Icon icon,required Function onTap}){
    return IconButton(
                  onPressed: () {
                    onTap();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Color(0xff1b6c55),
                    surfaceTintColor: Colors.white,
                  ),
                  icon: icon,);
  }
}

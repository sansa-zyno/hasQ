import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 22),
        children: <TextSpan>[
          TextSpan(
              text: 'h',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              )),
          TextSpan(
              text: 'as',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic)),
          TextSpan(
              text: 'Q',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
        ],
      ),
    );
  }
}

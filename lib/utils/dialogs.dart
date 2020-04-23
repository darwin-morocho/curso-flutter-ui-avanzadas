import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialog {
  final BuildContext context;
  ProgressDialog(this.context);

  void show() {
    showDialog(
      context: this.context,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white.withOpacity(0.7),
        child: CupertinoActivityIndicator(
          radius: 15,
        ),
      ),
    );
  }

  void dismiss() {
    Navigator.pop(context);
  }
}

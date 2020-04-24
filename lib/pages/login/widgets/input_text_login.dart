import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ui_avanzadas/utils/app_colors.dart';

class InputTextLogin extends StatefulWidget {
  final String iconPath, placeholder, initValue;
  final bool obscureText;
  final bool Function(String text) validator;

  const InputTextLogin(
      {Key key,
      @required this.iconPath,
      @required this.placeholder,
      this.validator,
      this.obscureText = false,
      this.initValue})
      : assert(iconPath != null && placeholder != null),
        super(key: key);

  @override
  InputTextLoginState createState() => InputTextLoginState();
}

class InputTextLoginState extends State<InputTextLogin> {
  bool _validationOk = false;
  TextEditingController _controller;
  bool get validationOk => _validationOk;
  String get text => _controller.text;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initValue ?? '');
    _checkValidator();
  }

  @override
  void dispose() {
    _controller.text;
    super.dispose();
  }

  void _checkValidator() {
    if (widget.validator != null) {
      final isOk = widget.validator(_controller.text);
      if (isOk != _validationOk) {
        setState(() {
          _validationOk = isOk;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: _controller,
      onChanged: (text) {
        _checkValidator();
      },
      obscureText: widget.obscureText,
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      prefix: Container(
        width: 40,
        height: 30,
        padding: EdgeInsets.all(2),
        child: SvgPicture.asset(
          this.widget.iconPath,
          color: Color(0xffcccccc),
        ),
      ),
      placeholder: this.widget.placeholder,
      style: TextStyle(fontFamily: 'sans'),
      placeholderStyle: TextStyle(fontFamily: 'sans', color: Color(0xffcccccc)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xffdddddd),
          ),
        ),
      ),
      suffix: widget.validator != null
          ? Icon(
              Icons.check_circle,
              color: _validationOk ? AppColors.primary : Color(0xffeeeeee),
            )
          : null,
    );
  }
}

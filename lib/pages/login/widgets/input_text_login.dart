import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ui_avanzadas/utils/app_colors.dart';
import 'package:flutter_ui_avanzadas/utils/theme.dart';

class InputTextLogin extends StatefulWidget {
  final String iconPath, placeholder, initValue;
  final bool Function(String text) validator;
  final bool obscureText;

  final TextInputType keyboardType;

  const InputTextLogin(
      {Key key,
      @required this.iconPath,
      @required this.placeholder,
      this.validator,
      this.initValue = '',
      this.obscureText = false,
      this.keyboardType = TextInputType.text})
      : assert(iconPath != null && placeholder != null),
        super(key: key);

  @override
  InputTextLoginState createState() => InputTextLoginState();
}

class InputTextLoginState extends State<InputTextLogin> {
  TextEditingController _controller;
  bool _validationOk = false;

  bool get isOk => _validationOk;
  String get value => _controller.text;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initValue);
    checkValidation();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void checkValidation() {
    if (widget.validator != null) {
      final bool isOk = widget.validator(_controller.text);
      if (_validationOk != isOk) {
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
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: (text) => checkValidation(),
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
      suffix: widget.validator != null
          ? Icon(
              Icons.check_circle,
              color: _validationOk
                  ? AppColors.primary
                  : (AppTheme.instance.darkEnabled
                      ? Color(0xff37474f)
                      : Colors.black12),
            )
          : null,
      placeholder: this.widget.placeholder,
      style: TextStyle(
        fontFamily: 'sans',
        color: AppTheme.instance.darkEnabled ? Colors.white : Colors.black87,
      ),
      placeholderStyle: TextStyle(fontFamily: 'sans', color: Color(0xffcccccc)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppTheme.instance.darkEnabled
                ? Color(0xff37474f)
                : Color(0xffdddddd),
          ),
        ),
      ),
    );
  }
}

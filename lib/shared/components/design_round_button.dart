import 'package:flutter/material.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/components/size_config.dart';

class DesignRoundButton extends StatelessWidget {
  final String? text;
  final Function()? onPress;
  const DesignRoundButton({Key? key, this.text, this.onPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: Colors.white,
            backgroundColor: buttonColor,
          ),
          onPressed: onPress,
          child: Text(
            text!,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

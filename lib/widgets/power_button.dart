import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';

class PowerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String value;

  const PowerButton({super.key, required this.onPressed, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constant.bgPrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(-3, -3),
            blurRadius: 15,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(3, 3),
            blurRadius: 15,
          ),
        ],
      ),
      child: IconButton(
        padding: const EdgeInsets.all(10),
        hoverColor: Constant.bgPrimary,
        focusColor: Constant.bgPrimary,
        splashColor: Constant.bgPrimary,
        highlightColor: Constant.bgPrimary,
        icon: const Icon(Icons.power_settings_new),
        onPressed: () {
          HapticFeedback.mediumImpact();
          onPressed();
        },
        color: value == '0' ? Constant.bgRed : Constant.bgGreen,
        iconSize: 50.sp,
      ),
    );
  }
}

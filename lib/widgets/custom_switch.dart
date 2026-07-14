import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Track colors matching the mockup
    final activeTrackColor = isDark ? const Color(0xFF373A41) : const Color(0xFFECE4F5);
    final inactiveTrackColor = isDark ? const Color(0xFF373A41) : const Color(0xFFEFEFF1);

    // Thumb colors matching the mockup
    final activeThumbColor = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF6226A6);
    final inactiveThumbColor = isDark ? const Color(0xFF67686A) : const Color(0xFF9E9EA0);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 36.0,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: value ? activeTrackColor : inactiveTrackColor,
        ),
        padding: const EdgeInsets.all(3.0),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 14.0,
            height: 14.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? activeThumbColor : inactiveThumbColor,
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'svg_placeholder.dart';

class MenuItemTile extends StatelessWidget {
  final String title;
  final String iconAsset;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  const MenuItemTile({
    Key? key,
    required this.title,
    required this.iconAsset,
    this.trailing,
    this.onTap,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultTextColor = textColor ?? (isDark ? Colors.white : const Color(0xFF242424));
    final defaultIconColor = textColor ?? (isDark ? Colors.white : const Color(0xFF5A5165));

    final trailingWidget = trailing;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero, // Handled by outer card
      child: SizedBox(
        height: 44.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Icon
              SvgPlaceholder(
                assetName: iconAsset,
                color: defaultIconColor,
              ),
              const SizedBox(width: 12.0),

              // Center: Title
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: defaultTextColor,
                  ),
                  child: Text(title),
                ),
              ),

              // Right: Trailing Widget (Dropdown arrow, Switch, etc.)
              if (trailingWidget != null) trailingWidget,
            ],
          ),
        ),
      ),
    );
  }
}



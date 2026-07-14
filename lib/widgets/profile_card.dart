import 'package:flutter/material.dart';
import 'svg_placeholder.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 72.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242527) : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Avatar Container
          Container(
            width: 44.0,
            height: 44.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/Avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/avatar_placeholder.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.purple.shade100,
                        child: Icon(
                          Icons.person,
                          color: Colors.purple.shade700,
                          size: 24,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12.0),

          // User Info (Name & Phone)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFFEFFFF) : const Color(0xFF13171A),
                        height: 1.2,
                      ),
                      child: const Text('Lucía Martínez'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: SvgPlaceholder(
                        assetName: 'edit_icon.svg',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2.0),
                const AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8E8E93),
                  ),
                  child: Text('777 354 75 88'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


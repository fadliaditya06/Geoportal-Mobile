import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedInfoItem extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final String label;
  final int targetNumber;

  const AnimatedInfoItem({
    super.key,
    this.icon,
    this.iconPath,
    required this.label,
    required this.targetNumber,
  });

  @override
  Widget build(BuildContext context) {
    Widget displayedIcon;

    if (iconPath != null) {
      displayedIcon = SvgPicture.asset(
        iconPath!,
        width: 28,
        height: 28,
        color: const Color(0xFF358666),
      );
    } else if (icon != null) {
      displayedIcon = Icon(
        icon,
        size: 32,
        color: const Color(0xFF358666),
      );
    } else {
      displayedIcon = const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          displayedIcon,
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: targetNumber),
                duration: const Duration(seconds: 2),
                builder: (context, value, _) {
                  return Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Color(0xFF358666),
                    ),
                  );
                },
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

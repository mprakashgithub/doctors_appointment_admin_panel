import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = !ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final height = isMobile ? 60.0 : 100.0;
    final iconSize = isMobile ? 12.0 : 16.0;
    final fontSize = isMobile ? 10.0 : 12.0;
    final valueFontSize = isMobile ? 14.0 : 16.0;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Card(
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: iconSize),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: fontSize,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: valueFontSize,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

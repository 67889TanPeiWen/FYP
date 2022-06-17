import 'package:flutter/material.dart';

class CalendarDay extends StatelessWidget {
  CalendarDay({required this.color, required this.isToday, required this.child});
  final Color color;
  final bool isToday;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color today_color = Theme.of(context).brightness == Brightness.light ? Colors.indigo[200]! : Colors.white;
    final double border_size = isToday ? (
        color == Colors.transparent ? 4.0 : 6.0
    ) : 7.0;

    return Container(
      child: Container(
        child: Center(child: child),
        decoration: BoxDecoration(
          color: isToday ? today_color : Colors.transparent,
          shape: BoxShape.circle,
        ),
        margin: const EdgeInsets.all(2.0),
      ),
      decoration: BoxDecoration(
        border: Border.all(width: border_size, color: color),
        shape: BoxShape.circle,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart' as t;

class PillTabSwitch extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<String> labels;
  const PillTabSwitch({
    super.key,
    required this.index,
    required this.onChanged,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [t.AppTheme.pillGradientStart, t.AppTheme.pillGradientEnd],
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

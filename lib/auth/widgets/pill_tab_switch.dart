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
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: selected ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey.shade600,
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

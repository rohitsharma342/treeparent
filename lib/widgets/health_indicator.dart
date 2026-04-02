import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/tree_model.dart';

class HealthIndicator extends StatelessWidget {
  final TreeHealthStatus status;
  final bool compact;

  const HealthIndicator({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final label = _getLabel();

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case TreeHealthStatus.excellent:
        return AppTheme.successColor;
      case TreeHealthStatus.good:
        return const Color(0xFF4CAF50);
      case TreeHealthStatus.needsAttention:
        return AppTheme.warningColor;
      case TreeHealthStatus.critical:
        return AppTheme.errorColor;
    }
  }

  String _getLabel() {
    switch (status) {
      case TreeHealthStatus.excellent:
        return 'Excellent';
      case TreeHealthStatus.good:
        return 'Good';
      case TreeHealthStatus.needsAttention:
        return 'Needs Care';
      case TreeHealthStatus.critical:
        return 'Critical';
    }
  }

  IconData _getIcon() {
    switch (status) {
      case TreeHealthStatus.excellent:
        return Icons.check_circle;
      case TreeHealthStatus.good:
        return Icons.thumb_up;
      case TreeHealthStatus.needsAttention:
        return Icons.warning_amber_rounded;
      case TreeHealthStatus.critical:
        return Icons.error;
    }
  }
}
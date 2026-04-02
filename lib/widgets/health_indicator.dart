import 'package:flutter/material.dart';
import '../config/theme.dart';

class HealthIndicator extends StatelessWidget {
  final String status;
  final double size;

  const HealthIndicator({
    super.key,
    required this.status,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColor(),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getColor().withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'healthy':
        return AppTheme.successColor;
      case 'needs attention':
        return AppTheme.warningColor;
      case 'critical':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../controllers/tree_controller.dart';

class ReminderCard extends StatelessWidget {
  final ReminderItem reminder;
  final VoidCallback onTap;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: reminder.isOverdue
              ? Border.all(color: AppTheme.warningColor.withOpacity(0.5))
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (reminder.isOverdue
                        ? AppTheme.warningColor
                        : AppTheme.primaryColor)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(),
                color: reminder.isOverdue
                    ? AppTheme.warningColor
                    : AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${reminder.type} ${reminder.treeName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reminder.isOverdue
                        ? 'Overdue'
                        : 'Due ${DateFormat('MMM d').format(reminder.dueDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: reminder.isOverdue
                          ? AppTheme.warningColor
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (reminder.type) {
      case 'Water':
        return Icons.water_drop_outlined;
      case 'Fertilize':
        return Icons.grass_outlined;
      default:
        return Icons.eco_outlined;
    }
  }
}
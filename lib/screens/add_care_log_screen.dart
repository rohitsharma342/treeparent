import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../controllers/tree_controller.dart';
import '../models/care_log_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddCareLogScreen extends StatefulWidget {
  final String treeId;

  const AddCareLogScreen({super.key, required this.treeId});

  @override
  State<AddCareLogScreen> createState() => _AddCareLogScreenState();
}

class _AddCareLogScreenState extends State<AddCareLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  CareActivityType _selectedActivityType = CareActivityType.watering;
  DateTime _selectedDate = DateTime.now();
  String? _dateError;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              surface: AppTheme.cardColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateError = null;
      });
    }
  }

  Future<void> _saveCareLog() async {
    if (_selectedDate.isAfter(DateTime.now())) {
      setState(() {
        _dateError = 'Date cannot be in the future';
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      final careLog = CareLogModel(
        id: '',
        treeId: widget.treeId,
        activityType: _selectedActivityType,
        activityDate: _selectedDate,
        notes: _notesController.text.trim(),
      );

      final treeController = context.read<TreeController>();
      final success = await treeController.addCareLog(widget.treeId, careLog);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Care log added successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Care Log'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Activity Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: CareActivityType.values.map((type) {
                    return RadioListTile<CareActivityType>(
                      value: type,
                      groupValue: _selectedActivityType,
                      onChanged: (value) {
                        setState(() {
                          _selectedActivityType = value!;
                        });
                      },
                      title: Text(
                        _getActivityTypeName(type),
                        style: const TextStyle(color: AppTheme.textPrimary),
                      ),
                      secondary: Icon(
                        _getActivityTypeIcon(type),
                        color: _selectedActivityType == type
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                      activeColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: _dateError != null
                        ? Border.all(color: AppTheme.errorColor)
                        : null,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('MMMM d, yyyy').format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              if (_dateError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _dateError!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.errorColor,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              CustomTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                hint: 'Add any additional notes about this activity...',
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Consumer<TreeController>(
                      builder: (context, treeController, _) {
                        return CustomButton(
                          text: 'Save',
                          onPressed: _saveCareLog,
                          isLoading: treeController.isLoading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getActivityTypeName(CareActivityType type) {
    switch (type) {
      case CareActivityType.watering:
        return 'Watering';
      case CareActivityType.fertilizing:
        return 'Fertilizing';
      case CareActivityType.pruning:
        return 'Pruning';
      case CareActivityType.repotting:
        return 'Repotting';
      case CareActivityType.pestControl:
        return 'Pest Control';
      case CareActivityType.other:
        return 'Other';
    }
  }

  IconData _getActivityTypeIcon(CareActivityType type) {
    switch (type) {
      case CareActivityType.watering:
        return Icons.water_drop_outlined;
      case CareActivityType.fertilizing:
        return Icons.grass_outlined;
      case CareActivityType.pruning:
        return Icons.content_cut_outlined;
      case CareActivityType.repotting:
        return Icons.swap_vert_circle_outlined;
      case CareActivityType.pestControl:
        return Icons.bug_report_outlined;
      case CareActivityType.other:
        return Icons.eco_outlined;
    }
  }
}
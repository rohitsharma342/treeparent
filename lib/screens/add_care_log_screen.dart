import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddCareLogScreen extends StatefulWidget {
  const AddCareLogScreen({super.key});

  @override
  State<AddCareLogScreen> createState() => _AddCareLogScreenState();
}

class _AddCareLogScreenState extends State<AddCareLogScreen> {
  final _notesController = TextEditingController();
  String _selectedCareType = 'Watering';
  final List<String> _careTypes = [
    'Watering',
    'Fertilizing',
    'Pruning',
    'Pest Control',
    'Other',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Care Log'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Care Type',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _careTypes.map((type) {
                final isSelected = _selectedCareType == type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCareType = type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Notes',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _notesController,
              hintText: 'Add notes about this care activity...',
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Save Care Log',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
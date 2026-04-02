import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../controllers/tree_controller.dart';
import '../models/tree_model.dart';
import '../data/static_data.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddTreeScreen extends StatefulWidget {
  const AddTreeScreen({super.key});

  @override
  State<AddTreeScreen> createState() => _AddTreeScreenState();
}

class _AddTreeScreenState extends State<AddTreeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedSpecies;
  DateTime _plantedDate = DateTime.now();
  int _selectedImageIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantedDate,
      firstDate: DateTime(2000),
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
        _plantedDate = picked;
      });
    }
  }

  Future<void> _saveTree() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSpecies == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a species')),
        );
        return;
      }

      final tree = TreeModel(
        id: '',
        name: _nameController.text.trim(),
        species: _selectedSpecies!,
        plantedDate: _plantedDate,
        location: _locationController.text.trim(),
        imageUrl: StaticData.treeImages[_selectedImageIndex],
        notes: _notesController.text.trim(),
      );

      final treeController = context.read<TreeController>();
      final success = await treeController.addTree(tree);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tree added successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Add New Tree'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose an Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: StaticData.treeImages.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedImageIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.network(
                            StaticData.treeImages[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.surfaceColor,
                                child: const Icon(
                                  Icons.park,
                                  color: AppTheme.primaryColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                label: 'Tree Name',
                hint: 'Give your tree a name',
                prefixIcon: Icons.park_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Species',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedSpecies,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.eco_outlined,
                      color: AppTheme.textSecondary,
                    ),
                    border: InputBorder.none,
                  ),
                  dropdownColor: AppTheme.cardColor,
                  hint: const Text(
                    'Select species',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  items: StaticData.treeSpecies.map((species) {
                    return DropdownMenuItem(
                      value: species,
                      child: Text(
                        species,
                        style: const TextStyle(color: AppTheme.textPrimary),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecies = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Planted Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('MMMM d, yyyy').format(_plantedDate),
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
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'Where is your tree located?',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                hint: 'Add any notes about your tree...',
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              Consumer<TreeController>(
                builder: (context, treeController, _) {
                  return CustomButton(
                    text: 'Add Tree',
                    onPressed: _saveTree,
                    isLoading: treeController.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
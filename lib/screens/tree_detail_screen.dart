import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../controllers/tree_controller.dart';
import '../models/tree_model.dart';
import '../widgets/health_indicator.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'add_care_log_screen.dart';

class TreeDetailScreen extends StatefulWidget {
  final String treeId;

  const TreeDetailScreen({super.key, required this.treeId});

  @override
  State<TreeDetailScreen> createState() => _TreeDetailScreenState();
}

class _TreeDetailScreenState extends State<TreeDetailScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _notesController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initControllers(TreeModel tree) {
    if (!_isEditing) {
      _nameController.text = tree.name;
      _notesController.text = tree.notes;
      _locationController.text = tree.location;
    }
  }

  Future<void> _saveChanges(TreeModel tree) async {
    final treeController = context.read<TreeController>();
    final updatedTree = tree.copyWith(
      name: _nameController.text,
      notes: _notesController.text,
      location: _locationController.text,
    );

    final success = await treeController.updateTree(updatedTree);
    if (success) {
      setState(() {
        _isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tree updated successfully')),
        );
      }
    }
  }

  Future<void> _deleteTree() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Delete Tree'),
        content: const Text(
          'Are you sure you want to delete this tree? This will also delete all care logs associated with it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final treeController = context.read<TreeController>();
      await treeController.deleteTree(widget.treeId);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tree deleted successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TreeController>(
      builder: (context, treeController, _) {
        final tree = treeController.getTreeById(widget.treeId);

        if (tree == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Tree not found'),
            ),
          );
        }

        _initControllers(tree);

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: tree.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.surfaceColor,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.surfaceColor,
                      child: const Icon(
                        Icons.park,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                actions: [
                  if (!_isEditing)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _deleteTree,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isEditing) ...[
                        CustomTextField(
                          controller: _nameController,
                          label: 'Tree Name',
                          hint: 'Enter tree name',
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tree.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tree.species,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            HealthIndicator(status: tree.healthStatus),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildInfoCard(tree),
                      const SizedBox(height: 16),
                      _buildCareStatusCard(tree),
                      const SizedBox(height: 16),
                      if (_isEditing) ...[
                        CustomTextField(
                          controller: _locationController,
                          label: 'Location',
                          hint: 'Enter location',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _notesController,
                          label: 'Notes',
                          hint: 'Add notes about your tree',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                  });
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomButton(
                                text: 'Save',
                                onPressed: () => _saveChanges(tree),
                                isLoading: treeController.isLoading,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        _buildNotesCard(tree),
                        const SizedBox(height: 16),
                        _buildCareLogsSection(tree),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: !_isEditing
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCareLogScreen(treeId: tree.id),
                      ),
                    );
                  },
                  backgroundColor: AppTheme.primaryColor,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add Care Log',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildInfoCard(TreeModel tree) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(Icons.cake_outlined, 'Age', tree.ageDisplay),
          _buildInfoItem(
            Icons.location_on_outlined,
            'Location',
            tree.location,
          ),
          _buildInfoItem(
            Icons.calendar_today_outlined,
            'Planted',
            DateFormat('MMM d, y').format(tree.plantedDate),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCareStatusCard(TreeModel tree) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Care Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildCareStatusItem(
            Icons.water_drop_outlined,
            'Last Watered',
            tree.lastWatered != null
                ? DateFormat('MMM d, y').format(tree.lastWatered!)
                : 'Never',
            tree.lastWatered != null &&
                DateTime.now().difference(tree.lastWatered!).inDays <= 3,
          ),
          const SizedBox(height: 12),
          _buildCareStatusItem(
            Icons.grass_outlined,
            'Last Fertilized',
            tree.lastFertilized != null
                ? DateFormat('MMM d, y').format(tree.lastFertilized!)
                : 'Never',
            tree.lastFertilized != null &&
                DateTime.now().difference(tree.lastFertilized!).inDays <= 30,
          ),
          const SizedBox(height: 12),
          _buildCareStatusItem(
            Icons.content_cut_outlined,
            'Last Pruned',
            tree.lastPruned != null
                ? DateFormat('MMM d, y').format(tree.lastPruned!)
                : 'Never',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildCareStatusItem(
    IconData icon,
    String label,
    String value,
    bool isGood,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isGood ? AppTheme.primaryColor : AppTheme.warningColor)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isGood ? AppTheme.primaryColor : AppTheme.warningColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          isGood ? Icons.check_circle : Icons.warning_amber_rounded,
          color: isGood ? AppTheme.primaryColor : AppTheme.warningColor,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildNotesCard(TreeModel tree) {
    if (tree.notes.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tree.notes,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareLogsSection(TreeModel tree) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Care History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        if (tree.careLogs.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: AppTheme.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No care logs yet',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ...tree.careLogs.reversed.take(5).map((log) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getCareLogIcon(log.activityType),
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.activityTypeDisplay,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        if (log.notes.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            log.notes,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('MMM d').format(log.activityDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  IconData _getCareLogIcon(dynamic activityType) {
    switch (activityType.toString()) {
      case 'CareActivityType.watering':
        return Icons.water_drop_outlined;
      case 'CareActivityType.fertilizing':
        return Icons.grass_outlined;
      case 'CareActivityType.pruning':
        return Icons.content_cut_outlined;
      case 'CareActivityType.repotting':
        return Icons.swap_vert_circle_outlined;
      case 'CareActivityType.pestControl':
        return Icons.bug_report_outlined;
      default:
        return Icons.eco_outlined;
    }
  }
}
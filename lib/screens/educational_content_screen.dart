import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../controllers/content_controller.dart';
import '../models/content_model.dart';
import '../widgets/content_card.dart';
import 'content_detail_screen.dart';

class EducationalContentScreen extends StatefulWidget {
  const EducationalContentScreen({super.key});

  @override
  State<EducationalContentScreen> createState() =>
      _EducationalContentScreenState();
}

class _EducationalContentScreenState extends State<EducationalContentScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentController>().loadContents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Learn'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search articles and guides...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.textSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ContentController>().setSearchQuery('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<ContentController>().setSearchQuery(value);
                setState(() {});
              },
            ),
          ),
          Consumer<ContentController>(
            builder: (context, contentController, _) {
              return SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip(
                      'All',
                      contentController.selectedCategory == null,
                      () => contentController.setCategory(null),
                    ),
                    ...ContentCategory.values.map((category) {
                      return _buildCategoryChip(
                        _getCategoryName(category),
                        contentController.selectedCategory == category,
                        () => contentController.setCategory(category),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<ContentController>(
              builder: (context, contentController, _) {
                if (contentController.isLoading) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.primaryColor),
                  );
                }

                if (contentController.contents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No content found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: contentController.contents.length,
                  itemBuilder: (context, index) {
                    final content = contentController.contents[index];
                    return ContentCard(
                      content: content,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContentDetailScreen(contentId: content.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getCategoryName(ContentCategory category) {
    switch (category) {
      case ContentCategory.basics:
        return 'Basics';
      case ContentCategory.watering:
        return 'Watering';
      case ContentCategory.fertilizing:
        return 'Fertilizing';
      case ContentCategory.pruning:
        return 'Pruning';
      case ContentCategory.pests:
        return 'Pests';
      case ContentCategory.seasonal:
        return 'Seasonal';
    }
  }
}
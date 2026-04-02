import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../controllers/content_controller.dart';

class ContentDetailScreen extends StatelessWidget {
  final String contentId;

  const ContentDetailScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentController>(
      builder: (context, contentController, _) {
        final content = contentController.getContentById(contentId);

        if (content == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Content not found'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: content.imageUrl,
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
                        Icons.article,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bookmarks coming soon')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing coming soon')),
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              content.categoryDisplay,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              content.typeDisplay,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        content.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${content.readTimeMinutes} min read',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d, yyyy')
                                .format(content.publishedAt),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: AppTheme.surfaceColor),
                      const SizedBox(height: 24),
                      Text(
                        content.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textPrimary,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 48),
                      const Divider(color: AppTheme.surfaceColor),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Made With BrainBox',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
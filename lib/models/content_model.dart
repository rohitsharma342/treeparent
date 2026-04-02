enum ContentType { article, video, guide }
enum ContentCategory { basics, watering, fertilizing, pruning, pests, seasonal }

class ContentModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final ContentType type;
  final ContentCategory category;
  final int readTimeMinutes;
  final DateTime publishedAt;
  final bool isFeatured;

  ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.type,
    required this.category,
    required this.readTimeMinutes,
    required this.publishedAt,
    this.isFeatured = false,
  });

  String get categoryDisplay {
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
        return 'Pest Control';
      case ContentCategory.seasonal:
        return 'Seasonal Care';
    }
  }

  String get typeDisplay {
    switch (type) {
      case ContentType.article:
        return 'Article';
      case ContentType.video:
        return 'Video';
      case ContentType.guide:
        return 'Guide';
    }
  }
}
import '../models/tree_model.dart';
import '../models/care_log_model.dart';
import '../models/content_model.dart';

class StaticData {
  static final List<TreeModel> sampleTrees = [
    TreeModel(
      id: '1',
      name: 'Oak Wonder',
      species: 'English Oak',
      plantedDate: DateTime.now().subtract(const Duration(days: 365)),
      location: 'Backyard - East Corner',
      healthStatus: TreeHealthStatus.excellent,
      imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400',
      notes: 'Growing beautifully, showing new leaves every spring.',
      careLogs: [
        CareLogModel(
          id: '1',
          treeId: '1',
          activityType: CareActivityType.watering,
          activityDate: DateTime.now().subtract(const Duration(days: 2)),
          notes: 'Deep watering session',
        ),
      ],
      lastWatered: DateTime.now().subtract(const Duration(days: 2)),
      lastFertilized: DateTime.now().subtract(const Duration(days: 15)),
    ),
    TreeModel(
      id: '2',
      name: 'Maple Beauty',
      species: 'Japanese Maple',
      plantedDate: DateTime.now().subtract(const Duration(days: 180)),
      location: 'Front Garden',
      healthStatus: TreeHealthStatus.good,
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      notes: 'Beautiful red leaves in autumn.',
      careLogs: [],
      lastWatered: DateTime.now().subtract(const Duration(days: 4)),
      lastFertilized: DateTime.now().subtract(const Duration(days: 45)),
    ),
    TreeModel(
      id: '3',
      name: 'Pine Guardian',
      species: 'Scots Pine',
      plantedDate: DateTime.now().subtract(const Duration(days: 730)),
      location: 'Side Garden',
      healthStatus: TreeHealthStatus.needsAttention,
      imageUrl: 'https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=400',
      notes: 'Needs some pruning soon.',
      careLogs: [],
      lastWatered: DateTime.now().subtract(const Duration(days: 5)),
      lastFertilized: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  static final List<ContentModel> sampleContents = [
    ContentModel(
      id: '1',
      title: 'Getting Started with Tree Care',
      description: 'Learn the fundamentals of nurturing your trees for optimal growth.',
      content: '''Welcome to the world of tree parenting! This comprehensive guide will help you understand the basics of tree care.

## Understanding Your Tree

Every tree is unique and requires specific care based on its species, age, and environment. Here are the key factors to consider:

### 1. Soil Requirements
Different trees thrive in different soil types. Most trees prefer well-draining soil rich in organic matter.

### 2. Sunlight Needs
Understand whether your tree prefers full sun, partial shade, or full shade.

### 3. Water Requirements
Young trees need more frequent watering, while established trees are more drought-tolerant.

## Basic Care Schedule

- **Daily**: Check for signs of stress or pests
- **Weekly**: Deep watering (adjust based on rainfall)
- **Monthly**: Inspect for disease and structural issues
- **Seasonally**: Fertilize and prune as needed

Remember, patience is key in tree parenting. Trees grow slowly but reward us with decades of beauty and benefits.''',
      imageUrl: 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=400',
      type: ContentType.guide,
      category: ContentCategory.basics,
      readTimeMinutes: 8,
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      isFeatured: true,
    ),
    ContentModel(
      id: '2',
      title: 'Watering Techniques for Healthy Trees',
      description: 'Master the art of proper tree hydration with these expert tips.',
      content: '''Proper watering is crucial for tree health. Here is everything you need to know about keeping your trees hydrated.

## The Deep Watering Method

Shallow watering encourages surface roots, making trees less stable and more susceptible to drought stress.

### How to Deep Water:
1. Place a hose at the base of the tree
2. Let water flow slowly for 30-60 minutes
3. Ensure water penetrates 12-18 inches into the soil

## Signs of Overwatering
- Yellowing leaves
- Soft, mushy roots
- Fungal growth at base

## Signs of Underwatering
- Wilting leaves
- Dry, cracked soil
- Premature leaf drop

## Best Practices
- Water early morning or evening
- Use mulch to retain moisture
- Adjust frequency based on season''',
      imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
      type: ContentType.article,
      category: ContentCategory.watering,
      readTimeMinutes: 6,
      publishedAt: DateTime.now().subtract(const Duration(days: 14)),
      isFeatured: true,
    ),
    ContentModel(
      id: '3',
      title: 'Fertilizing Your Trees: A Complete Guide',
      description: 'Understand when and how to feed your trees for optimal growth.',
      content: '''Fertilizing provides essential nutrients that may be lacking in your soil.

## Understanding NPK

- **N (Nitrogen)**: Promotes leaf growth
- **P (Phosphorus)**: Supports root development
- **K (Potassium)**: Enhances overall health

## When to Fertilize

### Spring
Best time for nitrogen-rich fertilizers to support new growth.

### Fall
Use balanced fertilizer to prepare for winter dormancy.

## Application Methods

1. **Surface Application**: Spread around drip line
2. **Deep Root Feeding**: Inject into root zone
3. **Foliar Spray**: Apply directly to leaves

## Common Mistakes
- Over-fertilizing (can burn roots)
- Fertilizing during drought
- Applying too close to trunk''',
      imageUrl: 'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=400',
      type: ContentType.guide,
      category: ContentCategory.fertilizing,
      readTimeMinutes: 7,
      publishedAt: DateTime.now().subtract(const Duration(days: 21)),
      isFeatured: false,
    ),
    ContentModel(
      id: '4',
      title: 'Pruning Basics for Beginners',
      description: 'Learn the proper techniques for pruning your trees safely.',
      content: '''Pruning is essential for maintaining tree health and shape.

## Why Prune?

- Remove dead or diseased branches
- Improve air circulation
- Shape the tree
- Encourage fruit production

## When to Prune

### Dormant Season (Late Winter)
Best for most trees. Less stress and disease risk.

### After Flowering
For spring-blooming trees.

## Basic Cuts

### 1. Heading Cut
Shortens a branch to promote bushier growth.

### 2. Thinning Cut
Removes entire branch at origin point.

### 3. Reduction Cut
Reduces tree size while maintaining natural form.

## Safety Tips
- Use sharp, clean tools
- Never remove more than 25% of canopy
- Avoid topping trees''',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      type: ContentType.article,
      category: ContentCategory.pruning,
      readTimeMinutes: 5,
      publishedAt: DateTime.now().subtract(const Duration(days: 28)),
      isFeatured: true,
    ),
    ContentModel(
      id: '5',
      title: 'Identifying and Treating Common Tree Pests',
      description: 'Protect your trees from harmful insects and diseases.',
      content: '''Early detection of pests can save your trees.

## Common Pests

### Aphids
- Small, soft-bodied insects
- Cluster on new growth
- Treatment: Insecticidal soap

### Scale Insects
- Look like bumps on branches
- Suck plant sap
- Treatment: Horticultural oil

### Borers
- Tunnel into wood
- Cause structural damage
- Treatment: Prevention is key

## Signs of Infestation
- Discolored leaves
- Holes in bark
- Sawdust-like material
- Sticky residue (honeydew)

## Organic Solutions
1. Neem oil spray
2. Beneficial insects (ladybugs)
3. Physical removal

## Prevention
- Keep trees healthy
- Regular inspections
- Proper watering and fertilizing''',
      imageUrl: 'https://images.unsplash.com/photo-1520052203542-d3095f1b6cf0?w=400',
      type: ContentType.guide,
      category: ContentCategory.pests,
      readTimeMinutes: 9,
      publishedAt: DateTime.now().subtract(const Duration(days: 35)),
      isFeatured: false,
    ),
    ContentModel(
      id: '6',
      title: 'Seasonal Tree Care Calendar',
      description: 'Month-by-month guide to keeping your trees healthy year-round.',
      content: '''Follow this calendar for optimal tree care throughout the year.

## Spring (March-May)

- Inspect for winter damage
- Begin regular watering
- Apply spring fertilizer
- Watch for emerging pests

## Summer (June-August)

- Deep water during dry spells
- Mulch to retain moisture
- Monitor for heat stress
- Light pruning if needed

## Fall (September-November)

- Reduce watering gradually
- Apply fall fertilizer
- Clean up fallen leaves
- Prepare for winter

## Winter (December-February)

- Major pruning (dormant trees)
- Protect young trees from frost
- Check for rodent damage
- Plan spring activities

## Special Considerations
- Adjust based on your climate zone
- Consider tree species needs
- Monitor weather conditions''',
      imageUrl: 'https://images.unsplash.com/photo-1508193638397-1c4234db14d8?w=400',
      type: ContentType.guide,
      category: ContentCategory.seasonal,
      readTimeMinutes: 10,
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      isFeatured: true,
    ),
  ];

  static final List<String> treeSpecies = [
    'English Oak',
    'Japanese Maple',
    'Scots Pine',
    'Silver Birch',
    'Weeping Willow',
    'Cherry Blossom',
    'Apple Tree',
    'Lemon Tree',
    'Fig Tree',
    'Olive Tree',
    'Palm Tree',
    'Magnolia',
    'Cedar',
    'Redwood',
    'Eucalyptus',
  ];

  static final List<String> treeImages = [
    'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    'https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=400',
    'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=400',
    'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
    'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=400',
  ];
}
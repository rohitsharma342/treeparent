import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../controllers/tree_controller.dart';
import '../controllers/content_controller.dart';
import '../widgets/tree_card.dart';
import '../widgets/reminder_card.dart';
import '../widgets/content_card.dart';
import 'tree_detail_screen.dart';
import 'content_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<TreeController>().loadTrees();
    await context.read<ContentController>().loadContents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('TreeParent'),
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon')),
                  );
                },
              ),
              Consumer<TreeController>(
                builder: (context, treeController, _) {
                  final overdueCount = treeController.reminders
                      .where((r) => r.isOverdue)
                      .length;
                  if (overdueCount > 0) {
                    return Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          overdueCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search trees, tips, and more...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.textSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TreeController>().setSearchQuery('');
                          context.read<ContentController>().setSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<TreeController>().setSearchQuery(value);
                context.read<ContentController>().setSearchQuery(value);
                setState(() {});
              },
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'My Trees'),
              Tab(text: 'Reminders'),
              Tab(text: 'Discover'),
            ],
            indicatorSize: TabBarIndicatorSize.label,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyTreesTab(),
                _buildRemindersTab(),
                _buildDiscoverTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.educationalContent);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.profile);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addTree);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMyTreesTab() {
    return Consumer<TreeController>(
      builder: (context, treeController, _) {
        if (treeController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (treeController.trees.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.park_outlined,
                  size: 64,
                  color: AppTheme.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No trees yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add your first tree to get started',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addTree);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Tree'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          color: AppTheme.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: treeController.trees.length,
            itemBuilder: (context, index) {
              final tree = treeController.trees[index];
              return TreeCard(
                tree: tree,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TreeDetailScreen(treeId: tree.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRemindersTab() {
    return Consumer<TreeController>(
      builder: (context, treeController, _) {
        final reminders = treeController.reminders;

        if (reminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppTheme.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'All caught up!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'No pending care tasks',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return ReminderCard(
              reminder: reminder,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TreeDetailScreen(treeId: reminder.treeId),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDiscoverTab() {
    return Consumer<ContentController>(
      builder: (context, contentController, _) {
        if (contentController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Featured',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: contentController.featuredContents.length,
                  itemBuilder: (context, index) {
                    final content = contentController.featuredContents[index];
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 16),
                      child: ContentCard(
                        content: content,
                        isHorizontal: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContentDetailScreen(contentId: content.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'All Articles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...contentController.contents.map((content) {
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
              }),
            ],
          ),
        );
      },
    );
  }
}
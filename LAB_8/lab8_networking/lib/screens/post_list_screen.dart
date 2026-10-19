import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart';

// Lab 8.2 & 8.3 & 8.4 - Main API-powered List Screen
// Uses FutureBuilder to bind asynchronous API data to ListView UI.

class PostListScreen extends StatefulWidget {
  final ApiService apiService;

  const PostListScreen({super.key, required this.apiService});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  // Holds the Future returned by ApiService.fetchPosts()
  late Future<List<Post>> _postsFuture;

  // Local list to hold custom created posts (from POST request)
  final List<Post> _createdPosts = [];

  // Flag to simulate network error for testing error UI state (Lab 8.3)
  bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    // Initialize the fetch future when the screen starts
    _loadPosts();
  }

  /// Triggers API request to fetch posts
  void _loadPosts() {
    setState(() {
      if (_simulateError) {
        // Simulated error for Lab 8.3 testing
        _postsFuture = Future.error(
            Exception('Simulated network error! Failed to connect to server.'));
      } else {
        // Real API request via ApiService
        _postsFuture = widget.apiService.fetchPosts();
      }
    });
  }

  /// Refresh method called by RefreshIndicator (Pull-to-refresh) or Retry button
  Future<void> _refreshPosts() async {
    _loadPosts();
    await _postsFuture.catchError((_) => <Post>[]);
  }

  /// Navigates to CreatePostScreen (POST request) and appends newly created item
  Future<void> _navigateToCreatePost() async {
    final result = await Navigator.of(context).push<Post>(
      MaterialPageRoute(
        builder: (context) => CreatePostScreen(apiService: widget.apiService),
      ),
    );

    if (result != null) {
      setState(() {
        // Prepend created post to local list so user sees it at the top
        _createdPosts.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Powered List Screen'),
        centerTitle: true,
        actions: [
          // Popup menu to toggle error simulation for Lab 8.3 error state testing
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'toggle_error') {
                setState(() {
                  _simulateError = !_simulateError;
                });
                _loadPosts();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _simulateError
                          ? 'Simulated Error Mode ON. Loading will fail.'
                          : 'Normal Mode ON. Loading real API data.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_error',
                child: Row(
                  children: [
                    Icon(
                      _simulateError ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(_simulateError ? 'Disable Error State' : 'Simulate Error State'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // Lab 8.2 & 8.3 - FutureBuilder binds async API state to UI
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // STATE 1: Waiting / Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          // STATE 2: Error state (Lab 8.3)
          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          // STATE 3: Data successfully loaded
          if (snapshot.hasData) {
            final fetchedPosts = snapshot.data!;
            // Combine locally created posts with API fetched posts
            final allPosts = [..._createdPosts, ...fetchedPosts];

            if (allPosts.isEmpty) {
              return _buildEmptyState();
            }

            // Render list using RefreshIndicator (Pull-to-refresh) and ListView.builder
            return RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  final isNew = index < _createdPosts.length;
                  return _buildPostCard(post, isNew);
                },
              ),
            );
          }

          return _buildLoadingState();
        },
      ),

      // Optional Enhancement - FloatingActionButton for POST Request form
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreatePost,
        icon: const Icon(Icons.add),
        label: const Text('New Post (POST)'),
      ),
    );
  }

  /// Lab 8.3 - Builds Loading State UI Widget
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Fetching data from REST API...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Lab 8.3 - Builds Error State UI Widget with Retry Button
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            // Retry Button
            ElevatedButton.icon(
              onPressed: () {
                // Turn off error simulation if retry pressed
                if (_simulateError) {
                  setState(() {
                    _simulateError = false;
                  });
                }
                _loadPosts();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds Empty State Widget if list is empty
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No posts found.'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loadPosts,
            child: const Text('Reload'),
          ),
        ],
      ),
    );
  }

  /// Lab 8.2 - Builds individual Post Card item using Card & ListTile
  Widget _buildPostCard(Post post, bool isNew) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isNew ? Colors.green.shade100 : Colors.blue.shade100,
          child: Text(
            '${post.id}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isNew ? Colors.green.shade800 : Colors.blue.shade800,
              fontSize: 12,
            ),
          ),
        ),
        title: Row(
          children: [
            if (isNew) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            Expanded(
              child: Text(
                post.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            post.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // Navigate to Post Detail Screen on tap
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
      ),
    );
  }
}

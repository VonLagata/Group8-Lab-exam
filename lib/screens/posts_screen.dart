import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../theme/app_theme.dart';
import '../widgets/black_button.dart';
import '../widgets/insta_app_bar.dart';
import '../widgets/insta_dialog.dart';
import '../widgets/labeled_field.dart';
import '../widgets/post_card.dart';
import '../widgets/status_banner.dart';

/// Route '/' - "Popular" posts from the API, plus the Create Post modal.
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  static const double _cardHeight = 224;

  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Result of the last POST request (shown in a banner on this screen).
  String? _postMessage;
  bool _postSuccess = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  // ---------------------------------------------------------------- GET
  Future<void> _fetchPosts({bool showLoader = true}) async {
    if (showLoader) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await http
          .get(Uri.parse(postsApiUrl))
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _posts = data
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load posts. The server responded with status code ${response.statusCode}.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Something went wrong while loading posts. Please check your internet connection and try again.\n\nDetails: $e';
      });
    }
  }

  // --------------------------------------------------------------- POST
  Future<void> _openCreatePostDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierColor: const Color(0x73000000),
      builder: (context) => const _CreatePostDialog(),
    );
    if (result != null) {
      await _sendPost(result['title']!, result['body']!);
    }
  }

  Future<void> _sendPost(String title, String body) async {
    try {
      final response = await http
          .post(
            Uri.parse(postsApiUrl),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({'title': title, 'body': body}),
          )
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;

      if (response.statusCode == 201) {
        Map<String, dynamic> created = {};
        try {
          created = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
        } catch (_) {
          // The post was created; just fall back to the typed values below.
        }
        setState(() {
          _postSuccess = true;
          _postMessage = 'Post created successfully (status code 201).';
          // Show the new post at the top of the list.
          _posts.insert(0, {
            'id': created['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            'title': created['title'] ?? title,
            'body': created['body'] ?? body,
          });
        });
      } else {
        setState(() {
          _postSuccess = false;
          _postMessage =
              'Failed to create post. Server responded with status code ${response.statusCode}.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _postSuccess = false;
        _postMessage = 'Failed to create post. Please check your connection.';
      });
    }
  }

  void _openDetails(Map<String, dynamic> post) {
    // Pass id, title and body to the details screen.
    Navigator.pushNamed(
      context,
      '/details',
      arguments: {
        'id': post['id'],
        'title': '${post['title'] ?? ''}',
        'body': '${post['body'] ?? ''}',
      },
    );
  }

  // ----------------------------------------------------------------- UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InstaAppBar(title: 'Posts'),
      body: Column(
        children: [
          if (_postMessage != null)
            StatusBanner(
              message: _postMessage!,
              isSuccess: _postSuccess,
              onClose: () => setState(() => _postMessage = null),
            ),
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create post',
        onPressed: _openCreatePostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// "Create Post" label + gray field + "Popular" heading.
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.pad, 20, AppTheme.pad, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Post',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _openCreatePostDialog,
            child: Container(
              height: 44,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: AppTheme.field,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "What's on your mind?",
                style: TextStyle(fontSize: 13, color: AppTheme.hint),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Popular',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppTheme.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return ListView(
        children: [
          _buildHeader(),
          const SizedBox(height: 40),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_errorMessage != null) {
      return ListView(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(AppTheme.pad),
            child: Column(
              children: [
                const Icon(Icons.cloud_off, size: 52, color: AppTheme.error),
                const SizedBox(height: AppTheme.pad),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.error, fontSize: 14),
                ),
                const SizedBox(height: AppTheme.pad),
                BlackButton(
                  label: 'Try Again',
                  icon: Icons.refresh,
                  height: 44,
                  fontSize: 14,
                  fullWidth: false,
                  onPressed: _fetchPosts,
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_posts.isEmpty) {
      return ListView(
        children: [
          _buildHeader(),
          const Padding(
            padding: EdgeInsets.all(AppTheme.pad),
            child: Center(child: Text('No posts yet. Be the first to post!')),
          ),
        ],
      );
    }

    // Two cards per row, as in the design. Item 0 is the header.
    final rowCount = (_posts.length / 2).ceil();

    return RefreshIndicator(
      color: AppTheme.black,
      onRefresh: () => _fetchPosts(showLoader: false),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 90),
        itemCount: rowCount + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildHeader();

          final first = (index - 1) * 2;
          final second = first + 1;

          return Padding(
            padding: const EdgeInsets.fromLTRB(
                AppTheme.pad, 0, AppTheme.pad, AppTheme.pad),
            child: Row(
              children: [
                Expanded(child: _buildCard(first)),
                const SizedBox(width: 12),
                Expanded(
                  child: second < _posts.length
                      ? _buildCard(second)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(int index) {
    final post = _posts[index];
    return SizedBox(
      height: _cardHeight,
      child: PostCard(
        id: post['id'],
        title: '${post['title'] ?? 'Untitled'}',
        body: '${post['body'] ?? ''}',
        onOpen: () => _openDetails(post),
      ),
    );
  }
}

/// Create Post modal: Title + Description (neither can be empty).
class _CreatePostDialog extends StatefulWidget {
  const _CreatePostDialog();

  @override
  State<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<_CreatePostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label cannot be empty';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InstaDialog(
      title: 'Create Post',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlackButton(
          label: 'Post',
          height: 38,
          fontSize: 13,
          fullWidth: false,
          onPressed: _submit,
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            LabeledField(
              label: 'Title',
              controller: _titleController,
              validator: (value) => _required(value, 'Title'),
            ),
            const SizedBox(height: 14),
            LabeledField(
              label: 'Description',
              controller: _bodyController,
              maxLines: 6,
              validator: (value) => _required(value, 'Description'),
            ),
          ],
        ),
      ),
    );
  }
}

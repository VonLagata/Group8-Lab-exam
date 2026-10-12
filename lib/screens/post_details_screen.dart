import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../theme/app_theme.dart';
import '../utils/text_utils.dart';
import '../widgets/black_button.dart';
import '../widgets/bordered_card.dart';
import '../widgets/id_badge.dart';
import '../widgets/insta_app_bar.dart';
import '../widgets/status_banner.dart';

/// Route '/details' - one post in full, with a "Save to Favorites" button.
class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  String? _message;
  bool _messageIsSuccess = true;

  Future<void> _saveToFavorites(Object? id, String title, String body) async {
    final box = Hive.box(favoritesBoxName);

    if (box.containsKey(id)) {
      setState(() {
        _messageIsSuccess = false;
        _message = 'This post is already in your Favorites.';
      });
      return;
    }

    // The post id is the key, so the same post can never be saved twice.
    await box.put(id, {
      'id': id,
      'title': title,
      'body': body,
      'note': '',
    });

    if (!mounted) return;
    setState(() {
      _messageIsSuccess = true;
      _message = 'Post saved to Favorites!';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments sent by Navigator.pushNamed().
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Object? id = args['id'];
    final String title = '${args['title'] ?? ''}';
    final String body = '${args['body'] ?? ''}';

    return Scaffold(
      appBar: const InstaAppBar(title: 'Post', showBack: true),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppTheme.pad * 2),
        children: [
          if (_message != null)
            StatusBanner(
              message: _message!,
              isSuccess: _messageIsSuccess,
              onClose: () => setState(() => _message = null),
            ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.pad),
            child: BorderedCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IdBadge(label: '$id', size: 34),
                  const SizedBox(height: 14),
                  Text(
                    cleanText(title),
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: AppTheme.black),
                  const SizedBox(height: 12),
                  Text(
                    cleanText(body, multiline: true),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.pad),
            // Rebuilds automatically when this post is saved or removed.
            child: ValueListenableBuilder(
              valueListenable: Hive.box(favoritesBoxName).listenable(),
              builder: (context, Box box, _) {
                final isSaved = box.containsKey(id);
                return BlackButton(
                  label: isSaved ? 'Saved to Favorites' : 'Save to Favorites',
                  icon: isSaved ? Icons.check : Icons.favorite_border,
                  height: 48,
                  fontSize: 14,
                  onPressed:
                      isSaved ? null : () => _saveToFavorites(id, title, body),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

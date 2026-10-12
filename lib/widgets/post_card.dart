import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/text_utils.dart';
import 'black_button.dart';
import 'bordered_card.dart';
import 'id_badge.dart';

/// Compact post card for the 2-column "Popular" list on the Posts screen.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.onOpen,
  });

  final Object? id;
  final String title;
  final String body;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return BorderedCard(
      onTap: onOpen,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IdBadge(label: '$id'),
          const SizedBox(height: 8),
          Text(
            cleanText(title),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 6),
          Container(height: 1, color: AppTheme.black),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              cleanText(body),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                height: 1.3,
                color: AppTheme.bodyText,
              ),
            ),
          ),
          const SizedBox(height: 8),
          BlackButton(label: 'Read Post', onPressed: onOpen),
        ],
      ),
    );
  }
}

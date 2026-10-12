import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// AppBar from the Figma design: black "InstaPost." logo, underlined page
/// title, favorites (heart) button and a profile button.
class InstaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InstaAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.showFavorites = true,
  });

  /// Clear page title shown next to the logo (e.g. "Posts").
  final String title;

  /// Sub-screens show a back arrow that calls Navigator.pop().
  final bool showBack;

  /// The Posts and Details screens show the heart that opens '/favorites'.
  final bool showFavorites;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 76,
      automaticallyImplyLeading: false,
      leadingWidth: showBack ? 48 : 0,
      leading: showBack
          ? IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      titleSpacing: showBack ? 0 : AppTheme.pad,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.black,
              borderRadius: BorderRadius.circular(8),
              boxShadow: AppTheme.softShadow,
            ),
            child: const Text(
              'InstaPost.',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.black, width: 1),
                ),
              ),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.black,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (showFavorites)
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite, color: AppTheme.black),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        IconButton(
          tooltip: 'Profile',
          icon: const CircleAvatar(
            radius: 11,
            backgroundColor: AppTheme.black,
            child: Icon(Icons.person, size: 15, color: AppTheme.white),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Signed in as Guest')));
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

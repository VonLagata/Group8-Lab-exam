import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../theme/app_theme.dart';
import '../utils/text_utils.dart';
import '../widgets/black_button.dart';
import '../widgets/bordered_card.dart';
import '../widgets/id_badge.dart';
import '../widgets/insta_app_bar.dart';
import '../widgets/insta_dialog.dart';
import '../widgets/labeled_field.dart';

/// Route '/favorites' - Read, Update (personal note) and Delete saved posts.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  // ------------------------------------------------------------- UPDATE
  Future<void> _editNote(BuildContext context, Box box, Map post) async {
    final note = await showDialog<String>(
      context: context,
      barrierColor: const Color(0x73000000),
      builder: (context) => _NoteDialog(initialNote: '${post['note'] ?? ''}'),
    );

    if (note != null) {
      final updated = Map<String, dynamic>.from(post);
      updated['note'] = note;
      await box.put(post['id'], updated);
      if (context.mounted) _showMessage(context, 'Note saved');
    }
  }

  // ------------------------------------------------------------- DELETE
  Future<void> _delete(BuildContext context, Box box, Map post) async {
    await box.delete(post['id']);
    if (context.mounted) _showMessage(context, 'Removed from Favorites');
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(favoritesBoxName);

    return Scaffold(
      appBar: const InstaAppBar(
        title: 'Favorites',
        showBack: true,
        showFavorites: false,
      ),
      // ------------------------------------------------------------ READ
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          final favorites = box.values.toList();

          if (favorites.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.pad * 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 60, color: AppTheme.black),
                    SizedBox(height: AppTheme.pad),
                    Text(
                      'No favorites yet.\nOpen a post and tap "Save to Favorites".',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.bodyText, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.pad),
            itemCount: favorites.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(top: 4, bottom: AppTheme.pad),
                  child: Text(
                    'Saved Posts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.black,
                    ),
                  ),
                );
              }

              final post = favorites[index - 1] as Map;
              final note = '${post['note'] ?? ''}';

              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.pad),
                child: Dismissible(
                  key: ValueKey(post['id']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 24),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: AppTheme.black,
                      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    ),
                    child: const Icon(Icons.delete, color: AppTheme.white),
                  ),
                  onDismissed: (_) => _delete(context, box, post),
                  child: BorderedCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          leading: IdBadge(label: '${post['id']}', size: 30),
                          title: Text(
                            cleanText(post['title']),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.black,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              cleanText(post['body']),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.bodyText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(height: 1, color: AppTheme.black),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppTheme.field,
                            border: Border(
                              bottom:
                                  BorderSide(color: AppTheme.black, width: 1.5),
                            ),
                          ),
                          child: Text(
                            note.isEmpty
                                ? 'No personal note yet.'
                                : 'My note: $note',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  note.isEmpty ? AppTheme.hint : AppTheme.black,
                              fontStyle: note.isEmpty
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlackButton(
                              label: 'Edit Note',
                              icon: Icons.edit,
                              height: 34,
                              fullWidth: false,
                              onPressed: () => _editNote(context, box, post),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 34,
                              child: OutlinedButton.icon(
                                onPressed: () => _delete(context, box, post),
                                icon: const Icon(Icons.delete, size: 16),
                                label: const Text('Delete'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.black,
                                  side: const BorderSide(color: AppTheme.black),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.radiusButton),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Modal for editing the short personal note on a saved post.
class _NoteDialog extends StatefulWidget {
  const _NoteDialog({required this.initialNote});

  final String initialNote;

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InstaDialog(
      title: 'Personal Note',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlackButton(
          label: 'Save',
          height: 38,
          fontSize: 13,
          fullWidth: false,
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
        ),
      ],
      child: LabeledField(
        label: 'Note',
        controller: _controller,
        maxLines: 3,
        maxLength: 120,
        autofocus: true,
        hint: 'Write a short note',
      ),
    );
  }
}

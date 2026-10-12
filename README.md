# Post Reader & Favorites (InstaPost)

ITP107 – Mobile Application Development · Finals Laboratory Examination

A Flutter app that loads posts from a MockAPI backend, lets the user open a
post, create a new post (POST request), and save favorite posts locally with
Hive. The UI follows the InstaPost Figma design (black & white theme, bordered
cards, gray underlined inputs, rounded modal) on every screen.

API base URL: `https://6ac8c07efd7c536b1bd9c008.mockapi.io/api/v1`
(resource `/posts`, set once in `lib/constants.dart`).

## Features by exam part

| Part | What it covers | Where |
|------|----------------|-------|
| 1. Routes & Navigation | Named routes `/`, `/details`, `/favorites` with `initialRoute` + `routes`; `pushNamed` / `pop`; id, title, body passed as arguments and read with `ModalRoute.of(context)!.settings.arguments` | `lib/main.dart`, all screens |
| 2. HTTP | `http.get` in an async method called from `initState()`; status 200 check; `jsonDecode`; `ListView.builder` list; on-screen error message with retry; "Create Post" field and floating button open a modal (title and description required) that sends `http.post` with `jsonEncode`; 201 = success message, otherwise failure message | `lib/screens/posts_screen.dart` |
| 3. Hive | `WidgetsFlutterBinding.ensureInitialized()`, `Hive.initFlutter()`, `favoritesBox` opened before `runApp()`; **Create** `put()` keyed by post id; **Read** `box.values`; **Update** personal note; **Delete** button or swipe | `lib/main.dart`, `post_details_screen.dart`, `favorites_screen.dart` |
| Design | One `ThemeData` + shared widgets so every screen matches the Figma design | `lib/theme/app_theme.dart`, `lib/widgets/` |

## Run it

```bash
flutter pub get
flutter run
```

Make sure the emulator/device has internet access. The `INTERNET` permission is
already added to `android/app/src/main/AndroidManifest.xml`.

## Project structure

```
lib/
  main.dart                      app entry, Hive setup, named routes
  constants.dart                 box name and API URLs
  theme/app_theme.dart           colors, spacing, ThemeData, input style
  utils/text_utils.dart          cleans "\n" text coming from the API
  widgets/
    insta_app_bar.dart           logo + underlined title + heart + profile
    post_card.dart               compact card used in the 2-column list
    bordered_card.dart           black-border card with soft shadow
    id_badge.dart                black circle with the post number
    black_button.dart            black "Read Post" style button
    labeled_field.dart           label + gray underlined field
    insta_dialog.dart            rounded modal shell
    status_banner.dart           on-screen success / error message
  screens/
    posts_screen.dart            '/'          GET list, Create Post modal
    post_details_screen.dart     '/details'   post + Save to Favorites
    favorites_screen.dart        '/favorites' read, edit note, delete
```

## Demo checklist (for screenshots / screen recording)

1. Posts list loads.
2. Tap a post → details screen.
3. Tap the **Create Post** field (or the + button) → fill in → Post → success message (status 201).
4. Tap **Save to Favorites** → open Favorites (heart icon).
5. Edit a note, then delete a post (button or swipe left).
6. Save a post, close the app completely, reopen → favorite is still there.

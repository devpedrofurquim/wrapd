Wrapd
=====

Your GitHub year — beautifully wrapped.

Wrapd is a mobile app built with Flutter, showcasing your GitHub contributions in a visual summary. Think of it as your GitHub "Spotify Wrapped".

Tech Stack
----------

- Flutter + Dart (Material 3)
- Clean Architecture (data, domain, presentation layers)
- BLoC for state management
- GoRouter for navigation
- GetIt for dependency injection
- App Links for OAuth callback handling
- GitHub OAuth (in progress)
- In-App Purchases (planned)

Folder Structure
----------------

lib/
├── app/              # Root app widget, router, theme
├── core/             # Shared base classes, utils
├── features/
│   ├── auth/         # GitHub login feature
│   ├── summary/      # Main summary screen (after login)
│   └── ...           # Future features (e.g., premium)
├── l10n/             # Localization
├── gen/              # Generated files (intl, freezed)
└── main.dart         # Entry point

Made with love by Pedro Furquim

License
-------

MIT — see LICENSE.md for details.

# Project Overview
This is a cross-platform Flutter application. 
Primary goal: Write clean, modular, and highly performant Dart code.

# Tech Stack & State Management
- Framework: Flutter
- State Management: Riverpod
- Routing: [Insert GoRouter or AutoRoute if you use them, otherwise leave blank]

# Architectural Rules
1. **Riverpod First:** Always prefer `ConsumerWidget` or `ConsumerStatefulWidget` over standard `StatefulWidget`. 
2. **Immutability:** State classes should be immutable. Use `Freezed` (if installed) or standard Dart data classes with `copyWith` methods.
3. **Logic Separation:** Never put business logic or API calls directly inside UI widgets. UI widgets should only `ref.watch` or `ref.read` from providers.
4. **Provider Scope:** Keep providers as narrowly scoped as possible to prevent unnecessary widget rebuilds.

# Directory Structure
- `lib/core/`: Shared utilities, themes, and global constants.
- `lib/features/`: Feature-first architecture. Each feature folder should contain its own `presentation/`, `domain/`, and `data/` subfolders.
- `lib/widgets/`: Highly reusable, dumb UI components (like your custom refresh indicator).

# Claude Code Agent Instructions
- **Be Concise:** Do not output long explanations unless explicitly asked. Just provide the corrected code.
- **Limit File Reads:** Only read the files explicitly mentioned in the prompt. Do not scan the entire `lib/` folder unless asked to map dependencies.
- **Formatting:** Ensure all generated code adheres to standard `dart format` rules (80 character line limit, trailing commas).
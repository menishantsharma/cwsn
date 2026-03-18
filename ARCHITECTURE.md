# CWSN App — Architecture Guide

A plain-English guide to how this codebase is structured and how everything connects.
Written for anyone who is new to the project.

---

## What is this app?

CWSN connects **parents of children with special needs** to **caregivers** and service providers.
A single user account can act as both a Parent and a Caregiver. They switch between the two
roles inside the app without logging out.

---

## Where to start reading

If you are new, read files in this order:

1. [`lib/main.dart`](lib/main.dart) — two lines. Just starts the app.
2. [`lib/app.dart`](lib/app.dart) — wires the router and theme into `MaterialApp`.
3. [`lib/core/router/nav_config.dart`](lib/core/router/nav_config.dart) — defines every tab and which role sees it.
4. [`lib/core/router/app_router.dart`](lib/core/router/app_router.dart) — defines every screen and who can access it.
5. [`lib/features/auth/presentation/providers/auth_provider.dart`](lib/features/auth/presentation/providers/auth_provider.dart) — the global user state that the whole app depends on.
6. Pick any feature folder under [`lib/features/`](lib/features/) and read its `data/` → `providers/` → `pages/` files in that order.

---

## Technology choices

| What               | Tool                     | Why                                              |
|--------------------|--------------------------|--------------------------------------------------|
| UI framework       | Flutter                  | Cross-platform (iOS + Android)                   |
| State management   | Riverpod 3               | Predictable, testable, no BuildContext needed    |
| Navigation         | GoRouter 17              | Declarative URLs, shell routes, redirect guards  |
| Data models        | Freezed                  | Immutable, auto-generates `copyWith` and JSON    |
| HTTP (future)      | Dio 5                    | Interceptors, timeouts — wired but not used yet  |
| Animations         | flutter_animate          | Chainable, readable animation syntax             |
| Images             | cached_network_image     | Disk cache, fallback placeholder                 |
| Fonts              | Google Fonts (Poppins)   | Consistent typography across platforms           |

---

## Folder structure

```
lib/
├── main.dart              ← Entry point
├── app.dart               ← Root widget
│
├── core/                  ← Shared stuff used by every feature
│   ├── router/            ← Navigation setup
│   ├── theme/             ← Colors, fonts, Material 3 theme
│   ├── models/            ← User and shared data models
│   ├── network/           ← API client contract + fake stub
│   ├── constants/         ← App-wide constant values
│   ├── data/              ← Shared mock data (users, caregivers)
│   ├── utils/             ← Pure utility functions
│   └── widgets/           ← Reusable UI components
│
└── features/              ← One folder per product feature
    ├── auth/              ← Login, role selection
    ├── caregivers/        ← Browse and contact caregivers
    ├── notifications/     ← Alerts and messages
    ├── requests/          ← Caregiver's incoming service requests
    ├── services/          ← Service catalog and search
    ├── settings/          ← Profile, children, services management
    ├── special_needs/     ← Browse special needs categories
    └── user/              ← Edit profile, upload photo
```

Each feature folder follows the same internal structure:

```
features/some_feature/
├── data/
│   ├── some_repository.dart    ← Abstract contract + fake implementation
│   └── some_data.dart          ← Hard-coded mock data
├── models/
│   └── some_model.dart         ← Freezed data class
└── presentation/
    ├── providers/
    │   └── some_provider.dart  ← Riverpod providers (state + logic)
    └── pages/
        └── some_page.dart      ← UI only, no business logic
```

The rule is: **data flows up, nothing flows down**.
Repositories talk to data. Providers talk to repositories. Pages talk to providers. Pages never talk to repositories directly.

---

## Core concepts explained

### 1. The user model — `lib/core/models/user_model.dart`

Everything revolves around the `User` object. It holds:

- Basic info: name, email, phone, gender, location, photo
- `activeRole` — either `UserRole.parent` or `UserRole.caregiver`
- `parentProfile` — children list, join date
- `caregiverProfile` — about, services offered, languages, experience, availability
- `isGuest` — true for users who skipped login

A single `User` object contains both role profiles because one real person may be both a parent and a caregiver.

### 2. Global auth state — `lib/features/auth/presentation/providers/auth_provider.dart`

`currentUserProvider` is the most important provider in the app. It holds a `User?` — null means logged out.

```
currentUserProvider  →  User?
                            ↓
                     activeRole  →  drives navigation, UI, tabs
```

Every redirect in the router reads this provider. Every page that needs to know who is logged in watches this provider.

The `AuthNotifier` exposes:
- `loginWithGoogle()`, `loginWithApple()`, `loginAsGuest()` — set the user
- `switchRole(newRole)` — changes `activeRole` without logging out
- `updateUser(updatedUser)` — called by child/service notifiers after saving data
- `logout()` — sets user to null

### 3. Navigation — `lib/core/router/`

There are three files that work together:

**`app_routes.dart`** — just a list of string constants. Every route name and path lives here so nothing is hardcoded elsewhere.

**`nav_config.dart`** — defines which tabs exist and which role sees them.

```
Parent sees:    Home (Services)  |  Alerts  |  Profile
Caregiver sees: Home (Requests)  |  Alerts  |  Profile
```

`NavConfig.tabsForRole(role)` returns the right list. The shell uses this — no `if (role == parent)` scattered in widget code.

**`app_router.dart`** — the full router. It does two jobs:

1. **Redirect guard**: Before showing any screen, it checks `currentUserProvider`.
   - Not logged in → go to Login
   - Logged in but no role → go to Role Selection
   - Logged in, has role → allow through
   - Guest user → only allowed on whitelisted routes

2. **Route definitions**: Maps paths to widgets. The tabbed shell uses `StatefulShellRoute.indexedStack` which keeps each tab's state alive while you switch tabs (like a real native app).

### 4. State management pattern — Riverpod

Every provider follows one of two patterns:

**`FutureProvider`** — for read-only async data:
```dart
final servicesListProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(serviceRepositoryProvider);
  return repo.getServicesList();
});
```
The UI watches this and gets `AsyncLoading / AsyncError / AsyncData` automatically.

**`AsyncNotifier`** — for data you also need to mutate:
```dart
class NotificationsNotifier extends AsyncNotifier<List<NotificationItem>> {
  Future<void> markAsRead(String id) async {
    // 1. Update UI optimistically
    // 2. Call repository
    // 3. Roll back if it fails
  }
}
```

**`autoDispose`** means the provider is destroyed when no widget is watching it anymore. Good for search queries and filters — they reset automatically when you leave the page.

### 5. Repositories — the fake/real swap pattern

Every feature has an abstract repository class and a `Fake` implementation:

```dart
abstract class ServiceRepository {
  Future<List<ServiceSection>> getServicesList();
}

class FakeServiceRepository implements ServiceRepository {
  @override
  Future<List<ServiceSection>> getServicesList() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate network
    return mockServiceSections;
  }
}
```

To connect to a real API later, create a `RealServiceRepository` and swap it in the provider. No page or notifier changes needed.

### 6. Role switching

When the user taps "Switch Role" in Settings:

1. `settings_page.dart` navigates to `/switching`
2. `SwitchingScreen` is shown with a loading animation (scale + fade transition, not a regular slide — it feels like a mode change)
3. After 1.8 seconds, `AuthNotifier.switchRole(newRole)` is called
4. The router redirects to the new role's home screen
5. The entire shell is recreated (it has `key: ValueKey(role)`) so all scroll positions and tab state are cleared
6. The new shell fades in

---

## Feature walkthrough

### Auth

**Files**: `features/auth/`

The login page offers Google, Apple, Facebook, and Guest login. Each calls `AuthNotifier` which delegates to `FakeAuthRepository` (returns the mock user after a 2-second delay).

After login, if `activeRole` is null, the router sends the user to `RoleSelectionPage`. Picking a role saves it to the `User` object and navigation proceeds to the appropriate home.

### Services (Parent Home)

**Files**: `features/services/`

The parent's home tab. Shows service categories (Educational Support, Therapy Services, etc.) as horizontal scrollable rows. Tapping a category opens `CategoryServicesPage`. The search icon opens `ServiceSearchScreen`.

Search works with a two-layer query:
- `serviceSearchQueryProvider` holds the last *submitted* query (not every keystroke)
- `serviceSearchResultsProvider` watches that and fetches results
- An empty query guard prevents fetching on empty string

### Caregivers

**Files**: `features/caregivers/`

Accessible from the Special Needs page or service cards. Shows a filterable, sortable list of caregivers.

Filter/sort state lives in `caregiverFilterProvider` and `caregiverSortProvider` — both `autoDispose`, so they reset when you leave the list. `caregiversListProvider` watches both and re-fetches automatically when either changes.

The caregiver profile page can:
- Send / unsend a service request
- Recommend a caregiver
- View their services, languages, experience

### Requests (Caregiver Home)

**Files**: `features/requests/`

The caregiver's home tab. Shows pending requests from parents.

`pendingRequestsProvider` and `requestHistoryProvider` are separate notifiers. Both use **optimistic updates** — the UI removes/updates the item immediately, then the repository call happens in the background. If the call fails, the previous state is restored.

### Notifications

**Files**: `features/notifications/`

One list for all alerts. The badge count on the tab is derived from `unreadNotificationCountProvider` which is a plain `Provider` that counts unread items from `notificationsProvider`. Mark-as-read and mark-all-as-read both use optimistic updates.

### Settings

**Files**: `features/settings/`

Shows different content based on role:
- **Parent**: Edit profile, Add/manage children
- **Caregiver**: Edit profile, Add/manage services offered
- **Both**: Switch role, Logout, Delete account

Child and service management goes through their own notifiers (`ChildNotifier`, `CaregiverServiceNotifier`). These notifiers save to their repository, then call `AuthNotifier.updateUser()` to write the result back to the global user state. This keeps `currentUserProvider` as the single source of truth.

Guest users see a "Please login" placeholder instead of the full settings page.

---

## Shared widgets cheat sheet

| Widget | File | Use it when |
|---|---|---|
| `AppTopBar` | `core/widgets/app_top_bar.dart` | You need a consistent app bar with optional back button and actions |
| `ModernRefreshIndicatorList` | `core/widgets/modern_refresh_indicator.dart` | You have a `ListView` that needs pull-to-refresh |
| `ShimmerBox` | `core/widgets/shimmer_box.dart` | You need a loading skeleton placeholder |
| `EmptyStateWidget` | `core/widgets/empty_state_widget.dart` | A list is empty |
| `ErrorStateWidget` | `core/widgets/error_state_widget.dart` | A fetch failed and you need a retry button |
| `GuestPlaceholder` | `core/widgets/guest_placeholder.dart` | A page requires login but user is a guest |
| `UserAvatar` | `core/widgets/user_avatar.dart` | Showing a user's profile photo with initial fallback |
| `GenderSelector` | `core/widgets/gender_selector.dart` | A gender picker in a form |

---

## Data flow diagram

```
User taps a button
      │
      ▼
   Page (UI only)
   ref.read(someProvider.notifier).doSomething()
      │
      ▼
   Notifier (logic only)
   calls repository, updates state
      │
      ├──▶ Repository (data only)
      │    talks to fake/real API
      │    returns result
      │
      ▼
   Notifier updates AsyncValue state
      │
      ▼
   All watching widgets rebuild automatically
```

---

## How to add a new feature

1. Create `lib/features/my_feature/`
2. Add the model in `models/my_model.dart` (use Freezed)
3. Add mock data in `data/my_data.dart`
4. Add the repository contract + fake in `data/my_repository.dart`
5. Add a provider in `presentation/providers/my_provider.dart`
6. Add the page in `presentation/pages/my_page.dart` — only `ref.watch` here
7. Add the route to `app_routes.dart` and `app_router.dart`
8. If it's a tab, add it to `nav_config.dart`

---

## Common gotchas

**Why is my scroll position not resetting after role switch?**
The shell is keyed by role so it rebuilds, but if your page widget is a `ConsumerWidget`
(stateless), any `ListView` inside it may preserve its scroll via `PageStorage`.
Fix: pass `key: ValueKey(role)` to the body widget that contains the scroll view.

**Why is my filter not resetting when I navigate back?**
If your provider is not `autoDispose`, it stays alive. Add `.autoDispose` to reset it
when no widget is watching.

**Why does my provider not update when the user changes?**
Make sure you are watching `currentUserProvider` inside the provider's `build()` method,
not just reading it once.

**Why is there a 2-second delay on everything?**
All repositories are fake and add artificial delays to simulate real network calls.
The delays are just `Future.delayed()` calls at the top of each repository method.

---

## Replacing fake data with real API calls

All repositories follow the same pattern. To go live:

1. Open `lib/core/network/api_client.dart` and implement `RealApiClient` using Dio
2. For each feature, create `RealXxxRepository implements XxxRepository`
3. In the repository provider, swap `FakeXxxRepository()` for `RealXxxRepository(ref.read(apiClientProvider))`

No notifier, no page, no test needs to change.

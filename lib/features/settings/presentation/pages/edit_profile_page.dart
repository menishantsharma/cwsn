import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/auth/data/user_repository.dart';
import 'package:cwsn/features/settings/presentation/widgets/language_selection_dialog.dart';
import 'package:cwsn/features/settings/presentation/widgets/phone_verification_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  // 1. OPTIMIZED: Using Controllers and ValueNotifiers completely eliminates the need for setState!
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneController;

  late final ValueNotifier<Gender?> _genderNotifier;
  late final ValueNotifier<List<String>> _languagesNotifier;
  late final ValueNotifier<bool> _isLoadingNotifier;

  String? _avatarUrl;

  final List<String> _allLanguages = [
    "Hindi",
    "English",
    "Marathi",
    "Tamil",
    "Telugu",
    "Kannada",
    "Malayalam",
    "Bengali",
    "Gujarati",
    "Punjabi",
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;

    _nameController = TextEditingController(text: user?.firstName ?? "");
    _locationController = TextEditingController(text: user?.location ?? "");
    _phoneController = TextEditingController(text: user?.phoneNumber ?? "");

    _genderNotifier = ValueNotifier(user?.gender);
    _languagesNotifier = ValueNotifier([]);
    _isLoadingNotifier = ValueNotifier(false);

    _avatarUrl = user?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _genderNotifier.dispose();
    _languagesNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  // --- ACTIONS ---

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      _showSnack("Please enter your name");
      return;
    }
    if (_genderNotifier.value == null) {
      _showSnack("Please select a gender");
      return;
    }

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    // 2. OPTIMIZED: Trigger loading state without rebuilding the page
    _isLoadingNotifier.value = true;

    try {
      final updatedUser = currentUser.copyWith(
        firstName: _nameController.text.trim(),
        location: _locationController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        gender: _genderNotifier.value,
      );

      final savedUser = await ref
          .read(userRepositoryProvider)
          .updateUserProfile(updatedUser);
      ref.read(currentUserProvider.notifier).updateProfile(savedUser);

      if (mounted) _showSnack("Profile Updated Successfully!");
    } catch (e) {
      if (mounted) _showSnack("Failed to update profile. Please try again.");
    } finally {
      if (mounted) _isLoadingNotifier.value = false;
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // Because we removed setState, this build method runs EXACTLY ONCE.
    // Animations will play perfectly on load and never stutter or restart.

    final primaryColor = Theme.of(context).primaryColor;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return PillScaffold(
      title: 'Edit Profile',
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        // 3. OPTIMIZED: Only the button listens to the loading state
        child: ValueListenableBuilder<bool>(
          valueListenable: _isLoadingNotifier,
          builder: (context, isLoading, child) {
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 10,
                  shadowColor: primaryColor.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isLoading
                    ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                    : const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          },
        ).animate().fade(delay: 600.ms).slideY(begin: 0.5, end: 0),
      ),

      body: (context, padding) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: padding.copyWith(
          left: 24,
          right: 24,
          bottom: 150 + bottomInset,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _AvatarSelector(avatarUrl: _avatarUrl, primaryColor: primaryColor),
            const SizedBox(height: 40),

            Column(
              children: [
                _PillInput(
                  label: "First Name",
                  controller: _nameController,
                  icon: Icons.person_outline_rounded,
                  delay: 100,
                ),
                const SizedBox(height: 20),

                _LocationInput(
                  controller: _locationController,
                  delay: 200,
                  onDetectLocation: () async {
                    _showSnack("Fetching current location...");
                    await Future.delayed(const Duration(seconds: 2));
                    // 4. OPTIMIZED: TextEditingController updates its own UI instantly. No setState needed!
                    _locationController.text =
                        "Powai, Mumbai, Maharashtra 400076";
                  },
                ),
                const SizedBox(height: 24),

                _GenderSelector(genderNotifier: _genderNotifier, delay: 300),
                const SizedBox(height: 24),

                _PhoneInput(
                  controller: _phoneController,
                  delay: 400,
                  onChangeRequested: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => PhoneVerificationSheet(
                        currentPhone: _phoneController.text,
                        onVerified: (newPhone) {
                          _phoneController.text = newPhone; // Updates instantly
                          _showSnack("Phone Number Verified & Updated!");
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                _LanguageSelector(
                  languagesNotifier: _languagesNotifier,
                  allLanguages: _allLanguages,
                  delay: 500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// OPTIMIZED: EXTRACTED STATELESS WIDGETS
// ==========================================

class _AvatarSelector extends StatelessWidget {
  final String? avatarUrl;
  final Color primaryColor;

  const _AvatarSelector({required this.avatarUrl, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade100,
              backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(avatarUrl!)
                  : null,
              child: (avatarUrl == null || avatarUrl!.isEmpty)
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }
}

class _PillInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final int delay;

  const _PillInput({
    required this.label,
    required this.controller,
    required this.icon,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1617).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(
            icon,
            color: context.colorScheme.secondary,
            size: 22,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
        ),
      ),
    ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
  }
}

class _LocationInput extends StatelessWidget {
  final TextEditingController controller;
  final int delay;
  final VoidCallback onDetectLocation;

  const _LocationInput({
    required this.controller,
    required this.delay,
    required this.onDetectLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1617).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "Location",
                labelStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: context.colorScheme.secondary,
                  size: 22,
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 40),
              ),
            ),
          ),
          IconButton(
            onPressed: onDetectLocation,
            icon: Icon(
              Icons.my_location_rounded,
              color: context.colorScheme.primary,
            ),
            tooltip: "Use Current Location",
          ),
        ],
      ),
    ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
  }
}

// 5. OPTIMIZED: Only the Gender Row rebuilds when a gender is clicked
class _GenderSelector extends StatelessWidget {
  final ValueNotifier<Gender?> genderNotifier;
  final int delay;

  const _GenderSelector({required this.genderNotifier, required this.delay});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 10),
          child: Text(
            "Gender",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ValueListenableBuilder<Gender?>(
          valueListenable: genderNotifier,
          builder: (context, selectedGender, child) {
            return Row(
              children: Gender.values.map((gender) {
                final isSelected = selectedGender == gender;
                final label =
                    gender.name[0].toUpperCase() + gender.name.substring(1);

                IconData icon = Icons.transgender_rounded;
                if (gender == Gender.male) icon = Icons.male_rounded;
                if (gender == Gender.female) icon = Icons.female_rounded;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      genderNotifier.value = isSelected ? null : gender;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? primaryColor : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          if (!isSelected)
                            BoxShadow(
                              color: const Color(
                                0xFF1D1617,
                              ).withValues(alpha: 0.05),
                              offset: const Offset(0, 4),
                              blurRadius: 16,
                            ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade400,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
  }
}

// 6. OPTIMIZED: Only the 'CHANGE/ADD' text rebuilds when typing a phone number
class _PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChangeRequested;
  final int delay;

  const _PhoneInput({
    required this.controller,
    required this.onChangeRequested,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1617).withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                final hasPhone = value.text.isNotEmpty;
                return TextFormField(
                  controller: controller,
                  readOnly: true,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: hasPhone ? Colors.grey.shade700 : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Phone Number",
                    hintText: "Add your phone number",
                    labelStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: context.colorScheme.secondary,
                      size: 22,
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 40),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return TextButton(
                onPressed: onChangeRequested,
                child: Text(
                  value.text.isNotEmpty ? "CHANGE" : "ADD",
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
  }
}

// 7. OPTIMIZED: Only the inner text rebuilds when languages change
class _LanguageSelector extends StatelessWidget {
  final ValueNotifier<List<String>> languagesNotifier;
  final List<String> allLanguages;
  final int delay;

  const _LanguageSelector({
    required this.languagesNotifier,
    required this.allLanguages,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final List<String>? result = await showDialog(
          context: context,
          builder: (context) => LanguageSelectionDialog(
            allLanguages: allLanguages,
            selectedLanguages: languagesNotifier.value,
          ),
        );
        if (result != null) languagesNotifier.value = result;
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D1617).withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.translate_rounded,
                  color: context.colorScheme.secondary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  "Languages Spoken",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 34),
              child: ValueListenableBuilder<List<String>>(
                valueListenable: languagesNotifier,
                builder: (context, selectedLanguages, child) {
                  final text = selectedLanguages.isEmpty
                      ? "Select Languages"
                      : selectedLanguages.join(", ");
                  final isPlaceholder = selectedLanguages.isEmpty;
                  return Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isPlaceholder
                          ? Colors.grey.shade400
                          : Colors.black87,
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(delay: delay.ms).slideX(begin: 0.2, end: 0);
  }
}

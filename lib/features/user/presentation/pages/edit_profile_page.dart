import 'package:cwsn/core/constants/app_constants.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/gender_selector.dart';
import 'package:cwsn/core/widgets/user_avatar.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/user/data/user_repository.dart';
import 'package:cwsn/features/user/presentation/providers/user_provider.dart';
import 'package:cwsn/features/settings/presentation/widgets/language_selection_dialog.dart';
import 'package:cwsn/features/settings/presentation/widgets/phone_verification_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _langController;

  Gender? _selectedGender;
  List<String> _selectedLanguages = [];
  bool _isLoading = false;
  bool _isFetchingLocation = false;
  bool _isUploadingImage = false;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;

    _nameController = TextEditingController(text: user?.firstName ?? "");
    _locationController = TextEditingController(text: user?.location ?? "");
    _phoneController = TextEditingController(text: user?.phoneNumber ?? "");
    _langController = TextEditingController();

    _selectedGender = user?.gender;
    _selectedLanguages = [];
    _avatarUrl = user?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _langController.dispose();
    super.dispose();
  }

  void _updateLanguagesUI() {
    _langController.text = _selectedLanguages.isEmpty
        ? ""
        : _selectedLanguages.join(", ");
  }

  Future<void> _fetchLocation() async {
    setState(() => _isFetchingLocation = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _locationController.text = "Powai, Mumbai, Maharashtra";
    setState(() => _isFetchingLocation = false);
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Profile Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF0F0F0),
                  child: Icon(Icons.camera_alt_rounded, color: Colors.black87),
                ),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF0F0F0),
                  child: Icon(Icons.photo_library_rounded, color: Colors.black87),
                ),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_avatarUrl != null)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFDE8E8),
                    child: Icon(Icons.delete_rounded, color: Colors.red),
                  ),
                  title: const Text('Remove Photo',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _avatarUrl = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 512,
      imageQuality: 80,
    );
    if (picked == null || !mounted) return;

    setState(() => _isUploadingImage = true);

    try {
      final user = ref.read(currentUserProvider).value;
      final repo = ref.read(userRepositoryProvider);
      final url = await repo.uploadProfileImage(user?.id ?? '', picked.path);
      if (!mounted) return;
      setState(() {
        _avatarUrl = url;
        _isUploadingImage = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploadingImage = false);
      _showSnack('Failed to upload image. Please try again.');
    }
  }

  Future<void> _saveChanges() async {
    // Unfocus keyboard before saving
    FocusScope.of(context).unfocus();

    if (_nameController.text.trim().isEmpty) {
      return _showSnack("Please enter your name");
    }
    if (_selectedGender == null) return _showSnack("Please select a gender");

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = currentUser.copyWith(
        firstName: _nameController.text.trim(),
        location: _locationController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        gender: _selectedGender,
        imageUrl: _avatarUrl,
      );

      final saved =
          await ref.read(userProfileNotifierProvider).saveProfile(updatedUser);

      if (!mounted) return;

      // Pop first so the router refresh from updateUser doesn't
      // rebuild this page and swallow the pop.
      context.pop();
      ref.read(currentUserProvider.notifier).updateUser(saved);
    } catch (e) {
      if (mounted) _showSnack("Failed to update profile. Please try again.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  InputDecoration _inputStyle(String label, IconData icon, {Widget? trailing}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22),
      suffixIcon: trailing,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        appBar: const AppTopBar(title: 'Edit Profile'),

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ),

        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            // Avatar
            Center(
              child: GestureDetector(
                onTap: _isUploadingImage ? null : _showImagePickerSheet,
                child: Stack(
                  children: [
                    UserAvatar(
                      imageUrl: _avatarUrl,
                      name: _nameController.text,
                      size: 100,
                      isCircle: true,
                    ),
                    if (_isUploadingImage)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
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
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            TextFormField(
              controller: _nameController,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: _inputStyle(
                "First Name",
                Icons.person_outline_rounded,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _locationController,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: _inputStyle(
                "Location",
                Icons.location_on_outlined,
                trailing: IconButton(
                  icon: _isFetchingLocation
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        )
                      : Icon(Icons.my_location_rounded, color: primaryColor),
                  onPressed: _isFetchingLocation ? null : _fetchLocation,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Gender
            Text(
              "Gender",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GenderSelector(
              selectedGender: _selectedGender,
              onChanged: (gender) => setState(() => _selectedGender = gender),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _phoneController,
              readOnly: true,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              decoration: _inputStyle(
                "Phone Number",
                Icons.phone_outlined,
                trailing: TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => PhoneVerificationSheet(
                        currentPhone: _phoneController.text,
                        onVerified: (newPhone) {
                          setState(() {
                            _phoneController.text = newPhone;
                          });
                        },
                      ),
                    );
                  },
                  child: Text(
                    "CHANGE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _langController,
              readOnly: true,
              onTap: () async {
                FocusScope.of(context).unfocus();
                final List<String>? result = await showDialog(
                  context: context,
                  builder: (_) => LanguageSelectionDialog(
                    allLanguages: AppConstants.supportedLanguages,
                    selectedLanguages: _selectedLanguages,
                  ),
                );
                if (result != null) {
                  setState(() {
                    _selectedLanguages = result;
                    _updateLanguagesUI();
                  });
                }
              },
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: _inputStyle(
                "Languages Spoken",
                Icons.translate_rounded,
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

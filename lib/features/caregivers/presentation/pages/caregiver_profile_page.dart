import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/utils/utils.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_skeleton_profile.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/select_child_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaregiverProfilePage extends ConsumerStatefulWidget {
  final String caregiverId;
  const CaregiverProfilePage({super.key, required this.caregiverId});

  @override
  ConsumerState<CaregiverProfilePage> createState() =>
      _CaregiverProfilePageState();
}

class _CaregiverProfilePageState extends ConsumerState<CaregiverProfilePage> {
  final CaregiverRepository _repository = CaregiverRepository();
  late Future<User> _profileFuture;
  bool _isRequestSent = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _repository.getCaregiverDetails(widget.caregiverId);
  }

  void _showSelectChildSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectChildSheet(
        caregiverId: widget.caregiverId,
        // --- NEW: Pass the success callback ---
        onRequestSent: () {
          setState(() {
            _isRequestSent = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PillScaffold(
            title: 'Profile',
            body: (context, padding) =>
                CaregiverProfileSkeleton(padding: padding),
          );
        }

        if (snapshot.hasError) {
          return PillScaffold(
            title: 'Profile',
            body: (context, padding) =>
                Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final user = snapshot.data!;

        return PillScaffold(
          title: 'Profile',
          actionIcon: Icons.share_rounded,
          onActionPressed: () {},

          floatingActionButton: _buildBottomAction(
            context,
            caregiverProfile: user.caregiverProfile!,
            currentUser: ref.watch(currentUserProvider),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: (context, padding) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: padding.copyWith(left: 24, right: 24, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(user),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatBox(
                        "Recommended",
                        numberOfRecommendationsToK(
                          user.caregiverProfile!.totalRecommendations,
                        ),
                        Icons.thumb_up_rounded,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                        "Experience",
                        "${user.caregiverProfile!.yearsOfExperience} Yrs",
                        Icons.work_history_rounded,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                        "Parents Connected",
                        "50+",
                        Icons.family_restroom_rounded,
                        Colors.green,
                      ),
                    ),
                  ],
                ).animate().fade().slideY(begin: 0.2, end: 0, delay: 100.ms),

                const SizedBox(height: 32),

                _buildSectionTitle("About"),
                Text(
                  user.caregiverProfile!.about,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade700,
                  ),
                ).animate().fade(delay: 200.ms),

                const SizedBox(height: 24),

                _buildSectionTitle("Specialties"),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: user.caregiverProfile!.services.map((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF535CE8).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF535CE8).withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        service,
                        style: const TextStyle(
                          color: Color(0xFF535CE8),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ).animate().fade(delay: 300.ms),

                const SizedBox(height: 24),

                _buildSectionTitle("Details"),
                _buildDetailRow(
                  Icons.location_on_outlined,
                  "Location",
                  user.location ?? "Not specified",
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.translate_rounded,
                  "Languages",
                  user.caregiverProfile!.languages.isNotEmpty
                      ? user.caregiverProfile!.languages.join(", ")
                      : "Not specified",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(User user) {
    final caregiver = user.caregiverProfile!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1617).withValues(alpha: 0.06),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              image: user.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(user.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: user.imageUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caregiver.isVerified) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 12,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Verified Account",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                Text(
                  user.firstName, // Uses the model's helper
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Certified Caregiver",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBottomAction(
    BuildContext context, {
    required CaregiverProfile caregiverProfile,
    required User? currentUser,
  }) {
    Widget currentButton;

    if (currentUser == null || currentUser.isGuest) {
      currentButton = _buildStyledButton(
        key: const ValueKey('login_btn'),
        text: "Login to Request Service",
        icon: Icons.login_rounded,
        backgroundColor: context.colorScheme.primary,
        textColor: Colors.white,
        onTap: () => ref.read(currentUserProvider.notifier).state = null,
      );
    } else if (_isRequestSent) {
      // --- UPDATED: Flat Grey Cancellable State ---
      currentButton = _buildStyledButton(
        key: const ValueKey('sent_btn'),
        text: "Request Sent",
        subText: "Tap to cancel", // Keeps the visual cue
        icon: Icons.check_circle_rounded,
        backgroundColor: Colors.grey.shade200, // Flat grey background
        textColor: Colors.grey.shade600, // Dark grey text
        hasShadow: false, // No shadow for the "inactive" look
        onTap: () {
          // Instantly cancel the request (NO SnackBar)
          setState(() {
            _isRequestSent = false;
          });
        },
      );
    } else if (caregiverProfile.isAvailable) {
      currentButton = _buildStyledButton(
        key: const ValueKey('request_btn'),
        text: "Request Service",
        icon: Icons.arrow_forward_rounded,
        backgroundColor: context.colorScheme.primary,
        textColor: Colors.white,
        onTap: () => _showSelectChildSheet(context),
      );
    } else {
      currentButton = _buildStyledButton(
        key: const ValueKey('unavailable_btn'),
        text: "Currently Unavailable",
        icon: null,
        backgroundColor: Colors.grey.shade200,
        textColor: Colors.grey.shade400,
        hasShadow: false,
        onTap: null,
      );
    }

    return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: currentButton,
        )
        .animate(delay: 500.ms)
        .fade(duration: 400.ms)
        .slideY(
          begin: 1.5,
          end: 0,
          curve: Curves.easeOutCubic,
          duration: 400.ms,
        );
  }

  Widget _buildStyledButton({
    required Key key,
    required String text,
    String? subText,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    VoidCallback? onTap,
    bool hasShadow = true,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      height: 58, // <-- THE FIX: Fixed height prevents layout jumps!
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          // --- THE FIX: We use Center() instead of Padding() ---
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: 22),
                  const SizedBox(width: 8),
                ],
                Column(
                  mainAxisSize:
                      MainAxisSize.min, // Keeps the texts stacked tightly
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.2, // Helps keep text centered beautifully
                      ),
                    ),
                    if (subText != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subText,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

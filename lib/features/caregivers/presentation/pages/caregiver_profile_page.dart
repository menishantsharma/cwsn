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

// --- PROVIDER ---
final caregiverProfileProvider = FutureProvider.autoDispose
    .family<User, String>((ref, caregiverId) async {
      final repository = ref.watch(caregiverRepositoryProvider);
      return repository.getCaregiverDetails(caregiverId);
    });

class CaregiverProfilePage extends ConsumerStatefulWidget {
  final String caregiverId;
  const CaregiverProfilePage({super.key, required this.caregiverId});

  @override
  ConsumerState<CaregiverProfilePage> createState() =>
      _CaregiverProfilePageState();
}

class _CaregiverProfilePageState extends ConsumerState<CaregiverProfilePage> {
  bool _isRequestSent = false;

  void _showSelectChildSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectChildSheet(
        caregiverId: widget.caregiverId,
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
    // 1. OPTIMIZED: Use Riverpod's built-in AsyncValue handling instead of FutureBuilder
    final profileAsync = ref.watch(
      caregiverProfileProvider(widget.caregiverId),
    );

    // 2. OPTIMIZED: Properly extract the User value from the new AsyncNotifier
    final currentUser = ref.watch(currentUserProvider).value;

    return PillScaffold(
      title: 'Profile',
      actionIcon: Icons.share_rounded,
      onActionPressed: () {},

      // Only show the bottom action if we successfully loaded the caregiver
      floatingActionButton: profileAsync.hasValue
          ? _buildBottomAction(
              context,
              caregiverProfile: profileAsync.value!.caregiverProfile!,
              currentUser: currentUser,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: (context, padding) => profileAsync.when(
        loading: () => CaregiverProfileSkeleton(padding: padding),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (user) {
          final caregiver = user.caregiverProfile!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: padding.copyWith(left: 24, right: 24, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // OPTIMIZED: Extracted to a const Stateless Widget
                CaregiverProfileHeader(user: user),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: StatBox(
                        label: "Recommended",
                        value: numberOfRecommendationsToK(
                          caregiver.totalRecommendations,
                        ),
                        icon: Icons.thumb_up_rounded,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatBox(
                        label: "Experience",
                        value: "${caregiver.yearsOfExperience} Yrs",
                        icon: Icons.work_history_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: StatBox(
                        label: "Parents Connected",
                        value: "50+",
                        icon: Icons.family_restroom_rounded,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ).animate().fade().slideY(begin: 0.2, end: 0, delay: 100.ms),

                const SizedBox(height: 32),

                const SectionTitle(title: "About"),
                Text(
                  caregiver.about,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade700,
                  ),
                ).animate().fade(delay: 200.ms),

                const SizedBox(height: 24),

                const SectionTitle(title: "Specialties"),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: caregiver.services.map((service) {
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

                const SectionTitle(title: "Details"),
                DetailRow(
                  icon: Icons.location_on_outlined,
                  label: "Location",
                  value: user.location ?? "Not specified",
                ),
                const SizedBox(height: 16),
                DetailRow(
                  icon: Icons.translate_rounded,
                  label: "Languages",
                  value: caregiver.languages.isNotEmpty
                      ? caregiver.languages.join(", ")
                      : "Not specified",
                ),
              ],
            ),
          );
        },
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
      currentButton = StyledBottomButton(
        key: const ValueKey('login_btn'),
        text: "Login to Request Service",
        icon: Icons.login_rounded,
        backgroundColor: context.colorScheme.primary,
        textColor: Colors.white,
        // OPTIMIZED: Use the correct logout method we built earlier
        onTap: () => ref.read(currentUserProvider.notifier).logout(),
      );
    } else if (_isRequestSent) {
      currentButton = StyledBottomButton(
        key: const ValueKey('sent_btn'),
        text: "Request Sent",
        subText: "Tap to cancel",
        icon: Icons.check_circle_rounded,
        backgroundColor: Colors.grey.shade200,
        textColor: Colors.grey.shade600,
        hasShadow: false,
        onTap: () => setState(() => _isRequestSent = false),
      );
    } else if (caregiverProfile.isAvailable) {
      currentButton = StyledBottomButton(
        key: const ValueKey('request_btn'),
        text: "Request Service",
        icon: Icons.arrow_forward_rounded,
        backgroundColor: context.colorScheme.primary,
        textColor: Colors.white,
        onTap: () => _showSelectChildSheet(context),
      );
    } else {
      currentButton = StyledBottomButton(
        key: const ValueKey('unavailable_btn'),
        text: "Currently Unavailable",
        backgroundColor: Colors.grey.shade200,
        textColor: Colors.grey.shade400,
        hasShadow: false,
      );
    }

    return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          ),
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
}

// ==========================================
// OPTIMIZED: EXTRACTED STATELESS WIDGETS
// ==========================================

class CaregiverProfileHeader extends StatelessWidget {
  final User user;
  const CaregiverProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final caregiver = user.caregiverProfile!;
    return Row(
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
                user.firstName,
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
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }
}

class StatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const StatBox({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
}

class StyledBottomButton extends StatelessWidget {
  final String text;
  final String? subText;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool hasShadow;

  const StyledBottomButton({
    super.key,
    required this.text,
    this.subText,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.onTap,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
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
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: 22),
                  const SizedBox(width: 8),
                ],
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                    if (subText != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subText!,
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

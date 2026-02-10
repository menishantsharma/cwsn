import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/presentation/widgets/caregiver_skeleton_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CaregiverProfilePage extends StatefulWidget {
  final String caregiverId;
  const CaregiverProfilePage({super.key, required this.caregiverId});

  @override
  State<CaregiverProfilePage> createState() => _CaregiverProfilePageState();
}

class _CaregiverProfilePageState extends State<CaregiverProfilePage> {
  final CaregiverRepository _repository = CaregiverRepository();
  late Future<User> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _repository.getCaregiverDetails(widget.caregiverId);
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

          floatingActionButton: _buildBookButton(
            context,
            isAvailable: user.caregiverProfile!.isAvailable,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: (context, padding) => SingleChildScrollView(
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
                        "${user.caregiverProfile!.rating / 1000}k",
                        Icons.thumb_up_rounded,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                        "Experience",
                        "5 Yrs",
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
              image: DecorationImage(
                image: CachedNetworkImageProvider(user.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
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
                  "${user.firstName} ${user.lastName ?? ''}",
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

  Widget _buildBookButton(BuildContext context, {required bool isAvailable}) {
    final backgroundColor = isAvailable
        ? context.colorScheme.primary
        : Colors.grey.shade300;
    final textColor = isAvailable ? Colors.white : Colors.grey.shade500;
    final shadow = isAvailable
        ? BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        : null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [if (shadow != null) shadow],
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: isAvailable ? () {} : null,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isAvailable ? "Request Service" : "Currently Unavailable",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (isAvailable) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(delay: 500.ms).slideY(begin: 1, end: 0);
  }
}

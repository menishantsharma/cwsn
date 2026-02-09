import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/models/caregiver_model.dart';
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
  late Future<Caregiver> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _repository.getCaregiverDetails(widget.caregiverId);
  }

  @override
  Widget build(BuildContext context) {
    return PillScaffold(
      title: 'Profile',
      actionIcon: Icons.share_rounded,
      onActionPressed: () {},

      // Floating Button for Booking
      // floatingActionButton: _buildBookButton(context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: (context, padding) => FutureBuilder<Caregiver>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final caregiver = snapshot.data!;

          return SingleChildScrollView(
            padding: padding.copyWith(left: 24, right: 24, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. HERO PROFILE CARD ---
                _buildProfileHeader(caregiver),

                const SizedBox(height: 24),

                // --- 2. STATS ROW ---
                Row(
                  children: [
                    Expanded(
                      child: _buildStatBox(
                        "Recommended",
                        "${caregiver.rating}",
                        Icons.thumb_up_rounded,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                        "Experience",
                        "5 Yrs", // Mock data
                        Icons.work_history_rounded,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                        "Parents Connected", // CHANGED HERE
                        "50+", // Mock data
                        Icons.family_restroom_rounded,
                        Colors.green,
                      ),
                    ),
                  ],
                ).animate().fade().slideY(begin: 0.2, end: 0, delay: 100.ms),

                const SizedBox(height: 32),

                _buildSectionTitle("About"),
                Text(
                  caregiver.about,
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

                _buildSectionTitle("Details"),
                _buildDetailRow(
                  Icons.location_on_outlined,
                  "Location",
                  caregiver.location,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.translate_rounded,
                  "Languages",
                  caregiver.languages.join(", "),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildProfileHeader(Caregiver caregiver) {
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
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: CachedNetworkImageProvider(caregiver.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CONDITIONAL VERIFIED BADGE
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
                  caregiver.name,
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

  Widget _buildBookButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF535CE8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF535CE8).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Request Service",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
        ],
      ),
    ).animate().fade(delay: 500.ms).slideY(begin: 1, end: 0);
  }
}

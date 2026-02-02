import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/core/widgets/pill_scaffold.dart';
import 'package:cwsn/features/caregivers/data/caregiver_repository.dart';
import 'package:cwsn/features/caregivers/models/caregiver_model.dart';
import 'package:flutter/material.dart';

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
      title: 'Caregiver Profile',
      actionIcon: Icons.ios_share_outlined,
      onActionPressed: () {},

      body: (context, padding) => FutureBuilder<Caregiver>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final caregiver = snapshot.data!;

          return SingleChildScrollView(
            padding: padding.copyWith(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: CachedNetworkImageProvider(
                          caregiver.imageUrl,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        caregiver.name,
                        style: context.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIconText(Icons.wifi, 'Online', context),
                          const SizedBox(width: 16),
                          _buildIconText(
                            Icons.thumb_up_outlined,
                            '${caregiver.rating}',
                            context,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Joined in ${caregiver.joinedDate}',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ------------- SECTIONS BELOW ----------------

                // Location Section
                _buildSectionHeader(Icons.location_pin, 'Location', context),
                Text(
                  caregiver.location,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.85,
                    ),
                  ),
                ),
                _buildDivider(),

                // Services Section
                _buildSectionHeader(
                  Icons.handshake_outlined,
                  'Services Provided',
                  context,
                ),

                Wrap(
                  spacing: 8,
                  children: caregiver.services
                      .map(
                        (s) => Chip(
                          label: Text(
                            s,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 12),

                _buildDivider(),

                // About Section
                _buildSectionHeader(Icons.person_outline, 'About', context),
                Text(
                  caregiver.about,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.85,
                    ),
                  ),
                ),
                _buildDivider(),

                // Languages Section
                _buildSectionHeader(Icons.translate, 'Languages', context),
                Wrap(
                  spacing: 12,
                  children: caregiver.languages
                      .map(
                        (l) => Text(
                          l,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.85),
                          ),
                        ),
                      )
                      .toList(),
                ),

                // For bottom padding
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildSectionHeader(IconData icon, String title, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(title, style: context.textTheme.headlineSmall),
      ],
    ),
  );
}

Widget _buildIconText(IconData icon, String text, BuildContext context) {
  return Row(
    children: [
      Icon(icon, size: 16),
      const SizedBox(width: 4),
      Text(text, style: context.textTheme.labelMedium),
    ],
  );
}

Widget _buildDivider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 24),
    child: Divider(height: 1, color: Colors.grey[200]),
  );
}

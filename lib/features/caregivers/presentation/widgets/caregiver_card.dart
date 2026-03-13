import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/utils/utils.dart';
import 'package:cwsn/core/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class CaregiverCard extends StatelessWidget {
  final User user;
  final VoidCallback onCardTap;

  const CaregiverCard({super.key, required this.onCardTap, required this.user});

  @override
  Widget build(BuildContext context) {
    final profile = user.caregiverProfile;
    final bool isAvailable = profile?.isAvailable ?? false;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      child: InkWell(
        onTap: onCardTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              UserAvatar(
                imageUrl: user.imageUrl,
                name: user.firstName,
                size: 72,
                borderRadius: 12,
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (profile?.isVerified ?? false)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.verified_rounded,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Certified Caregiver",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_up_rounded,
                          size: 14,
                          color: Color(0xFFFF9800),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatCompactNumber(profile?.totalRecommendations ?? 0),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? Colors.green.shade50
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isAvailable ? "AVAILABLE" : "BUSY",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              color: isAvailable
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black12,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

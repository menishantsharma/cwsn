import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter/material.dart';

class CaregiverCard extends StatelessWidget {
  final User user;
  final VoidCallback onCardTap;

  const CaregiverCard({super.key, required this.onCardTap, required this.user});

  @override
  Widget build(BuildContext context) {
    final contentOpacity = user.caregiverProfile?.isAvailable ?? false
        ? 1.0
        : 0.4;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1617).withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onCardTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade50,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ColorFiltered(
                          colorFilter:
                              user.caregiverProfile?.isAvailable ?? false
                              ? const ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.dst,
                                )
                              : const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.saturation,
                                ),
                          child: CachedNetworkImage(
                            imageUrl: user.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, _) =>
                                Container(color: Colors.grey.shade100),
                            errorWidget: (_, _, _) =>
                                const Icon(Icons.person, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: user.caregiverProfile!.isAvailable
                              ? const Color(0xFF4CAF50) // Green
                              : Colors.grey, // Grey
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Opacity(
                    opacity: contentOpacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "${user.firstName} ${user.lastName ?? ''}"
                                    .trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            if (user.caregiverProfile!.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF4589FF),
                                size: 16,
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 6),
                        Text(
                          "Certified Caregiver", // Or caregiver.role
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.thumb_up_rounded,
                              size: 14,
                              color: Color(0xFFFF9800),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${user.caregiverProfile!.rating / 1000}k",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),

                            // Separator
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),

                            Text(
                              "1.2 km away",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

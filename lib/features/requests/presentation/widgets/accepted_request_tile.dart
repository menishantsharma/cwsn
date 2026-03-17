import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter/material.dart';

class AcceptedRequestTile extends StatelessWidget {
  final CaregiverRequest request;

  const AcceptedRequestTile({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final hasImage =
        request.parentImageUrl != null && request.parentImageUrl!.isNotEmpty;
    final isAccepted = request.isAccepted;
    final statusColor =
        isAccepted ? Colors.green.shade600 : Colors.red.shade600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primary.withValues(alpha: 0.08),
                backgroundImage: hasImage
                    ? CachedNetworkImageProvider(request.parentImageUrl!)
                    : null,
                child: !hasImage
                    ? Text(
                        request.parentInitials,
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.parentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            request.parentLocation,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isAccepted ? 'Accepted' : 'Declined',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Detail rows
          _DetailRow(
            icon: Icons.medical_services_outlined,
            label: 'Service',
            value: request.serviceName,
          ),
          const SizedBox(height: 8),
          _DetailRow(
            icon: Icons.accessibility_new_rounded,
            label: 'Need',
            value: request.specialNeed,
          ),
          const SizedBox(height: 8),
          _DetailRow(
            icon: Icons.face_outlined,
            label: 'Child',
            value:
                '${request.childName}, ${request.childAge} yrs, ${request.childGender}',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

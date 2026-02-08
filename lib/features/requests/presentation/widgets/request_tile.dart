import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter/material.dart';

class RequestTile extends StatelessWidget {
  final CaregiverRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RequestTile({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(request.parentImageUrl),
          onBackgroundImageError: (_, _) => const Icon(Icons.person, size: 28),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.parentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 4),
              Text(
                request.serviceDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),

              Text(
                request.childDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),

              Text(
                request.parentLocation,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Row(
          children: [
            _buildActionButton(
              icon: Icons.close,
              color: Colors.grey.shade300,
              iconColor: Colors.black,
              onPressed: onReject,
            ),
            const SizedBox(width: 12),

            _buildActionButton(
              icon: Icons.check,
              color: Colors.green,
              iconColor: Colors.white,
              onPressed: onAccept,
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildActionButton({
  required IconData icon,
  required Color color,
  required Color iconColor,
  required VoidCallback onPressed,
}) {
  return Material(
    color: color,
    shape: const CircleBorder(),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(child: Icon(icon, color: iconColor, size: 20)),
      ),
    ),
  );
}

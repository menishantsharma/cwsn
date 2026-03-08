import 'package:cached_network_image/cached_network_image.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade50,
                  backgroundImage: CachedNetworkImageProvider(
                    request.parentImageUrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.parentName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 12,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              request.parentLocation,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _StatusBadge(),
              ],
            ),
            const Divider(height: 32, thickness: 0.5),

            _InfoRow(
              Icons.medical_services_outlined,
              "Service",
              request.serviceDescription,
            ),
            const SizedBox(height: 12),
            _InfoRow(Icons.face_outlined, "Child", request.childDescription),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _Btn(
                    "Decline",
                    Colors.grey.shade100,
                    Colors.black87,
                    onReject,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Btn(
                    "Accept",
                    const Color(0xFFE53935),
                    Colors.white,
                    onAccept,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: Colors.grey.shade400),
      const SizedBox(width: 12),
      Expanded(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "$label: ",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _Btn extends StatelessWidget {
  final String text;
  final Color bg, tc;
  final VoidCallback press;
  const _Btn(this.text, this.bg, this.tc, this.press);

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: tc,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: press,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Text(
      "NEW",
      style: TextStyle(
        color: Color(0xFF1976D2),
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    ),
  );
}

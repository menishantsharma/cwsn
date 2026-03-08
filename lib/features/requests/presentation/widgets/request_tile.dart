import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/features/requests/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final primaryColor = Theme.of(context).primaryColor;
    final hasImage =
        request.parentImageUrl != null && request.parentImageUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  backgroundImage: hasImage
                      ? CachedNetworkImageProvider(request.parentImageUrl!)
                      : null,
                  child: !hasImage
                      ? Text(
                          request.parentInitials,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: -0.3,
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
                _StatusBadge(label: request.timeAgo),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(
                  Icons.medical_services_outlined,
                  "Service",
                  request.serviceHeader,
                ),
                const SizedBox(height: 12),
                _InfoRow(Icons.face_outlined, "Child", request.childInfo),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _ActionBtn(
                        text: "Decline",
                        bg: Colors.grey.shade100,
                        tc: Colors.black87,
                        onTap: onReject,
                        isDestructive: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionBtn(
                        text: "Accept",
                        bg: const Color(0xFFE53935),
                        tc: Colors.white,
                        onTap: onAccept,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

class _ActionBtn extends StatefulWidget {
  final String text;
  final Color bg, tc;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionBtn({
    required this.text,
    required this.bg,
    required this.tc,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        widget.isDestructive
            ? HapticFeedback.mediumImpact()
            : HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: widget.bg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.tc,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF1976D2),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

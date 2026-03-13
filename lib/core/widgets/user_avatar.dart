import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Reusable avatar widget that displays a user's image or falls back to
/// their initial letter when no image URL is available.
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final double borderRadius;
  final bool isCircle;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.size = 72,
    this.borderRadius = 12,
    this.isCircle = false,
  });

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  String get _initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    if (isCircle) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: _hasImage
            ? Colors.grey.shade100
            : primaryColor.withValues(alpha: 0.1),
        backgroundImage: _hasImage
            ? CachedNetworkImageProvider(imageUrl!)
            : null,
        child: !_hasImage
            ? Text(
                _initial,
                style: TextStyle(
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              )
            : null,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: _hasImage
            ? Colors.grey.shade50
            : primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _hasImage
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => _buildInitial(primaryColor),
              )
            : _buildInitial(primaryColor),
      ),
    );
  }

  Widget _buildInitial(Color color) {
    return Center(
      child: Text(
        _initial,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

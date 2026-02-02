import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      color: Colors.white,

      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 143,
          height: 188,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: item.imgUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: context.colorScheme.surfaceDim,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, _, _) => Icon(Icons.error),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

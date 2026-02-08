import 'package:cached_network_image/cached_network_image.dart';
import 'package:cwsn/core/theme/app_theme.dart';
import 'package:cwsn/features/services/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 143,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1617).withValues(alpha: 0.07),
            offset: const Offset(0, 10),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: item.imgUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: context.colorScheme.surfaceDim,
                    child: Center(
                      child: SpinKitThreeBounce(
                        color: context.colorScheme.primary.withValues(
                          alpha: 0.5,
                        ),
                        size: 20.0,
                      ),
                    ),
                  ),
                  errorWidget: (_, _, _) => const Center(
                    child: Icon(Icons.error_outline, color: Colors.grey),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
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

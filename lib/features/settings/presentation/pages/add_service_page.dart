import 'package:cwsn/core/models/caregiver_service_model.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/core/widgets/empty_state_widget.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/presentation/providers/caregiver_service_provider.dart';
import 'package:cwsn/features/settings/presentation/widgets/add_edit_service_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddServicePage extends ConsumerWidget {
  const AddServicePage({super.key});

  Future<void> _deleteService(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(caregiverServiceNotifierProvider).deleteService(serviceId);
    } catch (_) {
      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Failed to delete. Restoring...")),
        );
      }
    }
  }

  Future<void> _toggleActive(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) async {
    try {
      await ref.read(caregiverServiceNotifierProvider).toggleActive(serviceId);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update. Reverting...")),
        );
      }
    }
  }

  void _openServiceFormSheet(
    BuildContext context,
    WidgetRef ref,
    User user, {
    CaregiverService? existing,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditServiceSheet(
        existingService: existing,
        onSave: (service) async {
          final notifier = ref.read(caregiverServiceNotifierProvider);
          try {
            if (existing == null) {
              await notifier.addService(service);
            } else {
              await notifier.updateService(service);
            }
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to save service.")),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox.shrink();

    final services = user.caregiverProfile?.services ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const AppTopBar(title: 'Provided Services'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const Text(
            "Manage Services",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Add or edit the specialized services you offer.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          if (services.isEmpty)
            const EmptyStateWidget(
              icon: Icons.medical_information_rounded,
              title: 'No services added yet.',
            )
          else
            ...services.map(
              (service) => _ServiceCard(
                service: service,
                onEdit: () => _openServiceFormSheet(
                  context,
                  ref,
                  user,
                  existing: service,
                ),
                onDelete: () => _deleteService(context, ref, service.id),
                onToggleActive: () => _toggleActive(context, ref, service.id),
              ),
            ),

          const SizedBox(height: 16),
          _AddServiceButton(
            onTap: () => _openServiceFormSheet(context, ref, user),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final CaregiverService service;
  final VoidCallback onEdit, onDelete, onToggleActive;

  const _ServiceCard({
    required this.service,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: service.isActive ? Colors.grey.shade200 : Colors.grey.shade100,
        ),
      ),
      child: Opacity(
        opacity: service.isActive ? 1.0 : 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: CircleAvatar(
                backgroundColor: primary.withValues(alpha: 0.1),
                foregroundColor: primary,
                child: const Icon(Icons.medical_services_rounded),
              ),
              title: Text(
                service.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: service.isActive
                  ? null
                  : const Text(
                      'Inactive',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch.adaptive(
                    value: service.isActive,
                    activeTrackColor: primary,
                    onChanged: (_) => onToggleActive(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: onEdit,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            if (service.specialNeeds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: service.specialNeeds
                      .map(
                        (sn) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            sn,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddServiceButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddServiceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        foregroundColor: Theme.of(context).primaryColor,
        side: BorderSide(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onTap,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        "Add New Service",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}

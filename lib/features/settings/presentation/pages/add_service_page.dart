import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/core/widgets/app_top_bar.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/data/caregiver_repository.dart';
import 'package:cwsn/features/settings/presentation/widgets/add_edit_service_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddServicePage extends ConsumerWidget {
  const AddServicePage({super.key});

  Future<void> _deleteService(
    BuildContext context,
    WidgetRef ref,
    User user,
    String service,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final previousProfile = user.caregiverProfile!;

    // Optimistically remove the service
    final optimisticServices = previousProfile.services
        .where((s) => s != service)
        .toList();

    ref
        .read(currentUserProvider.notifier)
        .updateCaregiverProfile(
          previousProfile.copyWith(services: optimisticServices),
        );

    try {
      await ref
          .read(caregiverRepositoryProvider)
          .deleteService(caregiverId: user.id, service: service);
    } catch (e) {
      // Rollback on failure
      ref
          .read(currentUserProvider.notifier)
          .updateCaregiverProfile(previousProfile);
      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Failed to delete. Restoring...")),
        );
      }
    }
  }

  void _openServiceFormSheet(
    BuildContext context,
    WidgetRef ref,
    User user, {
    String? existingService,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditServiceSheet(
        existingService: existingService,
        onSave: (serviceData) async {
          final repo = ref.read(caregiverRepositoryProvider);
          try {
            final savedService = existingService == null
                ? await repo.addService(
                    caregiverId: user.id,
                    service: serviceData,
                  )
                : await repo.updateService(
                    caregiverId: user.id,
                    oldService: existingService,
                    newService: serviceData,
                  );

            final currentServices = user.caregiverProfile?.services ?? [];

            // Rebuild the list with the new/updated service
            final updatedServices = existingService == null
                ? [...currentServices, savedService]
                : currentServices
                      .map((s) => s == existingService ? savedService : s)
                      .toList();

            ref
                .read(currentUserProvider.notifier)
                .updateCaregiverProfile(
                  (user.caregiverProfile ?? const CaregiverProfile()).copyWith(
                    services: updatedServices,
                  ),
                );
          } catch (e) {
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
            const _EmptyState()
          else
            ...services.map(
              (service) => _ServiceCard(
                service: service,
                onEdit: () => _openServiceFormSheet(
                  context,
                  ref,
                  user,
                  existingService: service,
                ),
                onDelete: () => _deleteService(context, ref, user, service),
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
  final String service;
  final VoidCallback onEdit, onDelete;

  const _ServiceCard({
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: primary.withValues(alpha: 0.1),
          foregroundColor: primary,
          child: const Icon(Icons.medical_services_rounded),
        ),
        title: Text(
          service,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.medical_information_rounded,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            "No services added yet.",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/customer.dart';

/// Card displaying customer contact overview and profile link
class CustomerCard extends StatelessWidget {
  final CustomerEntity customer;
  final VoidCallback? onTap;
  final VoidCallback? onCall;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.p16,
        vertical: AppDimensions.p8,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.deepIndigo.withValues(alpha: 0.1),
          foregroundColor: AppColors.deepIndigo,
          child: Text(
            customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          customer.phone,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone_outlined, color: AppColors.deepIndigo),
          onPressed: onCall,
        ),
      ),
    );
  }
}

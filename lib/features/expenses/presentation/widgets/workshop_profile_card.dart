import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../orders/presentation/providers/order_list_provider.dart';

/// Workshop profile identity and workload metrics card.
class WorkshopProfileCard extends StatelessWidget {
  final OrderListProvider orderProvider;

  const WorkshopProfileCard({
    super.key,
    required this.orderProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.store_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DarziDairy Tailors',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Master Tailoring & Stitching Workshop',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFF1F5F9)),

            // Stats row
            Row(
              children: [
                _buildStatItem(
                  label: 'Total Orders',
                  value: '${orderProvider.allOrders.length}',
                  color: AppColors.primary,
                ),
                Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
                _buildStatItem(
                  label: 'Active Jobs',
                  value: '${orderProvider.activeOrders.length}',
                  color: AppColors.secondary,
                ),
                Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
                _buildStatItem(
                  label: 'Completed',
                  value: '${orderProvider.completedOrders.length}',
                  color: const Color(0xFF16A34A),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../orders/presentation/providers/order_list_provider.dart';

/// Artisanal Workshop Atelier Identity Banner.
/// Replaces generic card templates with a handcrafted Master Tailor Atelier aesthetic,
/// featuring custom embroidered seal, status indicator, and frosted KPI ribbon.
class WorkshopProfileCard extends StatelessWidget {
  final OrderListProvider orderProvider;

  const WorkshopProfileCard({
    super.key,
    required this.orderProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A), // Deep Slate Navy
            Color(0xFF1E293B), // Midnight Tailor Indigo
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: const Color(0xFF334155), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0F172A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Stack(
          children: [
            // Decorative background tailor watermark (faint shears)
            Positioned(
              right: -15,
              top: -15,
              child: Opacity(
                opacity: 0.04,
                child: Transform.rotate(
                  angle: -0.25,
                  child: const Icon(
                    Icons.content_cut_rounded,
                    size: 150,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Workshop Brand & Status Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Handcrafted Artisan Monogram Seal
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3DF59E0B),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFFFEF3C7),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.content_cut_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Workshop Title and Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'DarziDairy Tailors',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Live Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0x2610B981),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0x4010B981),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Color(0xFF34D399),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Active',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF34D399),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Master Tailoring & Khata • درزی ماسٹر',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Translucent Artisan KPI Ribbon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1AFFFFFF),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      border: Border.all(
                        color: const Color(0x1F64748B),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildHeroStat(
                          label: 'Total Orders',
                          value: '${orderProvider.allOrders.length}',
                          valueColor: const Color(0xFFFBBF24), // Warm Amber
                          icon: Icons.assignment_outlined,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: const Color(0x2694A3B8),
                        ),
                        _buildHeroStat(
                          label: 'Active Jobs',
                          value: '${orderProvider.activeOrders.length}',
                          valueColor: const Color(0xFF38BDF8), // Cyan Blue
                          icon: Icons.timelapse_rounded,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: const Color(0x2694A3B8),
                        ),
                        _buildHeroStat(
                          label: 'Completed',
                          value: '${orderProvider.completedOrders.length}',
                          valueColor: const Color(0xFF34D399), // Emerald
                          icon: Icons.check_circle_outline_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat({
    required String label,
    required String value,
    required Color valueColor,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: valueColor.withValues(alpha: 0.8)),
              const SizedBox(width: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }
}

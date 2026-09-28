import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../../../../shared/widgets/search_bar_widget.dart';
import '../providers/customer_list_provider.dart';
import 'customer_detail_screen.dart';

/// Customer Directory & Measurement Khata screen supporting search,
/// contact filtering, and unfolded master-detail view.
class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navCustomers),
      ),
      body: ResponsiveDualPane(
        masterWidth: 400.0,
        masterPane: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: SearchBarWidget(
                controller: _searchController,
                hintText: 'Search customer name or phone...',
                onChanged: (val) {
                  context.read<CustomerListProvider>().search(val);
                },
              ),
            ),
            Expanded(
              child: Consumer<CustomerListProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final customers = provider.filteredCustomers;
                  if (customers.isEmpty) {
                    return const Center(
                      child: Text(
                        'No customers found',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      final isSelected = context.isUnfolded && provider.selectedCustomer?.id == customer.id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppDimensions.space8),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDimensions.roundedMedium,
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            if (context.isUnfolded) {
                              provider.selectCustomer(customer);
                            } else {
                              context.push(AppRouter.customerDetailPath(customer.id));
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            foregroundColor: AppColors.primary,
                            child: Text(
                              customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            customer.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${customer.phone} • ${customer.measurementProfiles.length} profiles',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        detailPane: Consumer<CustomerListProvider>(
          builder: (context, provider, _) {
            final selected = provider.selectedCustomer;
            if (selected == null) {
              return const Center(
                child: Text(
                  'Select a customer to view their measurement book',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              );
            }
            return CustomerDetailScreen(customerId: selected.id);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.surface,
        onPressed: () => context.push(AppRouter.addCustomer),
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }
}

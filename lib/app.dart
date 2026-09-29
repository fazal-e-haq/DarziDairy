import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/orders/data/datasources/order_local_datasource.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/presentation/providers/order_list_provider.dart';
import 'features/orders/presentation/providers/order_form_provider.dart';

/// MaterialApp entry configuring theme, declarative GoRouter, and MultiProvider injection
class TailorMasterApp extends StatelessWidget {
  const TailorMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OrderListProvider>(
          create: (_) => OrderListProvider(
            repository: OrderRepositoryImpl(localDataSource: OrderLocalDataSource()),
          ),
        ),
        ChangeNotifierProvider<OrderFormProvider>(
          create: (_) => OrderFormProvider(
            repository: OrderRepositoryImpl(localDataSource: OrderLocalDataSource()),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

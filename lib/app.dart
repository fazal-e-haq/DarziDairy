import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/orders/data/datasources/order_local_datasource.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/presentation/providers/order_list_provider.dart';
import 'features/orders/presentation/providers/order_form_provider.dart';
import 'features/customers/data/datasources/customer_local_datasource.dart';
import 'features/customers/data/repositories/customer_repository_impl.dart';
import 'features/customers/presentation/providers/customer_list_provider.dart';
import 'features/customers/presentation/providers/customer_form_provider.dart';
import 'features/diary/data/datasources/diary_local_datasource.dart';
import 'features/diary/data/repositories/diary_repository_impl.dart';
import 'features/diary/presentation/providers/diary_provider.dart';

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
        ChangeNotifierProvider<CustomerListProvider>(
          create: (_) => CustomerListProvider(
            repository: CustomerRepositoryImpl(localDataSource: CustomerLocalDataSource()),
          ),
        ),
        ChangeNotifierProvider<CustomerFormProvider>(
          create: (_) => CustomerFormProvider(
            repository: CustomerRepositoryImpl(localDataSource: CustomerLocalDataSource()),
          ),
        ),
        ChangeNotifierProvider<DiaryProvider>(
          create: (_) => DiaryProvider(
            repository: DiaryRepositoryImpl(localDataSource: DiaryLocalDataSource()),
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

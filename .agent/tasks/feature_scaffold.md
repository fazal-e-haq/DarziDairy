# Feature Scaffold Task Template

When scaffolding a new feature module in `lib/features/<feature_name>/`, follow this standardized structure:

1. **Domain Layer:**
   - Define entity in `domain/entities/<feature_entity>.dart`
   - Define abstract repository in `domain/repositories/i_<feature_name>_repository.dart`
2. **Data Layer:**
   - Define Isar collection schema in `data/models/<feature_name>_collection.dart`
   - Define local datasource in `data/datasources/<feature_name>_local_datasource.dart`
   - Implement repository in `data/repositories/<feature_name>_repository_impl.dart`
3. **Presentation Layer:**
   - Create `presentation/providers/<feature_name>_provider.dart`
   - Build main screens in `presentation/screens/`
   - Extract modular widgets to `presentation/widgets/`

# Test Generation Instructions

## 1. Unit Tests (`test/unit/`)
- Target business logic, financial calculations (e.g. balance calculation: `total - advance`), date formatters, and repository mapping.
- Mock Isar data sources using mockito or mock contracts in `test/mocks/`.

## 2. Widget Tests (`test/widget/`)
- Test standalone components such as `StatusChip`, `CustomerCard`, `MeasurementGridInput`, and `ConfirmationDialog`.
- Verify key user interactions: numeric keypad tapping, button press states, form validation messages.

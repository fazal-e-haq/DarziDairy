/// App-wide static strings, measurement labels, garment types, and default categories
class AppStrings {
  AppStrings._();

  static const String appName = 'DarziDairy';
  static const String appTagline = 'Offline Khata & Workshop';

  // Common Navigation
  static const String navOrders = 'Orders';
  static const String navCustomers = 'Customers';
  static const String navDiary = 'Diary (Roznamcha)';
  static const String navBackup = 'Backup';

  // Garment Types
  static const List<String> defaultGarments = [
    'Silai Shalwar Kameez',
    'Silai Kurta Pajama',
    'Silai Pant / Shirt',
    'Silai Waistcoat',
    'Silai Two-Piece Suit',
    'Silai Sherwani',
  ];

  // Measurement Labels with Urdu translations in brackets
  static const List<String> standardMeasurementKeys = [
    'Length (لمبائی)',
    'Chest (چھاتی)',
    'Waist (کمر)',
    'Hip (ہپ)',
    'Shoulder (تیرا)',
    'Sleeve (بازو)',
    'Collar (کالر / گلا)',
    'Inseam (شلوار لمبائی)',
    'Daman (دامن)',
    'Pancha (پانچہ)',
  ];

  // Expense Categories
  static const List<String> defaultExpenseCategories = [
    'Threads (Dhaga)',
    'Buttons',
    'Bukram / Interlining',
    'Machine Oil / Needles',
    'Electricity / Utility',
    'Shop Rent',
    'Tea & Refreshments',
    'Staff Wages',
    'Other',
  ];
}

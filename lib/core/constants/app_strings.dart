/// App-wide static strings, measurement labels, garment types, and default categories
class AppStrings {
  AppStrings._();

  static const String appName = 'DarziDairy';

  // Garment Types (English on left, Urdu on right without brackets)
  static const List<Map<String, String>> garmentTypes = [
    {'en': 'Shalwar Kameez', 'ur': 'شلوار قمیض'},
    {'en': 'Kurta Pajama', 'ur': 'کرتہ پاجامہ'},
    {'en': 'Pant Shirt', 'ur': 'پینٹ شرٹ'},
    {'en': 'Waistcoat', 'ur': 'واسکٹ'},
    {'en': 'Two-Piece Suit', 'ur': 'ٹو پیس سوٹ'},
    {'en': 'Three-Piece Suit', 'ur': 'تھری پیس سوٹ'},
    {'en': 'Sherwani', 'ur': 'شیروانی'},
    {'en': 'Prince Coat', 'ur': 'پرنس کوٹ'},
    {'en': 'Safari Suit', 'ur': 'سفاری سوٹ'},
    {'en': 'Only Kameez / Kurta', 'ur': 'صرف قمیض کرتہ'},
    {'en': 'Only Shalwar / Trouser', 'ur': 'صرف شلوار ٹراؤزر'},
  ];

  static List<String> get defaultGarments =>
      garmentTypes.map((g) => g['en']!).toList();

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

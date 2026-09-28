import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/diary_provider.dart';

/// Fast expense logger sheet for threads, rent, bukram, machine oil, etc.
class AddExpenseBottomSheet extends StatefulWidget {
  const AddExpenseBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddExpenseBottomSheet(),
    );
  }

  @override
  State<AddExpenseBottomSheet> createState() => _AddExpenseBottomSheetState();
}

class _AddExpenseBottomSheetState extends State<AddExpenseBottomSheet> {
  String _selectedCategory = AppStrings.defaultExpenseCategories.first;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitExpense() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;
    final amount = double.tryParse(amountText) ?? 0.0;
    if (amount <= 0) return;

    await context.read<DiaryProvider>().addExpense(
          category: _selectedCategory,
          amount: amount,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Log Shop Expense (Roznamcha)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            items: AppStrings.defaultExpenseCategories.map((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
            decoration: const InputDecoration(labelText: 'Expense Category'),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Amount (Rs.) *',
            controller: _amountController,
            isNumericOnly: true,
            hint: 'e.g. 250',
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Note (Optional)',
            controller: _noteController,
            hint: 'e.g. Golden thread spools for Eid order',
          ),
          const SizedBox(height: 20),
          CustomButton(
            label: 'Save Expense to Roznamcha',
            onPressed: _submitExpense,
          ),
        ],
      ),
    );
  }
}

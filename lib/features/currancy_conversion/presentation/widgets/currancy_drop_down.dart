 import 'package:expense_tracker/features/currancy_conversion/presentation/widgets/plain_dropdown_field.dart';
import 'package:expense_tracker/features/currancy_conversion/presentation/widgets/searchable_dropdown_field.dart';
import 'package:flutter/material.dart';


class CurrencyDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool searchable;

  const CurrencyDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.searchable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchable
        ? SearchableDropdownField(
      label: label,
      value: value,
      items: items,
      onChanged: onChanged,
    )
        : PlainDropdownField(
      label: label,
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}

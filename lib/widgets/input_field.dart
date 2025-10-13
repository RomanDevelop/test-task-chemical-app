import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String? errorText;
  final double value;
  final ValueChanged<double> onChanged;
  final String? suffix;
  final TextInputType keyboardType;
  final double? min;
  final double? max;

  const InputField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.suffix,
    this.keyboardType = TextInputType.number,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value == 0 ? '' : value.toString(),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            errorText: errorText,
            errorStyle: TextStyle(color: Colors.red.shade700),
            suffixText: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.shade700)),
          ),
          onChanged: (value) {
            final doubleValue = double.tryParse(value) ?? 0.0;
            onChanged(doubleValue);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Поле не может быть пустым';
            }
            final doubleValue = double.tryParse(value);
            if (doubleValue == null) {
              return 'Введите корректное число';
            }
            if (min != null && doubleValue < min!) {
              return 'Значение должно быть не менее $min';
            }
            if (max != null && doubleValue > max!) {
              return 'Значение должно быть не более $max';
            }
            return null;
          },
        ),
      ],
    );
  }
}

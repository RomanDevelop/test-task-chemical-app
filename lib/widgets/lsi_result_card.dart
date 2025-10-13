import 'package:flutter/material.dart';
import '../models/lsi_result.dart';
import '../models/colors_response.dart';

class LSIResultCard extends StatelessWidget {
  final LSIResult result;
  final ColorsResponse? colors;

  const LSIResultCard({super.key, required this.result, this.colors});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Результаты LSI',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildLSIValue(context, 'Текущий LSI', result.current, colors?.lsiCurrentColor)),
                const SizedBox(width: 16),
                Expanded(child: _buildLSIValue(context, 'Желаемый LSI', result.desired, colors?.lsiDesiredColor)),
              ],
            ),
            if (result.phCeilingCurrent != null || result.phCeilingDesired != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text('pH Ceiling', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (result.phCeilingCurrent != null)
                    Expanded(
                      child: _buildLSIValue(
                        context,
                        'Текущий pH Ceiling',
                        result.phCeilingCurrent!,
                        colors?.phCeilingCurrentColor,
                      ),
                    ),
                  if (result.phCeilingCurrent != null && result.phCeilingDesired != null) const SizedBox(width: 16),
                  if (result.phCeilingDesired != null)
                    Expanded(
                      child: _buildLSIValue(
                        context,
                        'Желаемый pH Ceiling',
                        result.phCeilingDesired!,
                        colors?.phCeilingDesiredColor,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLSIValue(BuildContext context, String label, double value, String? colorHex) {
    Color? backgroundColor;
    if (colorHex != null) {
      try {
        backgroundColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } catch (e) {
        // If color parsing fails, use default
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor?.withValues(alpha: 0.1),
        border: Border.all(color: backgroundColor ?? Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value.toStringAsFixed(2),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: backgroundColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

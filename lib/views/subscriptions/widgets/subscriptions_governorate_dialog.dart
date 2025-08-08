import 'package:flutter/material.dart';
import 'package:gym_zones/models/governorate.dart';
import 'governorate_province_dialog.dart';

class SubscriptionsGovernorateDialog extends StatelessWidget {
  final List<Governorate>? governorates;
  final String? selectedGovernorate;
  final List<int> selectedProvinces;
  final Function(String? governorate, List<int> provinces) onApply;

  const SubscriptionsGovernorateDialog({
    super.key,
    required this.governorates,
    required this.selectedGovernorate,
    required this.selectedProvinces,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    // Reuse the existing GovernorateProvinceDialog for now
    // This can be customized later if needed for subscriptions-specific functionality
    return GovernorateProvinceDialog(
      governorates: governorates,
      selectedGovernorate: selectedGovernorate,
      selectedProvinces: selectedProvinces,
      onApply: onApply,
    );
  }
}

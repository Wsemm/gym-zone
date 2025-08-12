import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/models/governorate.dart';
import 'package:gym_zones/models/province.dart';

class GovernorateProvinceDialog extends StatefulWidget {
  final List<Governorate>? governorates;
  final String? selectedGovernorate;
  final List<int> selectedProvinces;
  final Function(String? governorate, List<int> provinces) onApply;

  const GovernorateProvinceDialog({
    super.key,
    required this.governorates,
    required this.selectedGovernorate,
    required this.selectedProvinces,
    required this.onApply,
  });

  @override
  State<GovernorateProvinceDialog> createState() =>
      _GovernorateProvinceDialogState();
}

class _GovernorateProvinceDialogState extends State<GovernorateProvinceDialog> {
  String? _selectedGovernorate;
  List<int> _selectedProvinces = [];
  List<Province> _availableProvinces = [];

  @override
  void initState() {
    super.initState();
    _selectedGovernorate = widget.selectedGovernorate;
    _selectedProvinces = List.from(widget.selectedProvinces);
    _updateAvailableProvinces();
  }

  void _updateAvailableProvinces() {
    if (_selectedGovernorate != null && widget.governorates != null) {
      // If "All" is selected, show all provinces from all governorates
      if (_selectedGovernorate == 'All') {
        _availableProvinces = [];
        for (final governorate in widget.governorates!) {
          if (governorate.id != -1) {
            // Skip the "All" option itself
            _availableProvinces.addAll(governorate.provinces ?? []);
          }
        }
      } else {
        final governorate = widget.governorates!.firstWhere(
          (g) => g.name == _selectedGovernorate,
          orElse: () =>
              Governorate(id: -1, name: '', nameAr: '', provinces: []),
        );
        _availableProvinces = governorate.provinces ?? [];
      }
    } else {
      _availableProvinces = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 0.9.sw,
          height: 0.9.sh,
          margin: EdgeInsets.symmetric(
              // horizontal: 0.1.sw,
              // vertical: 0.1.sh,
              ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Main content
                Expanded(
                  child: Row(
                    children: [
                      // Left side - Provinces
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.r),
                                    topRight: Radius.circular(8.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.map,
                                      size: 16.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Governorates'.tr,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: widget.governorates == null
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : ListView.builder(
                                        itemCount: widget.governorates!.length,
                                        itemBuilder: (context, index) {
                                          final governorate =
                                              widget.governorates![index];
                                          final isSelected =
                                              _selectedGovernorate ==
                                                  governorate.name;

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 4.h,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  // If "All" is selected (id: -1), set governorate to null to clear filter
                                                  _selectedGovernorate =
                                                      governorate.id == -1
                                                          ? null
                                                          : governorate.name;
                                                  _selectedProvinces.clear();
                                                  _updateAvailableProvinces();
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 8.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? AppColors.primary
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? AppColors.primary
                                                        : Colors.grey.shade300,
                                                  ),
                                                ),
                                                child: Text(
                                                  GetStorage().read('lang') ==
                                                          'en'
                                                      ? governorate.name
                                                      : governorate.nameAr,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),

                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.r),
                                    topRight: Radius.circular(8.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_city,
                                      size: 16.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Provinces'.tr,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: _selectedGovernorate == null
                                    ? Center(
                                        child: Text(
                                          'Select a governorate'.tr,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : _selectedGovernorate == 'All'
                                        ? Center(
                                            child: Text(
                                              'All provinces from all governorates are available'
                                                  .tr,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        : _availableProvinces.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'No provinces available'.tr,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount:
                                                    _availableProvinces.length,
                                                itemBuilder: (context, index) {
                                                  final province =
                                                      _availableProvinces[
                                                          index];
                                                  final isSelected =
                                                      _selectedProvinces
                                                          .contains(
                                                              province.id);

                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      // horizontal: 12.w,
                                                      vertical: 4.h,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                          value: isSelected,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              if (value ==
                                                                  true) {
                                                                _selectedProvinces
                                                                    .add(province
                                                                        .id);
                                                              } else {
                                                                _selectedProvinces
                                                                    .remove(
                                                                        province
                                                                            .id);
                                                              }
                                                            });
                                                          },
                                                          activeColor:
                                                              AppColors.primary,
                                                        ),
                                                        // SizedBox(width: 8.w),
                                                        Expanded(
                                                          child: Text(
                                                            GetStorage().read(
                                                                        'lang') ==
                                                                    'en'
                                                                ? province.name
                                                                : province
                                                                    .nameAr,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    14.sp),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Bottom buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onApply(
                              _selectedGovernorate, _selectedProvinces);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Apply'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

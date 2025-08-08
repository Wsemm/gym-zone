import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/styles/app_colors.dart';

Widget labelCardWidget(
    {required String count,
    required String title,
    required Color mainColor,
    required Color subColor}) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: 7.h,
    ),
    margin: const EdgeInsets.only(left: 6),
    child: Row(
      spacing: 10.w,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // margin: const EdgeInsets.only(top: 4),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: mainColor,
            border: Border.all(width: 3, color: subColor),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          count,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

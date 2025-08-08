import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../styles/app_colors.dart';

class RebiButton extends StatefulWidget {
  const RebiButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor = AppColors.secondary,
    this.foregroundColor = Colors.black,
    this.width,
    this.height = 43,
    this.elevation = 0,
    this.shadowColor = Colors.black12,
    this.radius = 8.0,
    this.disabled = false,
    this.border = const BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
    this.svgIcon,
    this.isRtl = false,
  });

  const RebiButton.icon({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor = AppColors.secondary,
    this.foregroundColor = Colors.black,
    this.width,
    this.height = 43,
    this.elevation = 0,
    this.shadowColor = Colors.grey,
    this.radius = 8.0,
    this.disabled = false,
    this.isRtl = false,
    required this.svgIcon,
    this.border = const BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
  });

  final bool isRtl;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? width;
  final double height;
  final double? elevation;
  final Color shadowColor;
  final double radius;
  final String? svgIcon;
  final BorderSide border;
  final bool disabled;

  @override
  State<RebiButton> createState() => _RebiButtonState();
}

class _RebiButtonState extends State<RebiButton> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isLoading,
      child: ElevatedButton(
        onPressed: widget.disabled
            ? null
            : () {
                if (widget.isLoading) {
                  return;
                }
                widget.onPressed!();
              },
        style: ElevatedButton.styleFrom(
          foregroundColor: widget.foregroundColor,
          backgroundColor: widget.backgroundColor,
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          shadowColor: widget.shadowColor,
          elevation: widget.elevation,
          minimumSize:
              widget.width != null ? Size(widget.width!, widget.height) : null,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.radius),
              ),
              side: widget.border),
        ),
        child: Container(
          height: widget.height,
          width: widget.width,
          alignment: Alignment.center,
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: widget.backgroundColor == Colors.white
                          ? AppColors.primary
                          : Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                )
              : widget.svgIcon == null
                  ? widget.child
                  : Row(
                      textDirection:
                          widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          widget.svgIcon!,
                          color: widget.foregroundColor,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        widget.child,
                      ],
                    ),
        ),
      ),
    );
  }
}

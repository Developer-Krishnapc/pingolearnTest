import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/extension/context.dart';
import '../../../core/extension/datetime.dart';
import '../../../core/extension/widget.dart';
import '../../theme/config/app_color.dart';
import 'app_text_theme.dart';
import 'change_date_time.dart';
import 'validation.dart';

class CustomFormField extends ConsumerStatefulWidget with FormValidationMixin {
  const CustomFormField({
    super.key,
    this.inputFormatters,
    this.validator,
    this.hintStyle,
    this.controller,
    this.keyboardType,
    this.prefixText,
    this.decoration,
    this.prefixIcon,
    this.suffixText,
    this.hintText,
    this.onChanged,
    this.labelText,
    this.enabled = true,
    this.readOnly,
    this.suffixIcon,
    this.minLines,
    this.onTap,
    this.obscureText,
    this.focusColor,
    this.enabledColor,
    this.maxLines,
    this.onCompleted,
    this.startDateFilter,
    this.endDateFilter,
    this.maxLength,
    this.passwordVisible,
    this.onPressed,
    this.textCapitalization,
    this.label,
    this.fillColor,
  });

  factory CustomFormField.date({
    required BuildContext context,
    TextEditingController? controller,
    TextEditingController? startDateFilter,
    TextEditingController? endDateFilter,
    String? hintText,
    TextStyle? hintStyle,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return CustomFormField(
      validator: validator,
      controller: controller,
      hintText: hintText,
      suffixIcon: suffixIcon,
      hintStyle: hintStyle,
      readOnly: true,
      onChanged: onChanged,
      onTap: () async {
        final now = DateTime.now();
        final result = await showDatePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: AppTextTheme.base, // Input label
                ),
                textTheme: TextTheme(
                  bodySmall: GoogleFonts.openSans(),
                ),
                colorScheme: const ColorScheme.light(
                  primary: AppColor.grey, // header background color
                  surface: AppColor.primary, // header background color
                  onPrimary: Colors.green, // header text color
                  onSurface: AppColor.white,

                  // body text color
                ),
                dialogBackgroundColor: AppColor.primary,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
          context: context,
          initialDate: now,
          firstDate: firstDate ?? now,
          lastDate: lastDate ?? DateTime(now.year + 5),
        );
        if (result != null) {
          controller?.text = changeToSimpleDMY(result.toString());
          startDateFilter?.text = DateFormat('dd/MM/yyyy')
              .parse(changeToSimpleDMY(result.toString()))
              .toBackendDateFormat();
          endDateFilter?.text = DateFormat('dd/MM/yyyy')
              .parse(
                changeToSimpleDMY(
                  result.add(const Duration(days: 1)).toString(),
                ),
              )
              .toBackendDateFormat();
        }
      },
    );
  }
  factory CustomFormField.dateFilter({
    required BuildContext context,
    TextEditingController? controller,
    TextEditingController? startDateFilter,
    TextEditingController? endDateFilter,
    String? hintText,
    TextStyle? hintStyle,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    DateTime? firstDate,
  }) {
    return CustomFormField(
      validator: validator,
      controller: controller,
      hintText: hintText,
      suffixIcon: suffixIcon,
      hintStyle: hintStyle,
      readOnly: true,
      onChanged: onChanged,
      keyboardType: TextInputType.none,
      onTap: () async {
        final now = DateTime.now();
        final result = await showDateRangePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: AppTextTheme.base, // Input label
                ),
                textTheme: TextTheme(
                  bodySmall: GoogleFonts.openSans(),
                ),
                colorScheme: const ColorScheme.light(
                  primary: AppColor.grey, // header background color
                  surface: AppColor.primary, // header background color
                  onPrimary: Colors.green, // header text color
                  onSurface: AppColor.white,

                  // body text color
                ),
                dialogBackgroundColor: AppColor.primary,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    // button text color
                  ),
                ),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: context.heightByPercent(72),
                    child: child,
                  ),
                ),
              ).padHor(),
            );
          },
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          context: context,
          firstDate: firstDate ?? now,
          currentDate: now,
          lastDate: DateTime(now.year + 5),
          keyboardType: TextInputType.none,
        );

        if (result != null) {
          controller?.text = changeToSimpleDMY(result.start.toString());
          startDateFilter?.text = changeToSimpleDMY(result.start.toString());
          endDateFilter?.text = changeToSimpleDMY(result.end.toString());
        }
      },
    );
  }

  factory CustomFormField.name({
    TextEditingController? controller,
    Widget? prefixIcon,
    String? hintText,
    String? prefixText,
    Widget? suffixWidget,
    int? maxLine,
    int? minLines,
    int? maxLength,
    bool? readOnly,
    Color? fillColor,
    bool? isUserName,
    bool? isOptional,
  }) =>
      CustomFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            (isUserName == true)
                ? RegExp("[0-9A-Za-z,.' -]{0,}")
                : RegExp("[0-9A-Za-z,-.' -#@%]{0,}"),
          ),
        ],
        validator: (value) {
          if (isOptional == true) {
            return null;
          }
          if (value == null || value.trim().isEmpty == true) {
            return '${hintText ?? 'Name'} is required';
          }
          return null;
        },
        hintText: hintText ?? 'Enter ${hintText ?? 'Name'}',
        controller: controller,
        keyboardType: TextInputType.name,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        suffixIcon: suffixWidget,
        maxLines: maxLine,
        minLines: minLines,
        readOnly: readOnly,
        maxLength: maxLength,
        fillColor: fillColor,
      );

  factory CustomFormField.number({
    TextEditingController? controller,
    Widget? prefixIcon,
    String? hintText,
    String? prefixText,
    Widget? suffixWidget,
    int? maxLine,
    int? minLines,
    int? maxLength,
    bool? isOptional,
  }) =>
      CustomFormField(
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) {
          if (isOptional == true &&
              (value == null || value.trim().isEmpty == true)) {
            return null;
          }
          if (value == null || value.trim().isEmpty == true) {
            return '${hintText ?? 'Number'} is required';
          }
          if (value.startsWith('0')) {
            return '$hintText starting from 0 is not allowed';
          }

          return null;
        },
        hintText: hintText ?? 'Enter ${hintText ?? 'Number'}',
        controller: controller,
        keyboardType: TextInputType.number,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        suffixIcon: suffixWidget,
        maxLines: maxLine,
        minLines: minLines,
        maxLength: maxLength,
      );

  factory CustomFormField.webLink({
    TextEditingController? controller,
    Widget? prefixIcon,
    String? hintText,
  }) =>
      CustomFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          }
          if (!value.contains('.')) {
            return 'Invalid url';
          }
          return null;
        },
        hintText: hintText ?? 'Enter full name',
        controller: controller,
        keyboardType: TextInputType.name,
        prefixIcon: prefixIcon,
      );

  factory CustomFormField.password({
    TextEditingController? controller,
    Widget? prefixIcon,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    String? hintText,
    Function()? onPressed,
    bool? passwordVisible,
  }) =>
      CustomFormField(
        obscureText: passwordVisible,
        hintText: hintText ?? 'password',
        controller: controller,
        keyboardType: TextInputType.text,
        prefixIcon: prefixIcon,
        onChanged: onChanged,
        validator: validator,
        maxLength: 25,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp('^[ ]'),
          ),
        ],
        suffixIcon: IconButton(
          icon: passwordVisible == true
              ? const Icon(
                  Icons.visibility_off,
                  size: 20,
                  color: AppColor.primary,
                )
              : const Icon(
                  Icons.visibility,
                  size: 20,
                  color: AppColor.primary,
                ),
          onPressed: onPressed,
        ),
      );

  factory CustomFormField.address({
    TextEditingController? controller,
    Widget? prefixIcon,
  }) =>
      CustomFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp('^[A-Za-z0-9,.][A-Za-z0-9,. ]{0,}'),
          ),
        ],
        validator: (value) {
          if (value?.trim().isEmpty == true) {
            return 'Address is required';
          }
          return null;
        },
        hintText: 'Enter Address',
        controller: controller,
        keyboardType: TextInputType.text,
        prefixIcon: prefixIcon,
      );

  factory CustomFormField.age({TextEditingController? controller}) =>
      CustomFormField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value?.trim().isEmpty == true || value == null) {
            return 'Age is required';
          }
          if (!(int.parse(value) >= 1 && int.parse(value) <= 120)) {
            return 'Invalid Age';
          }
          return null;
        },
        controller: controller,
        keyboardType: TextInputType.number,
      );

  factory CustomFormField.phone({
    TextEditingController? controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Function(String)? onChanged,
    bool? readOnly,
    Color? fillColor,
  }) =>
      CustomFormField(
        onChanged: onChanged,
        readOnly: readOnly,
        controller: controller,
        maxLength: 10,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        hintText: 'Mobile No',
        fillColor: fillColor,
        validator: (String? phone) {
          if (phone == null || phone.isEmpty == true) {
            return 'Mobile number is required';
          }
          if (phone.startsWith('0')) {
            return 'Mobile number should not start with zero';
          }

          if (phone.length != 10) {
            return 'Phone number should be of 10 digits';
          }

          return null;
        },
      );

  factory CustomFormField.other({
    TextEditingController? controller,
    String? label,
  }) =>
      CustomFormField(
        controller: controller,
        hintText: 'Enter $label',
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9., ]')),
        ],
        validator: (String? data) {
          if (data == null || data.trim().isEmpty == true) {
            return '$label is required';
          }

          return null;
        },
      );

  factory CustomFormField.countryCode({
    TextEditingController? controller,
    String? prefixText,
  }) =>
      CustomFormField(
        decoration: InputDecoration(
          prefixText: prefixText,
        ),
        controller: controller,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[+][0-9]{0,}')),
        ],
        validator: (String? data) {
          if (data == null || data.isEmpty == true) {
            return 'Please enter country code';
          }

          if (data.length != 2) {
            return 'Country Code be should be of 2 digits';
          }

          return null;
        },
      );

  factory CustomFormField.email({
    TextEditingController? controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? readOnly,
    String? hintText,
    Color? fillColor,
  }) =>
      CustomFormField(
        controller: controller,
        prefixIcon: prefixIcon,
        readOnly: readOnly,
        suffixIcon: suffixIcon,
        keyboardType: TextInputType.text,
        inputFormatters: const [],
        fillColor: fillColor,
        hintText: hintText ?? 'email address',
        // hintText: 'EMAIL*',
        validator: (String? email) {
          if (email == null || email.trim().isEmpty) {
            return 'Please enter E-Mail';
          }
          final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!regex.hasMatch(email)) {
            return 'Enter valid E-Mail';
          }

          return null;
        },
      );

  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final String? prefixText;
  final Color? fillColor;
  final Widget? prefixIcon;
  final String? hintText;
  final String? suffixText;
  final String? label;
  final String? startDateFilter;
  final String? endDateFilter;
  final TextStyle? hintStyle;
  final Function(String)? onChanged;
  final String? labelText;
  final bool enabled;
  final bool? readOnly;
  final bool? obscureText;
  final bool? passwordVisible;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Color? focusColor;
  final Color? enabledColor;
  final int? maxLines;
  final int? minLines;
  final VoidCallback? onCompleted;
  final int? maxLength;
  final Function()? onPressed;
  final TextCapitalization? textCapitalization;

  @override
  ConsumerState<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends ConsumerState<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      cursorColor: AppColor.primary,
      obscuringCharacter: '*',
      onTap: widget.onTap,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      obscureText: widget.obscureText ?? false,
      onChanged: widget.onChanged,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      onEditingComplete: widget.onCompleted,
      readOnly: widget.readOnly ?? false,
      minLines: widget.minLines,
      style: widget.hintStyle ?? AppTextTheme.base,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.enabledColor ?? AppColor.lightGrey,
          ),
        ),
        fillColor: widget.fillColor ?? AppColor.white,
        focusColor: AppColor.white,
        prefixText: widget.prefixText,
        suffixStyle: AppTextTheme.label14.copyWith(color: AppColor.primary),
        suffixIcon: widget.suffixIcon,
        suffixText: widget.suffixText,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusColor ?? AppColor.lightGrey,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusColor ?? AppColor.lightGrey,
          ),
        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorStyle: AppTextTheme.label12.copyWith(color: AppColor.red),
        labelStyle: widget.hintStyle ??
            AppTextTheme.label14.copyWith(
              color: AppColor.black,
            ),
        hintStyle: widget.hintStyle ??
            AppTextTheme.label14.copyWith(
              color: AppColor.bluishGrey,
            ),
        enabled: widget.enabled,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 40,
        ),
        contentPadding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        counterText: '',
      ),
    );
  }
}

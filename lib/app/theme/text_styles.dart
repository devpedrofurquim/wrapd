import 'package:flutter/material.dart';

extension CustomTextStyles on TextTheme {
  TextStyle get normal => bodyMedium!;
  TextStyle get normalBold => bodyMedium!.copyWith(fontWeight: FontWeight.bold);

  TextStyle get large => titleLarge!;
  TextStyle get largeBold => titleLarge!.copyWith(fontWeight: FontWeight.bold);

  TextStyle get small => bodySmall!;
  TextStyle get smallGrey => bodySmall!.copyWith(color: Colors.grey);
}

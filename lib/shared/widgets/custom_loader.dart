import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

Widget customLoader(){
  return  Center(child: CircularProgressIndicator(
    color: AppColors.primary,
  ),);
}
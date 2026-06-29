// import 'package:flutter/material.dart';
// import 'package:meal_meat_user/config/theme/colors.dart';
// import 'package:meal_meat_user/config/theme/font_manager.dart';
// import 'package:meal_meat_user/config/theme/styles_manager.dart';

// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.height = 40,
//     this.borderRadius = 12,
//     this.backgroundColor = AppColors.primaryDark,
//     this.textColor = AppColors.white,
//     this.isExpanded = true,
//     this.isLoading = false,
//   });

//   final String text;
//   final VoidCallback? onPressed;
//   final double height;
//   final double borderRadius;
//   final Color backgroundColor;
//   final Color textColor;
//   final bool isExpanded;
//   final bool isLoading;

//   @override
//   Widget build(BuildContext context) {
//     final buttonChild = isLoading
//         ? SizedBox(
//             width: 18,
//             height: 18,
//             child: CircularProgressIndicator(
//               strokeWidth: 2.2,
//               valueColor: AlwaysStoppedAnimation<Color>(textColor),
//             ),
//           )
//         : Text(
//             text,
//             textAlign: TextAlign.center,
//             style: getBoldStyle(
//               fontFamily: FontConstant.ibmPlexSansArabic,
//               fontSize: FontSize.size15,
//               color: textColor,
//             ),
//           );

//     return SizedBox(
//       width: isExpanded ? double.infinity : null,
//       height: height,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: textColor,
//           elevation: 0,
//           shadowColor: Colors.transparent,
//           padding: EdgeInsets.zero,
//           minimumSize: Size(isExpanded ? double.infinity : 0, height),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(borderRadius),
//           ),
//         ),
//         child: buttonChild,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:meal_meat_user/config/theme/colors.dart';
// import 'package:meal_meat_user/config/theme/font_manager.dart';
// import 'package:meal_meat_user/config/theme/spacing.dart';
// import 'package:meal_meat_user/config/theme/styles_manager.dart';

// class OffersTopSection extends StatelessWidget {
//   const OffersTopSection({
//     super.key,
//     required this.title,
//     this.onNotificationTap,
//     this.onActionTap,
//   });

//   final String title;
//   final VoidCallback? onNotificationTap;
//   final VoidCallback? onActionTap;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         Spacing.base,
//         Spacing.sm,
//         Spacing.base,
//         0,
//       ),
//       child: Row(
//         children: [
//           _TopActionButton(
//             icon: Icons.notifications_none_rounded,
//             onTap: onNotificationTap,
//           ),
//           const Spacer(),
//           Text(
//             title,
//             style: getBoldStyle(
//               fontFamily: FontConstant.ibmPlexSansArabic,
//               fontSize: FontSize.size22,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const Spacer(),
//           _TopActionButton(
//             icon: Icons.tune_rounded,
//             onTap: onActionTap,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TopActionButton extends StatelessWidget {
//   const _TopActionButton({
//     required this.icon,
//     this.onTap,
//   });

//   final IconData icon;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkResponse(
//         onTap: onTap,
//         radius: 24,
//         splashColor: AppColors.primary.withValues(alpha: 0.08),
//         child: Container(
//           width: 44,
//           height: 44,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.shadow.withValues(alpha: 0.08),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Icon(icon, color: AppColors.textPrimary, size: 22),
//         ),
//       ),
//     );
//   }
// }

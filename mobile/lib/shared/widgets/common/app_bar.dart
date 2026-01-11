import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.title,
    this.appBarHeight = kToolbarHeight,
    this.leading,
    this.actions,
    this.showBack = true,
    this.elevation = 0,
    this.themeMode,
    this.backgroundColor,
    this.isCenter = true,
    this.leadingWidth,
    this.titleSpacing,
    this.onBack,
    this.titleWidget,
    this.bottom,
  });
  final double appBarHeight;
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;
  final bool isCenter;
  final double elevation;
  final ThemeMode? themeMode;
  final Color? backgroundColor;
  final double? leadingWidth;
  final double? titleSpacing;
  final Function()? onBack;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final isDarkBackground = backgroundColor == ColorConstants.primaryGreen;
    return AppBar(
      toolbarHeight: appBarHeight,
      leadingWidth: leadingWidth,
      title: titleWidget ??
          Text(
            title ?? '',
            style: isDarkBackground ? const TextStyle(color: Colors.white) : null,
          ),
      leading: _getLeading(context),
      actions: actions,
      titleSpacing: titleSpacing,
      centerTitle: isCenter,
      backgroundColor: backgroundColor,
      iconTheme: isDarkBackground ? const IconThemeData(color: Colors.white) : null,
      titleTextStyle: isDarkBackground ? const TextStyle(color: Colors.white) : null,
      elevation: elevation,
      bottom: bottom,
    );
  }

  Widget? _getLeading(context) {
    if (leading != null) return leading;
    final showLeading = showBack == true && Navigator.canPop(context);

    if (!showLeading) return const SizedBox();

    return leading ??
        GestureDetector(
          onTap: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.pop(context);
              FocusScope.of(Get.context!).unfocus();
            }
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.only(left: 12),
              // child: ImageWidget(
              //   ImageConstant.iconArrowBack,
              //   width: 24,
              //   height: 24,
              //   color: color,
              //   fit: BoxFit.contain,
              // ),
              child: Icon(
                Icons.arrow_back_ios,
              ),
            ),
          ),
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

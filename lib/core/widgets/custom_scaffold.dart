import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/widgets/custom_app_bar.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset,
    this.padding,
    this.usePadding = true,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.safeArea = true,
    this.scaffoldBackgroundColor,
    this.systemOverlayStyle,
    // AppBar
    this.showAppBar = false,
    this.title,
    this.titleWidget,
    this.showLeading = false,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.appBarBackgroundColor,
    this.appBarShape,
    this.titleStyle,
    this.leadingWidth,
    this.onPop,
    this.backButtonColor,
    this.appBarBottom,
    this.appBarElevation = 0,
  });

  // —— Body ————————————————————————————————————————
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? resizeToAvoidBottomInset;
  final EdgeInsets? padding;
  final bool usePadding;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final bool safeArea;
  final Color? scaffoldBackgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  // —— AppBar ——————————————————————————————————————
  final bool showAppBar;
  final String? title;
  final Widget? titleWidget;
  final bool showLeading;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? appBarBackgroundColor;
  final ShapeBorder? appBarShape;
  final TextStyle? titleStyle;
  final double? leadingWidth;
  final VoidCallback? onPop;
  final Color? backButtonColor;
  final PreferredSizeWidget? appBarBottom;
  final double appBarElevation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: scaffoldBackgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      appBar: showAppBar
          ? CustomAppBar(
              title: title,
              titleWidget: titleWidget,
              showLeading: showLeading,
              leading: leading,
              actions: actions,
              centerTitle: centerTitle,
              backgroundColor: appBarBackgroundColor,
              shape: appBarShape,
              titleStyle: titleStyle,
              leadingWidth: leadingWidth,
              onPop: onPop,
              backButtonColor: backButtonColor,
              systemOverlayStyle: systemOverlayStyle,
              bottom: appBarBottom,
              elevation: appBarElevation,
            )
          : null,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget content = usePadding
        ? Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: AppSizes.pagePadding,
                  vertical: AppSizes.sm,
                ),
            child: body,
          )
        : (body ?? const SizedBox.shrink());

    if (safeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}

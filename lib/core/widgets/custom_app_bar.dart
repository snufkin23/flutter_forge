import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showLeading = false,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.shape,
    this.titleStyle,
    this.leadingWidth,
    this.onPop,
    this.backButtonColor,
    this.systemOverlayStyle,
    this.bottom,
    this.elevation = 0,
  }) : assert(
          title == null || titleWidget == null,
          'Cannot provide both title and titleWidget',
        );

  /// Text title — ignored if [titleWidget] is provided
  final String? title;

  /// Custom widget title — overrides [title]
  final Widget? titleWidget;

  final bool showLeading;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final TextStyle? titleStyle;
  final double? leadingWidth;
  final VoidCallback? onPop;
  final Color? backButtonColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final PreferredSizeWidget? bottom;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool canPop = context.router.canPop();

    return AppBar(
      elevation: elevation,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      centerTitle: centerTitle,
      systemOverlayStyle: systemOverlayStyle ??
          (theme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark),
      leading: _buildLeading(context, canPop),
      leadingWidth: leadingWidth ?? (showLeading ? 64 : 0),
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: showLeading ? 0 : AppSizes.pagePadding,
        ),
        child: _buildTitle(context),
      ),
      actions: actions != null
          ? <Widget>[
              ...actions!,
              SizedBox(width: AppSizes.sm),
            ]
          : null,
      shape: shape,
      bottom: bottom,
    );
  }

  Widget? _buildLeading(BuildContext context, bool canPop) {
    // Custom leading takes priority
    if (leading != null) {
      return leading;
    }

    // Show back button only if showLeading is true and can actually pop
    if (showLeading && canPop) {
      return Padding(
        padding: EdgeInsets.only(left: AppSizes.md),
        child: CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 18,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: backButtonColor ?? Colors.white,
              size: AppSizes.iconSm,
            ),
            onPressed: () {
              onPop?.call();
              FocusScope.of(context).unfocus();
              context.router.maybePop();
            },
          ),
        ),
      );
    }

    return null;
  }

  Widget _buildTitle(BuildContext context) {
    // Custom widget title
    if (titleWidget != null) {
      return titleWidget!;
    }

    // Text title
    if (title != null && title!.isNotEmpty) {
      return Text(
        title!,
        style: titleStyle ??
            AppTextStyles.titleLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Size get preferredSize => Size.fromHeight(
        AppSizes.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

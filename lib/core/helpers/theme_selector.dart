import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_theme/app_theme_cubit.dart';
import 'package:flutter_forge/core/constants/constants.dart';
import 'package:flutter_forge/core/theme/app_colors.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppThemeCubit, ThemeMode, ThemeMode>(
      selector: (ThemeMode mode) => mode,
      builder: (BuildContext context, ThemeMode current) {
        return Container(
          padding: EdgeInsets.all(AppSizes.xs),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: Border.all(color: AppColors.lightDivider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values
                .map(
                  (ThemeMode mode) => _ThemeOption(
                    mode: mode,
                    current: current,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.mode,
    required this.current,
  });
  final ThemeMode mode;
  final ThemeMode current;

  bool get _isSelected => current == mode;

  IconData get _icon => switch (mode) {
        ThemeMode.light => Icons.light_mode_rounded,
        ThemeMode.dark => Icons.dark_mode_rounded,
        ThemeMode.system => Icons.brightness_auto_rounded,
      };

  String get _label => switch (mode) {
        ThemeMode.light => AppConstants.lightMode,
        ThemeMode.dark => AppConstants.darkMode,
        ThemeMode.system => AppConstants.systemMode,
      };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Tooltip(
      message: _label,
      child: GestureDetector(
        onTap: () => context.read<AppThemeCubit>().setMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: AppSizes.xs),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: _isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            boxShadow: _isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                _icon,
                size: AppSizes.iconSm,
                color: _isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
              SizedBox(width: AppSizes.xs),
              Text(
                _label,
                style: AppTextStyles.labelSmall.copyWith(
                  color:
                      _isSelected ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

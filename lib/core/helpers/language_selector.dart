import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_locale/app_locale_cubit.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/theme/app_colors.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppLocaleCubit, AppLocale, AppLocale>(
      selector: (AppLocale locale) => locale,
      builder: (BuildContext context, AppLocale current) {
        return Container(
          padding: EdgeInsets.all(AppSizes.xs),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: Border.all(color: AppColors.lightDivider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: AppLocale.values
                .map(
                  (AppLocale lang) => _LangOptionWidget(
                    lang: lang,
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

class _LangOptionWidget extends StatelessWidget {
  const _LangOptionWidget({
    required this.lang,
    required this.current,
  });

  final AppLocale lang;
  final AppLocale current;

  bool get _isSelected => current == lang;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Tooltip(
      message: lang.displayName,
      child: GestureDetector(
        onTap: () => context.read<AppLocaleCubit>().setLocale(lang),
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
              Text(
                lang.flag,
                style: const TextStyle(fontSize: 16),
              ),
              SizedBox(width: AppSizes.xs),
              Text(
                lang.short,
                style: AppTextStyles.labelSmall.copyWith(
                  color: _isSelected ? Colors.white : theme.colorScheme.onSurface,
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

import 'package:flutter/widgets.dart';
import 'generated/l10n.dart';

export 'generated/l10n.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

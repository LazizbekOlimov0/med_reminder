import 'package:flutter/cupertino.dart';
import 'app_localizations.dart';

extension AppLocalizationsExt on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
}